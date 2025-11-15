bl_info = {
    "name"     : "Vk-Engine Import/Export Tools",
    "author"   : "ostef",
    "version"  : (1, 0, 0),
    "blender"  : (3, 0, 0),
    "location" : "3D View > Vk-Engine",
    "category" : "Import-Export",
}

from . import utils
from . import mesh
from . import texture
from . import material
from . import entities
from . import animation

if "bpy" in locals():
    from importlib import reload

    reload(utils)
    reload(mesh)
    reload(texture)
    reload(material)
    reload(entities)
    reload(animation)

    del reload

import bpy

def register():
    mesh.register()
    texture.register()
    material.register()
    entities.register()
    animation.register()

def unregister():
    mesh.unregister()
    texture.unregister()
    material.unregister()
    entities.unregister()
    animation.unregister()

if __name__ == "__main__":
    register()
