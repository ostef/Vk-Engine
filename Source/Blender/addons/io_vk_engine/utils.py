import bpy
import mathutils

from typing import (
    Tuple
)

from bpy_extras.io_utils import (
    orientation_helper,
    axis_conversion
)

from bpy.props import (
    IntProperty,
    BoolProperty,
    EnumProperty,
    StringProperty
)

Vec2f = Tuple[float, float]
Vec3f = Tuple[float, float, float]
Vec4f = Tuple[float, float, float, float]
Vec4i = Tuple[int, int, int, int]
Quatf = Tuple[float, float, float, float]

class CoordinateSystem:
    def __init__(self, right : str, up : str, forward : str):
        self.right = right
        self.up = up
        self.forward = forward

        if not self.IsValid():
            raise Exception(f"Invalid coordinate system {right}{up}{forward}")

    def FromString(s : str):
        if len(s) != 6:
            raise Exception(f"Invalid coordinate system {s}")

        return CoordinateSystem(s[0:2], s[2:4], s[4:6])

    def IsValid(self) -> bool:
        if len(self.right) != 2 or len(self.up) != 2 or len(self.forward) != 2:
            return False

        if self.right[0] != '-' and self.right[0] != '+':
            return False

        if self.up[0] != '-' and self.up[0] != '+':
            return False

        if self.forward[0] != '-' and self.forward[0] != '+':
            return False

        if self.right[1] == self.up[1] or self.right[1] == self.forward[1] or self.up[1] == self.forward[1]:
            return False

        if self.right[1] != 'X' and self.right[1] != 'Y' and self.right[1] != 'Z':
            return False

        if self.up[1] != 'X' and self.up[1] != 'Y' and self.up[1] != 'Z':
            return False

        if self.forward[1] != 'X' and self.forward[1] != 'Y' and self.forward[1] != 'Z':
            return False

        return True

    def IsLeftHanded(self) -> bool:
        signs = mathutils.Vector((1, 1, 1))

        if self.right[0] == '-':
            signs.x = -1
        if self.up[0] == '-':
            signs.y = -1
        if self.forward[0] == '-':
            signs.z = -1

        determinant = signs.x * signs.y * signs.z

        return determinant > 0

    def ConversionMatrix(self) -> mathutils.Matrix:
        return self.RotationConversionMatrix() @ self.ScaleConversionMatrix()

    def RotationConversionMatrix(self) -> mathutils.Matrix:
        if self.forward[0] == '+':
            to_forward = self.forward[1]
        else:
            to_forward = self.forward

        if self.up[0] == '+':
            to_up = self.up[1]
        else:
            to_up = self.up

        return axis_conversion(to_forward = to_forward, to_up = to_up)

    # We need to apply a negative scaling factor on the right axis if the handedness
    # of the coordinate system does not match Blender's (which is right handed)
    def ScaleConversionMatrix(self) -> mathutils.Matrix:
        if self.IsLeftHanded():
            if self.right[1] == 'X':
                scale_vector = (1, 0, 0)
            elif self.right[1] == 'Y':
                scale_vector = (0, 1, 0)
            else:
                scale_vector = (0, 0, 1)

            return mathutils.Matrix.Scale(-1, 3, scale_vector)

        return mathutils.Matrix.Identity(3)

def GetAssetName(filename: str) -> str:
    import os
    import pathlib

    # Asset name is the filename relative to the Data/ directory
    filename = os.path.normpath(filename)

    result = ""
    found_data_dir = False
    for p in filename.split(os.sep):
        if found_data_dir:
            result = os.path.join(result, p)

        if p == "Data":
            found_data_dir = True

    result = str(pathlib.Path(result).as_posix())

    return result
