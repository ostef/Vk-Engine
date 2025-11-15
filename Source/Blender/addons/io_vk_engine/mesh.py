import bpy
import bmesh
import mathutils

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

from . import utils

class ArmatureJoint:
    def __init__(
        self,
        name : str,
        parent_id : int,
        local_position : utils.Vec3f,
        local_orientation : utils.Quatf,
        local_scale : utils.Vec3f,
    ):
        self.name = name
        self.parent_id = parent_id
        self.local_position = local_position
        self.local_orientation = local_orientation
        self.local_scale = local_scale

class Vertex:
    def __init__(
        self,
        position : utils.Vec3f,
        normal   : utils.Vec3f,
        tangent  : utils.Vec4f,
        tex_coords : utils.Vec2f,
        joint_ids : utils.Vec4i,
        joint_weights : utils.Vec3f,
    ):
        self.position = position
        self.normal = normal
        self.tangent = tangent
        self.tex_coords = tex_coords
        self.joint_ids = joint_ids
        self.joint_weights = joint_weights

    def __hash__(self):
        return hash((self.position, self.normal, self.tangent, self.tex_coords, self.joint_ids, self.joint_weights))

    def __eq__(a, b):
        return a.position == b.position and a.normal == b.normal and a.tangent == b.tangent and a.tex_coords == b.tex_coords and a.joint_ids == b.joint_ids and a.joint_weights == b.joint_weights

