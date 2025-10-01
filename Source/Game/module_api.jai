// This file was auto-generated. Do not modify it

GameModule :: struct {
    #as base : Module;
    CopyWorld : (dest : *World, src : *World);
    DestroyKilledEntities : (world : *World);
    DestroyWorld : (world : *World);
    GetDefaultMaterial : () -> *Asset(DataType=Material);
    LoadWorldFromDirectory : (world : *World, directory : string);
    SaveWorldToDirectory : (world : *World, output_directory : string);
    SubmitWorldToRenderer : (world : *World);
}

#if Import_Mode == .Foreign {
g_Game : *GameModule;

CopyWorld :: inline (dest : *World, src : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.CopyWorld(dest, src);
}

DestroyKilledEntities :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DestroyKilledEntities(world);
}

DestroyWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DestroyWorld(world);
}

GetDefaultMaterial :: inline () -> *Asset(DataType=Material) {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetDefaultMaterial();
}

LoadWorldFromDirectory :: inline (world : *World, directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.LoadWorldFromDirectory(world, directory);
}

SaveWorldToDirectory :: inline (world : *World, output_directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SaveWorldToDirectory(world, output_directory);
}

SubmitWorldToRenderer :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SubmitWorldToRenderer(world);
}

}
