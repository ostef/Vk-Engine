import bpy
import os

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

def GetDefaultFloatValueOfNodeInput(node : bpy.types.ShaderNode, input_name : str, default = 0) -> float:
    if input_name not in node.inputs:
        return default

    socket = node.inputs[input_name]
    if socket.is_linked or type(socket) is not bpy.types.NodeSocketFloatFactor:
        return default

    return socket.default_value

def GetDefaultRGBAValueOfNodeInput(node : bpy.types.ShaderNode, input_name : str, default = (1,1,1,1)) -> utils.Vec4f:
    if input_name not in node.inputs:
        return default

    socket = node.inputs[input_name]
    if socket.is_linked or type(socket) is not bpy.types.NodeSocketColor:
        return default

    return socket.default_value

def GetTextureNameOfNode(node : bpy.types.ShaderNode) -> str:
    result = ""
    if type(node) is bpy.types.ShaderNodeTexImage:
        result = node.image.filepath
    elif type(node) is bpy.types.ShaderNodeSeparateColor:
        sock = node.inputs["Color"]
        if sock.is_linked:
            result = GetTextureNameOfNode(sock.links[0].from_node)
    elif type(node) is bpy.types.ShaderNodeMix:
        A = node.inputs["A"]
        if A.is_linked:
            result = GetTextureNameOfNode(A.links[0].from_node)

        B = node.inputs["B"]
        if len(result) == 0 and B.is_linked:
            result = GetTextureNameOfNode(B.links[0].from_node)
    elif type(node) is bpy.types.ShaderNodeNormalMap:
        sock = node.inputs["Color"]
        if sock.is_linked:
            result = GetTextureNameOfNode(sock.links[0].from_node)

    if len(result) > 0:
        return os.path.normpath(bpy.path.abspath(result))

    return ""

class Material:
    def __init__(self):
        self.name : str = ""
        self.base_color_tint : utils.Vec3f = (1,1,1)
        self.base_color : str = ""
        self.metallic_roughness_map : str = ""
        self.metallic : float = 0
        self.roughness : float = 0.5
        self.normal_map : str = ""
        self.emissive : str = ""
        self.emissive_tint : utils.Vec3f = (1,1,1)
        self.emissive_strength : float = 0

    def FromBlenderMaterial(material : bpy.types.Material):
        result = Material()
        result.name = f"{material.name}.mat"

        if material.node_tree is None or "Principled BSDF" not in material.node_tree.nodes:
            return result

        principled = material.node_tree.nodes["Principled BSDF"]

        base_color = principled.inputs["Base Color"]
        result.base_color_tint = (base_color.default_value[0], base_color.default_value[1], base_color.default_value[2])
        if base_color.is_linked:
            in_node = base_color.links[0].from_node
            result.base_color = GetTextureNameOfNode(in_node)

        metallic = principled.inputs["Metallic"]
        result.metallic = metallic.default_value
        if metallic.is_linked:
            in_node = metallic.links[0].from_node
            metallic_texture = GetTextureNameOfNode(in_node)
        else:
            metallic_texture = ""

        roughness = principled.inputs["Roughness"]
        result.roughness = roughness.default_value
        if roughness.is_linked:
            in_node = roughness.links[0].from_node
            roughness_texture = GetTextureNameOfNode(in_node)
        else:
            roughness_texture = ""

        if metallic_texture != roughness_texture:
            print(f"Material {material.name}: Invalid material settings, expected metallic and roughness texture to be the same (got {metallic_texture} and {roughness_texture}")

        if len(metallic_texture) > 0:
            result.metallic_roughness_map = metallic_texture
        else:
            result.metallic_roughness_map = roughness_texture

        normal = principled.inputs["Normal"]
        if normal.is_linked:
            in_node = normal.links[0].from_node
            result.normal_map = GetTextureNameOfNode(in_node)

        # print(f"Material: {material.name}")
        # print(f"  Albedo: {result.base_color_texture} {result.base_color}")
        # print(f"  Metallic Roughness: {result.metallic_roughness_map} {result.metallic} {result.roughness}")
        # print(f"  Normal Map: {result.normal_map}")

        if len(result.base_color) > 0:
            result.base_color = utils.GetAssetName(result.base_color)
        if len(result.metallic_roughness_map) > 0:
            result.metallic_roughness_map = utils.GetAssetName(result.metallic_roughness_map)
        if len(result.normal_map) > 0:
            result.normal_map = utils.GetAssetName(result.normal_map)
        if len(result.emissive) > 0:
            result.emissive = utils.GetAssetName(result.emissive)

        return result

    def WriteToFile(self, file):
        fw = file.write
        fw(f"@type 1: Opaque\n")
        fw(f"@base_color_tint 2: [{self.base_color_tint[0]}, {self.base_color_tint[1]}, {self.base_color_tint[2]}]\n")
        if len(self.base_color) > 0:
            fw(f"@base_color 3: \"{self.base_color}\"\n")
        if len(self.normal_map) > 0:
            fw(f"@normal_map 4: \"{self.normal_map}\"\n")
        fw(f"@metallic 5: {self.metallic}\n")
        fw(f"@roughness 6: {self.roughness}\n")
        if len(self.metallic_roughness_map) > 0:
            fw(f"@metallic_roughness_map 7: \"{self.metallic_roughness_map}\"\n")
        fw(f"@emissive_tint 8: [{self.emissive_tint[0]}, {self.emissive_tint[1]}, {self.emissive_tint[2]}]\n")
        if len(self.emissive) > 0:
            fw(f"@emissive 9: \"{self.emissive}\"\n")
        fw(f"@emissive_strength 10: {self.emissive_strength}\n")

class MaterialExportOptions(bpy.types.PropertyGroup):
    output_directory : StringProperty(
        name = "Output Directory",
        description = "Specify the output directory.",
        subtype = "DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default = "//Materials"
    )

class EXPORTER_OT_VkEngineMaterial(bpy.types.Operator):
    bl_idname = "export.vk_engine_material"
    bl_label = "Export Vk-Engine materials (.mat)"
    bl_description = "Export Vk-Engine materials (.mat)"
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context : bpy.types.Context):
        context.window.cursor_set('WAIT')

        options = context.scene.vk_engine_material_export_options

        output_dir = bpy.path.abspath(options.output_directory)
        os.makedirs(output_dir, exist_ok=True)

        try:
            for blend_mat in bpy.context.blend_data.materials:
                mat = Material.FromBlenderMaterial(blend_mat)
                filename = os.path.join(output_dir, mat.name)
                mat.name = utils.GetAssetName(filename)

                with open(filename, "w", newline='\n') as file:
                    mat.WriteToFile(file)

        except Exception as err:
            print(err)

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class VIEW3D_PT_VkEngineMaterialExport(bpy.types.Panel):
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"

    bl_category = "Vk-Engine Tools"
    bl_label = "Export Material(s)"

    def draw(self, context : bpy.types.Context):
        layout = self.layout
        options = context.scene.vk_engine_material_export_options

        layout.row().prop(options, "output_directory")

        valid = options.output_directory != ""

        row = layout.row()
        row.enabled = valid
        row.operator(EXPORTER_OT_VkEngineMaterial.bl_idname, text="Export Materials")

classes = (
    VIEW3D_PT_VkEngineMaterialExport,
    EXPORTER_OT_VkEngineMaterial,
    MaterialExportOptions,
)

def register():
    for cl in classes:
        bpy.utils.register_class(cl)

    bpy.types.Scene.vk_engine_material_export_options = PointerProperty(type=MaterialExportOptions)

def unregister():
    for cl in classes:
        bpy.utils.unregister_class(cl)
