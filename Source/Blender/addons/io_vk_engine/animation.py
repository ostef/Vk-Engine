import bpy
import mathutils

from . import utils

from typing import (
    List,
    Dict,
    Tuple
)

from bpy.props import (
    IntProperty,
    BoolProperty,
    EnumProperty,
    StringProperty,
    PointerProperty,
)

class JointSample:
    def __init__(
        self,
        local_position : utils.Vec3f,
        local_orientation : utils.Quatf,
        local_scale : utils.Vec3f
    ):
        self.local_position = local_position
        self.local_orientation = local_orientation
        self.local_scale = local_scale

class ArmaturePose:
    def __init__(
        self,
        joint_count : int
    ):
        self.joints : List[JointSample] = [
            JointSample((0,0,0), (0,0,0,1), (1,1,1))
            for i in range(joint_count)
        ]

class SampledAnimation:
    def __init__(
        self
    ):
        self.name_to_joint_id : Dict[str, int] = {}
        self.poses : List[ArmaturePose] = []

    def FromAction(
        blender_obj : bpy.types.Object,
        pose_obj : bpy.types.Object,
        blender_action : bpy.types.Action,
        frame_begin : int,
        frame_end : int,
        frame_step : int,
        apply_object_transform : bool,
        dest_coordinate_system : utils.CoordinateSystem,
        transform_matrix : mathutils.Matrix
    ):
        transform = transform_matrix

        if apply_object_transform:
            transform = transform @ blender_obj.matrix_world

        transform = transform @ dest_coordinate_system.ConversionMatrix().to_4x4()

        scale_fixup = dest_coordinate_system.ScaleConversionMatrix().to_4x4()

        def AppendPose(
            anim : SampledAnimation,
            blender_pose : bpy.types.Pose
        ):
            pose = ArmaturePose(len(anim.name_to_joint_id))
            for bone in blender_pose.bones:
                if bone.name not in anim.name_to_joint_id:
                    continue

                local_transform = transform @ bone.matrix
                local_transform = local_transform @ scale_fixup

                if bone.parent is not None:
                    parent_matrix = transform @ bone.parent.matrix
                    parent_matrix = parent_matrix @ scale_fixup

                    local_transform = parent_matrix.inverted() @ local_transform

                location, orientation, scale = local_transform.decompose()

                joint_index = anim.name_to_joint_id[bone.name]
                pose.joints[joint_index] = JointSample(
                    location,
                    (
                        orientation.x,
                        orientation.y,
                        orientation.z,
                        orientation.w,
                    ),
                    scale
                )

            anim.poses.append(pose)

        result = SampledAnimation()
        prev_action = blender_obj.animation_data.action
        prev_frame = bpy.context.scene.frame_current

        blender_obj.animation_data.action = blender_action
        bpy.context.scene.frame_set(frame_begin)

        # Initialize the name to joint id dict
        joint_count = 0
        for bone in pose_obj.pose.bones:
            if not bone.bone.use_deform:
                continue

            result.name_to_joint_id.update({ bone.name : joint_count })
            joint_count += 1

        for frame in range(frame_begin, frame_end + 1, frame_step):
            bpy.context.scene.frame_set(frame)
            AppendPose(result, pose_obj.pose)

        bpy.context.scene.frame_set(prev_frame)
        blender_obj.animation_data.action = prev_action

        return result

    def WriteBinary(self, filename : str):
        import struct

        with open(filename, "wb") as file:
            fw = file.write

            fw(b"ARMATURE_ANIMATION")

            fw(struct.pack("<I", 10000)) # Version

            fw(struct.pack("<I", len(self.poses)))
            fw(struct.pack("<I", len(self.name_to_joint_id)))
            for name in self.name_to_joint_id:
                fw(b"%s\0" % bytes(name, 'UTF-8'))

            for pose in self.poses:
                for joint in pose.joints:
                    fw(struct.pack("<fff", *joint.local_position))
                    fw(struct.pack("<ffff", *joint.local_orientation))
                    fw(struct.pack("<fff", *joint.local_scale))

