# This file contains stuff to help export whole Blender scenes
# to a scene that can be loaded in the engine

import bpy
import os
import pathlib
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
from . import material

Entity_Version = 2

class Entity:
    def __init__(self):
        import uuid

        self.blender_obj : bpy.types.Object = None
        self.guid : str = uuid.uuid4().hex
        self.type : str = ''
        self.name : str = ""
        self.parent : Entity = None
        self.world_transform  = mathutils.Matrix.Identity(4)

    def WriteToFile(self, file):
        local_transform = self.world_transform
        if self.parent is not None:
            local_transform = self.parent.world_transform.inverted() @ local_transform

        local_position, local_rotation, local_scale = local_transform.decompose()

        fw = file.write
        fw(f"1:\n")
        fw(f"  @guid 1: 0x{self.guid}\n")
        fw(f"  @name 2: \"{self.name}\"\n")
        fw(f"  @local_position 3: [{local_position.x}, {local_position.y}, {local_position.z}]\n")
        fw(f"  @local_rotation 4: [{local_rotation.x}, {local_rotation.y}, {local_rotation.z}, {local_rotation.w}]\n")
        fw(f"  @local_scale 5: [{local_scale.x}, {local_scale.y}, {local_scale.z}]\n")
        if self.parent is not None:
            fw(f"  @parent 6: 0x{self.parent.guid}\n")
        else:
            fw(f"  @parent 6: 0x00000000000000000000000000000000\n")

class EmptyEntity(Entity):
    def __init__(self):
        super().__init__()
        self.type = 'EmptyEntity'

    def WriteToFile(self, file):
        super().WriteToFile(file)

class StaticMeshEntity(Entity):
    def __init__(self):
        super().__init__()
        self.type = 'StaticMeshEntity'
        self.mesh_name : str = ""
        self.material_name : str = ""
        self.cast_shadows : bool = True

    def WriteToFile(self, file):
        super().WriteToFile(file)

        fw = file.write

        fw(f"@mesh 2:\n")

        if len(self.mesh_name) > 0:
            fw(f"  @mesh 2: \"{self.mesh_name}\"\n")

        if len(self.material_name) > 0:
            fw(f"  @material 3: \"{self.material_name}\"\n")

        fw(f"  @cast_shadows 4: {self.cast_shadows}\n")

class PointLightEntity(Entity):
    def __init__(self):
        super().__init__()
        self.type = 'PointLightEntity'
        self.light_color : utils.Vec3f = (1,1,1)
        self.light_intensity : float = 1
        self.cast_shadows : bool = False

    def WriteToFile(self, file):
        super().WriteToFile(file)

        fw = file.write
        fw(f"@light 2:\n")
        fw(f"  @color 2: [{self.light_color[0]}, {self.light_color[1]}, {self.light_color[2]}]\n")
        fw(f"  @intensity 3: {self.light_intensity}\n")
        fw(f"  @cast_shadows 4: {self.cast_shadows}\n")

class DirectionalLightEntity(Entity):
    def __init__(self):
        super().__init__()
        self.type = 'DirectionalLightEntity'
        self.light_color : utils.Vec3f = (1,1,1)
        self.light_intensity : float = 1
        self.cast_shadows : bool = True

    def WriteToFile(self, file):
        super().WriteToFile(file)

        fw = file.write
        fw(f"@light 2:\n")
        fw(f"  @color 2: [{self.light_color[0]}, {self.light_color[1]}, {self.light_color[2]}]\n")
        fw(f"  @intensity 3: {self.light_intensity}\n")
        fw(f"  @cast_shadows 4: {self.cast_shadows}\n")

def EntityFromBlenderObject(
    context : bpy.types.Context,
    root: Entity,
    all_entities : List[Entity],
    obj : bpy.types.Object,
    dest_coordinate_system : utils.CoordinateSystem
):
    entity = None

    options = context.scene.vk_engine_entities_export_options

    if obj.type == 'EMPTY':
        entity = EmptyEntity()
    elif obj.type == 'MESH':
        mesh = obj.data

        filename = os.path.basename(obj.name)
        filename = f"{filename}.mesh"
        filename = os.path.join(bpy.path.abspath(options.meshes_directory), filename)

        entity = StaticMeshEntity()
        entity.mesh_name = utils.GetAssetName(filename)

        if len(obj.material_slots) > 0:
            mat = obj.material_slots[0]

            filename = f"{obj.material_slots[0].name}.mat"
            filename = os.path.join(bpy.path.abspath(options.materials_directory), filename)

            entity.material_name = utils.GetAssetName(filename)

    elif obj.type == 'LIGHT':
        light = obj.data

        if light.type == 'POINT':
            entity = PointLightEntity()
            entity.light_color = light.color
        elif light.type == 'SUN':
            entity = DirectionalLightEntity()
            entity.light_color = light.color
            entity.cast_shadows = light.use_shadow

    if entity is not None:
        for e in all_entities:
            if e.blender_obj == obj.parent:
                entity.parent = e
                break

        if entity.parent is None:
            entity.parent = root

        entity.blender_obj = obj
        entity.name = obj.name
        entity.world_transform = obj.matrix_world @ dest_coordinate_system.ConversionMatrix().to_4x4()

        all_entities.append(entity)

    return entity

