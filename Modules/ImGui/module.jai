#scope_module

#import "Basic";
Math :: #import "Math";
Linalg :: #import "Linalg";

FLOAT32_MIN :: Math.FLOAT32_MIN;
FLOAT32_MAX :: Math.FLOAT32_MAX;

size_t :: u64;

FILE :: void;

#scope_export

#if OS ==
{
case .WINDOWS;
    #load "imgui_windows.jai";

    user32 :: #system_library,link_always "User32"; // Needed unless ImGui is compiled with IMGUI_DISABLE_WIN32_DEFAULT_CLIPBOARD_FUNCS

case .LINUX;
    #load "imgui_linux.jai";

    libm :: #system_library,link_always "libm";
case .MACOS;
    #load "imgui_macos.jai";
case;
    #assert false "Unsupported OS";
}

ImVec2 :: Linalg.Vec2f;
ImVec4 :: Linalg.Vec4f;
ImColor:: Linalg.Vec4f;

ImRect :: struct
{
    Min : ImVec2; // Upper-left
    Max : ImVec2; // Lower-right

    GetWidth :: inline (using this : *ImRect) -> float
    {
        return Max.x - Min.x;
    }

    GetHeight :: inline (using this : *ImRect) -> float
    {
        return Max.y - Min.y;
    }

    GetSize :: inline (using this : *ImRect) -> ImVec2
    {
        return .{
            Max.x - Min.x,
            Max.y - Min.y,
        };
    }
}

// Helper: ImBitArray class (wrapper over ImBitArray functions)
// Store 1-bit per value.
ImBitArray :: struct (BITCOUNT: s32, OFFSET: s32 = 0)
{
    Storage : [(BITCOUNT + 31) >> 5]ImU32;
}

ImBitArrayForNamedKeys :: ImBitArray(cast(s32) Key.NamedKey_COUNT, -cast(s32) Key.NamedKey_BEGIN);

ImVector :: struct (T : Type)
{
    Size     : s32;
    Capacity : s32;
    Data     : *T;

    Free :: inline (using vec : *ImVector)
    {
        MemFree(Data);
        Data = null;
        Size = 0;
        Capacity = 0;
    }

    Reserve :: inline (using vec : *ImVector, new_capacity : s32)
    {
        if new_capacity < Capacity
            return;

        new_data := MemAlloc(xx (new_capacity * size_of(T)));
        assert(new_data != null);

        if Data
        {
            memcpy(new_data, Data, Size * size_of(T));
            MemFree(Data);
        }

        Data = new_data;
        Capacity = new_capacity;
    }

    Push :: inline (using vec : *ImVector, val : T)
    {
        if Size >= Capacity
            Reserve(vec, Capacity * 2 + 8);

        Data[Size] = val;
        Size += 1;
    }

    Pop :: inline (using vec : *ImVector)
    {
        assert(Size > 0);

        Size -= 1;
    }
}

operator *[] :: inline (vec : *ImVector, index : s64) -> *vec.T
{
    assert(index >= 0 && index < vec.Size);

    return *vec.Data[index];
}

ImDrawCallback :: #type (parent_list : *ImDrawList, cmd : *ImDrawCmd) #c_call;
ImDrawCallback_ResetRenderState :: -1;

// Inlined functions are not generated so we need to write them ourselves

GetCurrentWindowRead :: inline () -> *Window #no_context
{
    return GImGui.CurrentWindow;
}

GetCurrentWindow :: inline () -> *Window #no_context
{
    GImGui.CurrentWindow.WriteAccessed = true;

    return GImGui.CurrentWindow;
}
