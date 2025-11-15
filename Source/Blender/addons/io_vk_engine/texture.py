import bpy

from bpy.props import (
    IntProperty,
    BoolProperty,
    EnumProperty,
    StringProperty,
    PointerProperty,
)

class TextureExportOptions(bpy.types.PropertyGroup):
    output_directory : StringProperty(
        name = "Output Directory",
        description = "Specify the output directory.",
        subtype = "DIR_PATH",
        options={"PATH_SUPPORTS_BLEND_RELATIVE"},
        default = "//Textures"
    )

class EXPORTER_OT_VkEngineTexture(bpy.types.Operator):
    bl_idname = "export.vk_engine_texture"
    bl_label = "Export images"
    bl_description = "Export images"
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context : bpy.types.Context):
        context.window.cursor_set('WAIT')

        options = context.scene.vk_engine_texture_export_options

        import os

        output_dir = bpy.path.abspath(options.output_directory)
        os.makedirs(output_dir, exist_ok = True)

        for img in bpy.data.images:
            if len(img.packed_files) > 0:
                img.filepath = os.path.join(output_dir, img.name)
                img.filepath_raw = img.filepath
                for f in img.packed_files:
                    f.filepath = os.path.join(output_dir, img.name)

                print(f"Unpacking image to {img.filepath}")
                img.unpack(method='WRITE_ORIGINAL')
                print(f"Unpacked image to {img.filepath}")

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class VIEW3D_PT_VkEngineTextureExport(bpy.types.Panel):
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"

    bl_category = "Vk-Engine Tools"
    bl_label = "Export Texture(s)"

    def draw(self, context : bpy.types.Context):
        layout = self.layout
        options = context.scene.vk_engine_texture_export_options

        layout.row().prop(options, "output_directory")

        valid = options.output_directory != ""

        row = layout.row()
        row.enabled = valid
        row.operator(EXPORTER_OT_VkEngineTexture.bl_idname, text="Unpack All Images")

classes = (
    VIEW3D_PT_VkEngineTextureExport,
    EXPORTER_OT_VkEngineTexture,
    TextureExportOptions,
)

def register():
    for cl in classes:
        bpy.utils.register_class(cl)

    bpy.types.Scene.vk_engine_texture_export_options = PointerProperty(type=TextureExportOptions)

def unregister():
    for cl in classes:
        bpy.utils.unregister_class(cl)