def ExportAnimationsForArmature(
    context : bpy.types.Context,
    dirname : str,
    armature_obj : bpy.types.Object,
    pose_obj : bpy.types.Object,
    actions : List[bpy.types.Action],
    use_action_frame_range : bool,
    frame_step : int,
    apply_object_transform : bool,
    dest_coordinate_system : utils.CoordinateSystem,
    transform_matrix : mathutils.Matrix = mathutils.Matrix.Identity(4)
):
    import os

    os.makedirs(dirname, exist_ok = True)

    if bpy.ops.object.mode_set.poll():
        bpy.ops.object.mode_set(mode = 'OBJECT')

    if armature_obj.animation_data is None or pose_obj.pose is None:
        return

    for action in actions:
        output_filename = os.path.join(dirname, action.name) + ".anim"
        if use_action_frame_range:
            frame_begin, frame_end = (
                int(action.frame_range[0]),
                int(action.frame_range[1])
            )
        else:
            frame_begin, frame_end = (
                int(context.scene.frame_start),
                int(context.scene.frame_end)
            )

        anim = SampledAnimation.FromAction(armature_obj, pose_obj, action, frame_begin, frame_end, frame_step, apply_object_transform, dest_coordinate_system, transform_matrix)
        anim.WriteBinary(output_filename)

        print(f"Exported animation clip {action.name} to file {output_filename}")

class ActionWrapperProperty(bpy.types.PropertyGroup):
    action: PointerProperty(
        name="Action",
        type=bpy.types.Action
    )

class AnimExportOptions(bpy.types.PropertyGroup):
    apply_object_transform : BoolProperty(
        name="Apply Object Transform",
        description="Apply the object transform matrix when exporting.",
        default=False
    )

    coordinate_system : StringProperty(
        name="Coordinate System",
        description="Specify an output coordinate system in the form [+-][XYZ].",
        default="+X+Y+Z"
    )

    output_directory : StringProperty(
        name="Output Directory",
        description="Specify the output directory.",
        subtype="DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default="//Animations"
    )

    control_armature : PointerProperty(
        name="Control Armature",
        description="Armature object on which the action is applied.",
        type=bpy.types.Object
    )

    deform_armature : PointerProperty(
        name="Deform Armature",
        description="Armature object that deforms the mesh.",
        type=bpy.types.Object
    )

    action : PointerProperty(
        name="Action",
        description="Action to export.",
        type=bpy.types.Action
    )

class EXPORTER_OT_VkEngineAnimation(bpy.types.Operator):
    bl_idname = "export.vk_engine_anim"
    bl_label = "Export Vk-Engine animations (.anim)"
    bl_description = "Export Vk-Engine animations (.anim)"
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context : bpy.types.Context):
        context.window.cursor_set('WAIT')

        options = context.scene.vk_engine_animation_export_options

        armature_object : bpy.types.Object = options.control_armature
        pose_object : bpy.types.Object = options.deform_armature
        actions : List[bpy.types.Action] = []

        actions.append(options.action)

        dest_coordinate_system = utils.CoordinateSystem.FromString(options.coordinate_system)

        if armature_object is not None and pose_object is not None:
            ExportAnimationsForArmature(
                context,
                bpy.path.abspath(options.output_directory),
                armature_object,
                pose_object,
                actions,
                use_action_frame_range=True,
                frame_step=1,
                apply_object_transform=options.apply_object_transform,
                dest_coordinate_system=dest_coordinate_system
            )

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class VIEW3D_PT_VkEngineAnimationExport(bpy.types.Panel):
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"

    bl_category = "Vk-Engine Tools"
    bl_label = "Export Animation(s)"

    def draw(self, context : bpy.types.Context):
        layout = self.layout
        options = context.scene.vk_engine_animation_export_options

        layout.row().prop(options, "apply_object_transform")
        layout.row().prop(options, "coordinate_system")
        layout.row().prop(options, "output_directory")
        layout.row().prop(options, "control_armature")
        layout.row().prop(options, "deform_armature")
        layout.row().prop(options, "action")

        valid = options.output_directory != "" and options.control_armature is not None and options.deform_armature is not None and options.action is not None

        row = layout.row()
        row.enabled = valid
        row.operator(EXPORTER_OT_VkEngineAnimation.bl_idname, text="Export Animation(s)")

classes = (
    VIEW3D_PT_VkEngineAnimationExport,
    EXPORTER_OT_VkEngineAnimation,
    AnimExportOptions,
)

def register():
    for cl in classes:
        bpy.utils.register_class(cl)

    bpy.types.Scene.vk_engine_animation_export_options = PointerProperty(type=AnimExportOptions)

def unregister():
    for cl in classes:
        bpy.utils.unregister_class(cl)