class Mesh:
    def __init__(self, has_tangents : bool):
        self.name_to_joint_id : Dict[str, int] = {}
        self.joints : List[ArmatureJoint] = []
        self.verts : List[Vertex] = []
        self.tris : List[Tuple[int, int, int]] = []
        self.has_tangents = has_tangents

    def WriteBinarySkinned(self, filename : str):
        import struct

        with open(filename, "wb") as file:
            fw = file.write

            fw(b"SKINNED_MESH")
            fw(struct.pack("<I", 10000)) # File version

            flags = 0
            if self.has_tangents:
                flags |= 0x1

            fw(struct.pack("<I", flags))

            fw(struct.pack("<I", len(self.verts)))
            fw(struct.pack("<I", len(self.tris)))

            for vert in self.verts:
                fw(struct.pack("<fff", *vert.position))
                fw(struct.pack("<fff", *vert.normal))
                fw(struct.pack("<ffff", *vert.tangent))
                fw(struct.pack("<ff", *vert.tex_coords))
                fw(struct.pack("<hhhh", *vert.joint_ids))
                fw(struct.pack("<fff", *vert.joint_weights))

            for tri in self.tris:
                fw(struct.pack("<III", *tri))

            fw(struct.pack("<h", len(self.joints)))
            for joint in self.joints:
                fw(b"%s\0" % bytes(joint.name, 'UTF-8'))

                fw(struct.pack("<fff", *joint.local_position))
                fw(struct.pack("<ffff", *joint.local_orientation))
                fw(struct.pack("<fff", *joint.local_scale))

                fw(struct.pack("<h", joint.parent_id))

    def WriteBinaryStatic(self, filename : str):
        import struct

        if len(self.joints) != 0:
            print(f"WARNING: Exporting static mesh to file {filename} but it has skinning data")

        with open(filename, "wb") as file:
            fw = file.write

            fw(b"STATIC_MESH")
            fw(struct.pack("<I", 10000)) # File version

            flags = 0
            if self.has_tangents:
                flags |= 0x1

            fw(struct.pack("<I", flags))

            fw(struct.pack("<I", len(self.verts)))
            fw(struct.pack("<I", len(self.tris)))

            for vert in self.verts:
                fw(struct.pack("<fff", *vert.position))
                fw(struct.pack("<fff", *vert.normal))
                fw(struct.pack("<ffff", *vert.tangent))
                fw(struct.pack("<ff", *vert.tex_coords))

            for tri in self.tris:
                fw(struct.pack("<III", *tri))

    def FromMeshAndArmature(
        blender_obj : bpy.types.Object,
        blender_mesh : bpy.types.Mesh,
        blender_armature : bpy.types.Armature,
        apply_object_transform : bool,
        dest_coordinate_system : utils.CoordinateSystem,
        transform_matrix : mathutils.Matrix,
        reverse_triangle_ordering : bool,
        export_tangents : bool
    ):
        transform = transform_matrix

        if apply_object_transform:
            transform = transform @ blender_obj.matrix_world

        transform = transform @ dest_coordinate_system.ConversionMatrix().to_4x4()

        scale_fixup = dest_coordinate_system.ScaleConversionMatrix().to_4x4()

        def AppendHierarchy(joints : List[ArmatureJoint], parent_id : int, bone : bpy.types.Bone):
            bone_transform = transform @ bone.matrix_local
            bone_transform = bone_transform @ scale_fixup

            if bone.parent is not None:
                parent_transform = transform @ bone.parent.matrix_local
                parent_transform = parent_transform @ scale_fixup

                local_transform = parent_transform.inverted() @ bone_transform
            else:
                local_transform = bone_transform

            local_position, local_orientation, local_scale = local_transform.decompose()

            joint = ArmatureJoint(
                bone.name,
                parent_id,
                local_position,
                (local_orientation.x, local_orientation.y, local_orientation.z, local_orientation.w),
                local_scale,
            )

            joint_id = len(joints)
            joints.append(joint)

            for child in bone.children:
                if child.use_deform:
                    AppendHierarchy(joints, joint_id, child)

        try:
            if export_tangents:
                blender_mesh.calc_tangents()
        except:
            export_tangents = False

        result = Mesh(has_tangents=export_tangents)

        normal_transform = transform.inverted().transposed()

        if blender_armature is not None:
            # Fill armature data
            root = None

            # Find the root bone
            for b in blender_armature.bones:
                if b.parent is None and b.use_deform:
                    if root is not None:
                        raise Exception("Found multiple root bones in armature.")
                    root = b

            if root is None:
                raise Exception("Could not find deform root bone.")

            AppendHierarchy(result.joints, -1, root)

            if len(result.joints) > 0x7fff:
                raise Exception(f"Armature has { len(result.joints) } bones, which is more than the maximum allowed of {0x7fff}.")

            for i, b in enumerate(result.joints):
                result.name_to_joint_id.update({ b.name : i })

        vert_group_names = { g.index : g.name for g in blender_obj.vertex_groups }
        vertices_dict = {}
        uv_layer = None
        if blender_mesh.uv_layers.active is not None:
            uv_layer = blender_mesh.uv_layers.active.data

        if uv_layer is None:
            raise Exception(f"Mesh has no UVs so it will not render properly in the engine, because we need UVs to calculate tangent information.")

        for i, poly in enumerate(blender_mesh.loop_triangles):
            tri = []

            for vert_index, loop_index in zip(poly.vertices, poly.loops):
                position = blender_mesh.vertices[vert_index].co
                position = transform @ position

                normal = blender_mesh.loops[loop_index].normal
                normal = normal_transform @ normal

                if export_tangents:
                    tangent = blender_mesh.loops[loop_index].tangent
                    tangent = normal_transform @ tangent

                    # How should this be transformed based on the transform?
                    bitangent_sign = blender_mesh.loops[loop_index].bitangent_sign
                else:
                    tangent = mathutils.Vector((0, 0, 0))
                    bitangent_sign = 0

                uv_coords = (0,0)
                if uv_layer is not None:
                    uv_coords = uv_layer[loop_index].uv

                groups = blender_mesh.vertices[vert_index].groups

                if len(groups) != 0 and blender_armature is None:
                    raise Exception("Mesh has vertices assigned to vertex groups, but we could not find an armature associated with it. Make sure it is parented to an armature, or it has a valid skin modifier.")

                if len(groups) > 4:
                    raise Exception(f"Vertex has more than 4 groups assigned to it.")

                group_indices = [
                    groups[i].group
                    if i < len(groups)
                    else -1
                    for i in range(4)
                ]

                weights = [
                    round(groups[i].weight, 6)
                    if i < len(groups)
                    else 0
                    for i in range(3)
                ]

                joint_ids = [-1 for i in range(4)]

                for i in range(4):
                    if group_indices[i] != -1:
                        name = vert_group_names[group_indices[i]]
                        if name not in result.name_to_joint_id:
                            raise Exception(f"Vertex is assigned to group {name} but we could not find a deform bone with this name in the armature.")

                        joint_ids[i] = result.name_to_joint_id[name]

                vertex = Vertex(
                    tuple(position),
                    tuple(normal),
                    (tangent.x, tangent.y, tangent.z, bitangent_sign),
                    tuple(uv_coords),
                    tuple(joint_ids),
                    tuple(weights)
                )

                if vertex in vertices_dict:
                    result_vert_index = vertices_dict[vertex]
                else:
                    result_vert_index = len(result.verts)
                    result.verts.append(vertex)
                    vertices_dict.update({ vertex : result_vert_index })

                tri.append(result_vert_index)

            if reverse_triangle_ordering:
                result.tris.append((tri[0], tri[2], tri[1]))
            else:
                result.tris.append((tri[0], tri[1], tri[2]))

        return result