class EntitiesExportOptions(bpy.types.PropertyGroup):
    only_selected : BoolProperty(
        name = "Only Selected",
        description = "Export only the selected objects.",
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
        default = "//Scenes"
    )

    meshes_directory : StringProperty(
        name = "Meshes Directory",
        description = "Specify the directory where meshes are stored.",
        subtype = "DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default = "//Meshes"
    )

    textures_directory : StringProperty(
        name = "Textures Directory",
        description = "Specify the directory where textures are stored.",
        subtype = "DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default = "//Textures"
    )

    materials_directory : StringProperty(
        name = "Materials Directory",
        description = "Specify the directory where materials are stored.",
        subtype = "DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default = "//Materials"
    )

    create_empty_root_entity : BoolProperty(
        name = "Create Empty Root Entity",
        description = "Create an empty root entity that all entities are parented to",
        default = True
    )

class EXPORTER_OT_VkEngineEntities(bpy.types.Operator):
    bl_idname = "export.vk_engine_scene"
    bl_label = "Export Vk-Engine scene (.scene)"
    bl_description = "Export Vk-Engine scene (.scene)"
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context : bpy.types.Context):
        context.window.cursor_set('WAIT')

        options = context.scene.vk_engine_entities_export_options

        objects : List[bpy.types.Object] = []
        if options.only_selected:
            objects = context.selected_objects
        else:
            objects = context.scene.objects

        all_entities : List[Entity] = []

        dest_coordinate_system = utils.CoordinateSystem.FromString(options.coordinate_system)

        root = None
        if options.create_empty_root_entity:
            root = EmptyEntity()
            root.world_transform = dest_coordinate_system.ConversionMatrix().to_4x4()
            root.name = f"{os.path.splitext(os.path.basename(context.blend_data.filepath))[0]}_Root"
            all_entities.append(root)

        for obj in objects:
            entity = EntityFromBlenderObject(context, root, all_entities, obj, dest_coordinate_system)

        scene_name = os.path.splitext(os.path.basename(context.blend_data.filepath))[0]
        output_dir = f"{scene_name}.scene"
        output_dir = os.path.join(bpy.path.abspath(options.output_directory), output_dir)

        try:
            for f in os.listdir(output_dir):
                os.remove(os.path.join(output_dir, f))
        except:
            pass

        os.makedirs(output_dir, exist_ok=True)

        for e in all_entities:
            filename = f"{e.guid}_{e.type}.entity"
            filename = os.path.join(output_dir, filename)
            with open(filename, "w", newline='\n') as file:
                # Hack: we need the transform of the root entity to be identity
                # when writing to the file, but we need it to be the same as the
                # coordinate system conversion matrix when computing the children's
                # local transform
                if e is root:
                    prev_transform = e.world_transform
                    e.world_transform = mathutils.Matrix.Identity(4)

                e.WriteToFile(file)

                if e is root:
                    e.world_transform = prev_transform

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class VIEW3D_PT_VkEngineEntitiesExport(bpy.types.Panel):
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"

    bl_category = "Vk-Engine Tools"
    bl_label = "Export Entitie(s)"

    def draw(self, context : bpy.types.Context):
        layout = self.layout
        options = context.scene.vk_engine_entities_export_options

        layout.row().prop(options, "only_selected")
        layout.row().prop(options, "coordinate_system")
        layout.row().prop(options, "output_directory")
        layout.row().prop(options, "meshes_directory")
        layout.row().prop(options, "textures_directory")
        layout.row().prop(options, "materials_directory")
        layout.row().prop(options, "create_empty_root_entity")

        valid = options.output_directory != "" and options.meshes_directory != "" and options.textures_directory != "" and options.materials_directory != ""

        row = layout.row()
        row.enabled = valid
        row.operator(EXPORTER_OT_VkEngineEntities.bl_idname, text="Export Entitie(s)")

classes = (
    VIEW3D_PT_VkEngineEntitiesExport,
    EXPORTER_OT_VkEngineEntities,
    EntitiesExportOptions,
)

def register():
    for cl in classes:
        bpy.utils.register_class(cl)

    bpy.types.Scene.vk_engine_entities_export_options = PointerProperty(type=EntitiesExportOptions)

def unregister():
    for cl in classes:
        bpy.utils.unregister_class(cl)