def ExportMeshes(
    context : bpy.types.Context,
    objects : List[bpy.types.Object],
    dirname : str,
    apply_object_transform : bool,
    dest_coordinate_system : utils.CoordinateSystem,
    transform_matrix : mathutils.Matrix = mathutils.Matrix.Identity(4),
    reverse_triangle_ordering : bool = False,
    export_tangents : bool = True
):
    import os

    os.makedirs(dirname, exist_ok=True)

    if bpy.ops.object.mode_set.poll():
        bpy.ops.object.mode_set(mode = 'OBJECT')

    for obj in objects:
        try:
            me = obj.to_mesh()
        except RuntimeError:
            continue

        if len(obj.material_slots) > 1:
            print("ERROR: Object has multiple materials assigned to it. Separate mesh by material first")
            continue

        armature_obj = obj.find_armature()
        armature : bpy.types.Armature = None
        if armature_obj is not None:
            armature = armature_obj.data.copy()

        result = Mesh.FromMeshAndArmature(
            obj, me, armature,
            apply_object_transform, dest_coordinate_system, transform_matrix,
            reverse_triangle_ordering, export_tangents
        )

        output_filename = os.path.join(dirname, obj.name) + ".mesh"
        if len(result.joints) == 0:
            result.WriteBinaryStatic(output_filename)
        else:
            result.WriteBinarySkinned(output_filename)

        me.free_tangents()
        obj.to_mesh_clear()

        print(f"Exported mesh {obj.name} to file {output_filename}")

class MeshExportOptions(bpy.types.PropertyGroup):
    only_selected : BoolProperty(
        name = "Only Selected",
        description = "Export only the active action of the selected objects.",
        default = True
    )

    apply_object_transform : BoolProperty(
        name = "Apply Object Transform",
        description = "Apply the object transform matrix when exporting.",
        default = False
    )

    export_tangents : BoolProperty(
        name = "Export Tangents",
        description = "Exporting the tangents that Blender calculated with the mesh. If this is not set the Game will calculate the tangents when the mesh is loaded, which is slower and can cause the mesh to not be rendered the same way as in Blender.",
        default = True
    )

    coordinate_system : StringProperty(
        name = "Coordinate System",
        description = "Specify an output coordinate system in the form [+-][XYZ].",
        default = "+X+Y+Z"
    )

    output_directory : StringProperty(
        name = "Output Directory",
        description = "Specify the output directory.",
        subtype = "DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default = "//Meshes"
    )

class EXPORTER_OT_VkEngineMesh(bpy.types.Operator):
    bl_idname = "export.vk_engine_mesh"
    bl_label = "Export Vk-Engine meshes (.mesh)"
    bl_description = "Export Vk-Engine meshes (.mesh)"
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context : bpy.types.Context):
        context.window.cursor_set('WAIT')

        options = context.scene.vk_engine_mesh_export_options

        objects : List[bpy.types.Object] = []
        if options.only_selected:
            objects = context.selected_objects
        else:
            objects = context.scene.objects

        dest_coordinate_system = utils.CoordinateSystem.FromString(options.coordinate_system)

        ExportMeshes(
           context,
           objects,
           bpy.path.abspath(options.output_directory),
           apply_object_transform = options.apply_object_transform,
           dest_coordinate_system = dest_coordinate_system,
           export_tangents = options.export_tangents
        )

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class VIEW3D_PT_VkEngineMeshExport(bpy.types.Panel):
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"

    bl_category = "Vk-Engine Tools"
    bl_label = "Export Mesh(es)"

    def draw(self, context : bpy.types.Context):
        layout = self.layout
        options = context.scene.vk_engine_mesh_export_options

        layout.row().prop(options, "only_selected")
        layout.row().prop(options, "apply_object_transform")
        layout.row().prop(options, "export_tangents")
        layout.row().prop(options, "coordinate_system")
        layout.row().prop(options, "output_directory")

        valid = options.output_directory != ""

        row = layout.row()
        row.enabled = valid
        row.operator(EXPORTER_OT_VkEngineMesh.bl_idname, text="Export Meshe(s)")

classes = (
    VIEW3D_PT_VkEngineMeshExport,
    EXPORTER_OT_VkEngineMesh,
    MeshExportOptions,
)

def register():
    for cl in classes:
        bpy.utils.register_class(cl)

    bpy.types.Scene.vk_engine_mesh_export_options = PointerProperty(type=MeshExportOptions)

def unregister():
    for cl in classes:
        bpy.utils.unregister_class(cl)
