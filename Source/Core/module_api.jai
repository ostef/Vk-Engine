// This file was auto-generated. Do not modify it

CoreModule :: struct {
    #as base : Module;
    AddBarrier_1 : (cmd_buffer : *GfxCommandBuffer);
    AddBarrier_2 : (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, dst_sync_points : GfxBarrierSyncPointFlags);
    AddMemoryBarrier : (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags);
    AddTextureBarrier_1 : (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture);
    AddTextureBarrier_2 : (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture);
    AddTextureBarriers : (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, textures : []*GfxTexture);
    AllocGfxBindingSet : (pool : *GfxBindingPool, layout : *GfxBindingSetLayout) -> GfxBindingSet, GfxBindingPoolAllocResult;
    BeginGfxComputePass : (cmd_buffer : *GfxCommandBuffer, name : string) -> GfxComputePass;
    BeginGfxCopyPass : (cmd_buffer : *GfxCommandBuffer, name : string) -> GfxCopyPass;
    BeginGfxDebugMarker_1 : (name : string);
    BeginGfxDebugMarker_2 : (cmd_buffer : *GfxCommandBuffer, name : string);
    BeginGfxFrame : ();
    BeginGfxRenderPass : (cmd_buffer : *GfxCommandBuffer, name : string, desc : GfxRenderPassDesc) -> GfxRenderPass;
    BindComputeBindingSet_1 : (pass : *GfxComputePass, index : u32, set : *GfxBindingSet);
    BindComputeBindingSet_2 : (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet);
    BindComputePipeline : (pass : *GfxComputePass, pipeline : *GfxComputePipeline);
    BindGraphicsBindingSet_1 : (pass : *GfxRenderPass, index : u32, set : *GfxBindingSet);
    BindGraphicsBindingSet_2 : (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet);
    BindGraphicsPipeline : (pass : *GfxRenderPass, pipeline : *GfxGraphicsPipeline);
    BindIndexBuffer : (pass : *GfxRenderPass, type : GfxIndexType, buffer : *GfxBuffer, offset : u64 = 0);
    BindVertexBuffer : (pass : *GfxRenderPass, binding : u32, buffer : *GfxBuffer, offset : u64 = 0);
    CopyBufferToBuffer : (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_buffer : *GfxBuffer, src_offset : u64, dst_offset : u64, size : u64);
    CopyBufferToTexture : (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_texture : *GfxTexture);
    CopyTextureToBuffer : (pass : *GfxCopyPass, src_texture : *GfxTexture, dst_buffer : *GfxBuffer);
    CreateGfxBindingPool : (name : string, desc : GfxBindingPoolDesc) -> GfxBindingPool;
    CreateGfxBindingSetLayout : (name : string, desc : GfxBindingSetLayoutDesc) -> GfxBindingSetLayout;
    CreateGfxBuffer : (name : string, desc : GfxBufferDesc) -> GfxBuffer;
    CreateGfxCommandBuffer : (name : string) -> GfxCommandBuffer;
    CreateGfxComputePipeline : (name : string, desc : GfxComputePipelineDesc) -> GfxComputePipeline;
    CreateGfxGraphicsPipeline : (name : string, desc : GfxGraphicsPipelineDesc) -> GfxGraphicsPipeline;
    CreateGfxPipelineLayout : (name : string, desc : GfxPipelineLayoutDesc) -> GfxPipelineLayout;
    CreateGfxSampler : (name : string, desc : GfxSamplerDesc) -> GfxSampler;
    CreateGfxTexture : (name : string, desc : GfxTextureDesc) -> GfxTexture;
    CreateGfxTextureView : (name : string, desc : GfxTextureViewDesc, texture : *GfxTexture) -> GfxTexture;
    DeferNextAssetLoadsForAllCaches : ();
    DestroyGPUFrameProfiler : (profiler : *GPUFrameProfiler);
    DestroyGfxBindingPool : (pool : *GfxBindingPool);
    DestroyGfxBindingSetLayout : (layout : *GfxBindingSetLayout);
    DestroyGfxBuffer : (buffer : *GfxBuffer);
    DestroyGfxCommandPool : (pool : *GfxCommandPool);
    DestroyGfxComputePipeline : (pipeline : *GfxComputePipeline);
    DestroyGfxGraphicsPipeline : (pipeline : *GfxGraphicsPipeline);
    DestroyGfxPipelineLayout : (layout : *GfxPipelineLayout);
    DestroyGfxSampler : (sampler : *GfxSampler);
    DestroyGfxShader : (shader : *GfxShader);
    DestroyGfxTexture : (texture : *GfxTexture);
    DestroyGfxTextureView : (texture : *GfxTexture);
    Dispatch : (pass : *GfxComputePass, num_groups_x : u32, num_groups_y : u32, num_groups_z : u32);
    Draw : (pass : *GfxRenderPass, vertex_count : u32, instance_count : u32, base_vertex : u32 = 0, base_instance : u32 = 0);
    DrawIndexed : (pass : *GfxRenderPass, index_count : u32, instance_count : u32, base_index : u32 = 0, base_vertex : u32 = 0, base_instance : u32 = 0);
    EndGfxComputePass : (pass : *GfxComputePass);
    EndGfxCopyPass : (pass : *GfxCopyPass);
    EndGfxDebugMarker_1 : ();
    EndGfxDebugMarker_2 : (cmd_buffer : *GfxCommandBuffer);
    EndGfxRenderPass : (pass : *GfxRenderPass);
    GenerateMipmaps : (pass : *GfxCopyPass, texture : *GfxTexture, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout);
    GetAssets : () -> *Assets;
    GetBoxSplittingPlanes : (center : Vector(N=3, T=float32)) -> x : Plane, y : Plane, z : Plane;
    GetCPUFrameProfiler : () -> *CPUFrameProfiler;
    GetCVarBool : (name : string, default : bool = false) -> bool, exists : bool;
    GetCVarFloat : (name : string, default : float = 0) -> float, exists : bool;
    GetCVarInt : (name : string, default : s32 = 0) -> s32, exists : bool;
    GetCVarString : (name : string, default : string = "") -> string, exists : bool;
    GetCVarUInt : (name : string, default : u32 = 0) -> u32, exists : bool;
    GetFrameInFlight : () -> s64;
    GetGPUFrameProfiler : () -> *GPUFrameProfiler;
    GetGfxContext : () -> *GfxContext;
    GetGfxLimits : () -> GfxLimits;
    GetKeyAxisValue : (negative : KeyCode, positive : KeyCode) -> float;
    GetModState : () -> KeyMods;
    GetModule : (id : ModuleID) -> *Module;
    GetMousePixelPosition : (window : *void) -> x : s32, y : s32;
    GetMousePixelPositionVector : (window : *void) -> Vector(N=2, T=float32);
    GetMousePointPosition : (window : *void) -> x : s32, y : s32;
    GetMousePointPositionVector : (window : *void) -> Vector(N=2, T=float32);
    GetMouseWheel : () -> Vector(N=2, T=float32);
    GetPointPenetrationInBox : (point_inside_box : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32);
    GetRawMouseDelta : () -> Vector(N=2, T=float32);
    GetVkAllocationCallbacks : () -> *VkAllocationCallbacks;
    GetWindow : () -> *void;
    GetWindowPixelSize : (window : *void) -> width : s32, height : s32;
    GetWindowPointSize : (window : *void) -> width : s32, height : s32;
    GetWindowScaleFactor : (window : *void) -> float;
    InitGPUFrameProfiler : (profiler : *GPUFrameProfiler, max_events : s64);
    IsKeyDown : (key : KeyCode) -> bool;
    IsKeyPressed : (key : KeyCode) -> bool;
    IsKeyReleased : (key : KeyCode) -> bool;
    IsMouseButtonDown : (button : MouseButton) -> bool;
    IsMouseButtonPressed : (button : MouseButton) -> bool;
    IsMouseButtonReleased : (button : MouseButton) -> bool;
    LoadGfxShader : (name : string, extra_compiler_args : []string = .[], dependencies : *[..]string = null) -> GfxShader;
    LoadPendingAssets : ();
    PointIsInsideBox : (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool;
    PointIsOnTriangle : (point : Vector(N=3, T=float32), triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), epsilon : float = 0.00001) -> bool;
    ProfilerBeginEvent : (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, name : string) -> *GPUProfilingEvent;
    ProfilerBeginFrame : (profiler : *GPUFrameProfiler);
    ProjectPointOnBox_1 : (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32);
    ProjectPointOnBox_2 : (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32)) -> Vector(N=3, T=float32);
    ProjectPointOnCapsule : (point : Vector(N=3, T=float32), capsule_base : Vector(N=3, T=float32), capsule_tip : Vector(N=3, T=float32), capsule_radius : float) -> Vector(N=3, T=float32);
    ProjectPointOnLine : (point : Vector(N=3, T=float32), line_origin : Vector(N=3, T=float32), line_dir : Vector(N=3, T=float32)) -> Vector(N=3, T=float32), t : float;
    ProjectPointOnPlane : (point : Vector(N=3, T=float32), plane_origin : Vector(N=3, T=float32), plane_normal : Vector(N=3, T=float32)) -> Vector(N=3, T=float32);
    ProjectPointOnRay : (point : Vector(N=3, T=float32), ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float) -> Vector(N=3, T=float32), t : float;
    ProjectPointOnSphere : (point : Vector(N=3, T=float32), sphere_center : Vector(N=3, T=float32), sphere_radius : float) -> Vector(N=3, T=float32);
    QueueDestroyGfxBuffer : (buffer : *GfxBuffer);
    QueueDestroyGfxSampler : (sampler : *GfxSampler);
    QueueDestroyGfxTexture : (texture : *GfxTexture);
    QueueDestroyGfxTextureView : (texture : *GfxTexture);
    Quit : ();
    RayIntersectsBox_1 : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RayIntersectsBox_2 : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RayIntersectsBox_3 : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RayIntersectsCapsule : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, capsule_base : Vector(N=3, T=float32), capsule_tip : Vector(N=3, T=float32), capsule_radius : float) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RayIntersectsMesh_1 : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, mesh : *StaticMesh, transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32), triangle_index : s64;
    RayIntersectsMesh_2 : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, mesh : *StaticMesh, transform : Matrix(M=4, N=4, T=float32), inv_transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32), triangle_index : s64;
    RayIntersectsOctreeMesh : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), mesh : *CollisionMesh, octree_index : s64, octree_center : Vector(N=3, T=float32), octree_half_size : float) -> intersects : bool, point : Vector(N=3, T=float32), normal : Vector(N=3, T=float32), triangle_index : s64, octree_index : s64;
    RayIntersectsPlane : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, plane_origin : Vector(N=3, T=float32), plane_normal : Vector(N=3, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RayIntersectsSphere : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, sphere_center : Vector(N=3, T=float32), sphere_radius : float) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RayIntersectsTriangle : (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32)) -> intersets : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32);
    RegisterDataDirectoryChangeCallback : (proc : (*File_Watcher(User_Data=void), *File_Change, *void), data : *void) -> s64;
    ResetGfxBindingPool : (pool : *GfxBindingPool);
    ResetGfxCommandPool : (pool : *GfxCommandPool);
    SetBlendConstant : (pass : *GfxRenderPass, color : Vector(N=4, T=float32));
    SetCVarBool : (name : string, value : bool);
    SetCVarFloat : (name : string, value : float);
    SetCVarInt : (name : string, value : s32);
    SetCVarString : (name : string, value : string);
    SetCVarUInt : (name : string, value : u32);
    SetScissor : (pass : *GfxRenderPass, rect : Rect(T=s32));
    SetStencilReference : (pass : *GfxRenderPass, front_value : u32, back_value : u32);
    SetViewport : (pass : *GfxRenderPass, viewport : GfxViewport);
    SubmitGfxCommandBuffer : (cmd_buffer : GfxCommandBuffer);
    SubmitGfxFrame : ();
    TextureUploadPass : (cmd_buffer : *GfxCommandBuffer);
    TriangleIntersectsBox : (triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), triangle_normal : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool;
    UnregisterDataDirectoryChangeCallback : (index : s64);
    WaitForGPUIdle : ();
    WasKeyDown : (key : KeyCode) -> bool;
    WasMouseButtonDown : (button : MouseButton) -> bool;
}

#if Import_Mode == .Foreign {
g_Core : *CoreModule;

AddBarrier :: inline (cmd_buffer : *GfxCommandBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.AddBarrier_1(cmd_buffer);
}

AddBarrier :: inline (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, dst_sync_points : GfxBarrierSyncPointFlags) {
    Assert(g_Core != null, "Core module is null");
    g_Core.AddBarrier_2(cmd_buffer, src_sync_points, dst_sync_points);
}

AddMemoryBarrier :: inline (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags) {
    Assert(g_Core != null, "Core module is null");
    g_Core.AddMemoryBarrier(cmd_buffer, src_sync_points, src_accesses, dst_sync_points, dst_accesses);
}

AddTextureBarrier :: inline (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.AddTextureBarrier_1(cmd_buffer, old_layout, new_layout, texture);
}

AddTextureBarrier :: inline (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.AddTextureBarrier_2(cmd_buffer, src_sync_points, src_accesses, dst_sync_points, dst_accesses, old_layout, new_layout, texture);
}

AddTextureBarriers :: inline (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, textures : []*GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.AddTextureBarriers(cmd_buffer, old_layout, new_layout, textures);
}

AllocGfxBindingSet :: inline (pool : *GfxBindingPool, layout : *GfxBindingSetLayout) -> GfxBindingSet, GfxBindingPoolAllocResult {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.AllocGfxBindingSet(pool, layout);
    return _ret0, _ret1;
}

BeginGfxComputePass :: inline (cmd_buffer : *GfxCommandBuffer, name : string) -> GfxComputePass {
    Assert(g_Core != null, "Core module is null");
    return g_Core.BeginGfxComputePass(cmd_buffer, name);
}

BeginGfxCopyPass :: inline (cmd_buffer : *GfxCommandBuffer, name : string) -> GfxCopyPass {
    Assert(g_Core != null, "Core module is null");
    return g_Core.BeginGfxCopyPass(cmd_buffer, name);
}

BeginGfxDebugMarker :: inline (name : string) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BeginGfxDebugMarker_1(name);
}

BeginGfxDebugMarker :: inline (cmd_buffer : *GfxCommandBuffer, name : string) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BeginGfxDebugMarker_2(cmd_buffer, name);
}

BeginGfxFrame :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.BeginGfxFrame();
}

BeginGfxRenderPass :: inline (cmd_buffer : *GfxCommandBuffer, name : string, desc : GfxRenderPassDesc) -> GfxRenderPass {
    Assert(g_Core != null, "Core module is null");
    return g_Core.BeginGfxRenderPass(cmd_buffer, name, desc);
}

BindComputeBindingSet :: inline (pass : *GfxComputePass, index : u32, set : *GfxBindingSet) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindComputeBindingSet_1(pass, index, set);
}

BindComputeBindingSet :: inline (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindComputeBindingSet_2(cmd_buffer, layout, index, set);
}

BindComputePipeline :: inline (pass : *GfxComputePass, pipeline : *GfxComputePipeline) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindComputePipeline(pass, pipeline);
}

BindGraphicsBindingSet :: inline (pass : *GfxRenderPass, index : u32, set : *GfxBindingSet) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindGraphicsBindingSet_1(pass, index, set);
}

BindGraphicsBindingSet :: inline (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindGraphicsBindingSet_2(cmd_buffer, layout, index, set);
}

BindGraphicsPipeline :: inline (pass : *GfxRenderPass, pipeline : *GfxGraphicsPipeline) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindGraphicsPipeline(pass, pipeline);
}

BindIndexBuffer :: inline (pass : *GfxRenderPass, type : GfxIndexType, buffer : *GfxBuffer, offset : u64 = 0) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindIndexBuffer(pass, type, buffer, offset);
}

BindVertexBuffer :: inline (pass : *GfxRenderPass, binding : u32, buffer : *GfxBuffer, offset : u64 = 0) {
    Assert(g_Core != null, "Core module is null");
    g_Core.BindVertexBuffer(pass, binding, buffer, offset);
}

CopyBufferToBuffer :: inline (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_buffer : *GfxBuffer, src_offset : u64, dst_offset : u64, size : u64) {
    Assert(g_Core != null, "Core module is null");
    g_Core.CopyBufferToBuffer(pass, src_buffer, dst_buffer, src_offset, dst_offset, size);
}

CopyBufferToTexture :: inline (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.CopyBufferToTexture(pass, src_buffer, dst_texture);
}

CopyTextureToBuffer :: inline (pass : *GfxCopyPass, src_texture : *GfxTexture, dst_buffer : *GfxBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.CopyTextureToBuffer(pass, src_texture, dst_buffer);
}

CreateGfxBindingPool :: inline (name : string, desc : GfxBindingPoolDesc) -> GfxBindingPool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxBindingPool(name, desc);
}

CreateGfxBindingSetLayout :: inline (name : string, desc : GfxBindingSetLayoutDesc) -> GfxBindingSetLayout {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxBindingSetLayout(name, desc);
}

CreateGfxBuffer :: inline (name : string, desc : GfxBufferDesc) -> GfxBuffer {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxBuffer(name, desc);
}

CreateGfxCommandBuffer :: inline (name : string) -> GfxCommandBuffer {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxCommandBuffer(name);
}

CreateGfxComputePipeline :: inline (name : string, desc : GfxComputePipelineDesc) -> GfxComputePipeline {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxComputePipeline(name, desc);
}

CreateGfxGraphicsPipeline :: inline (name : string, desc : GfxGraphicsPipelineDesc) -> GfxGraphicsPipeline {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxGraphicsPipeline(name, desc);
}

CreateGfxPipelineLayout :: inline (name : string, desc : GfxPipelineLayoutDesc) -> GfxPipelineLayout {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxPipelineLayout(name, desc);
}

CreateGfxSampler :: inline (name : string, desc : GfxSamplerDesc) -> GfxSampler {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxSampler(name, desc);
}

CreateGfxTexture :: inline (name : string, desc : GfxTextureDesc) -> GfxTexture {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxTexture(name, desc);
}

CreateGfxTextureView :: inline (name : string, desc : GfxTextureViewDesc, texture : *GfxTexture) -> GfxTexture {
    Assert(g_Core != null, "Core module is null");
    return g_Core.CreateGfxTextureView(name, desc, texture);
}

DeferNextAssetLoadsForAllCaches :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.DeferNextAssetLoadsForAllCaches();
}

DestroyGPUFrameProfiler :: inline (profiler : *GPUFrameProfiler) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGPUFrameProfiler(profiler);
}

DestroyGfxBindingPool :: inline (pool : *GfxBindingPool) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxBindingPool(pool);
}

DestroyGfxBindingSetLayout :: inline (layout : *GfxBindingSetLayout) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxBindingSetLayout(layout);
}

DestroyGfxBuffer :: inline (buffer : *GfxBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxBuffer(buffer);
}

DestroyGfxCommandPool :: inline (pool : *GfxCommandPool) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxCommandPool(pool);
}

DestroyGfxComputePipeline :: inline (pipeline : *GfxComputePipeline) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxComputePipeline(pipeline);
}

DestroyGfxGraphicsPipeline :: inline (pipeline : *GfxGraphicsPipeline) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxGraphicsPipeline(pipeline);
}

DestroyGfxPipelineLayout :: inline (layout : *GfxPipelineLayout) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxPipelineLayout(layout);
}

DestroyGfxSampler :: inline (sampler : *GfxSampler) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxSampler(sampler);
}

DestroyGfxShader :: inline (shader : *GfxShader) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxShader(shader);
}

DestroyGfxTexture :: inline (texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxTexture(texture);
}

DestroyGfxTextureView :: inline (texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DestroyGfxTextureView(texture);
}

Dispatch :: inline (pass : *GfxComputePass, num_groups_x : u32, num_groups_y : u32, num_groups_z : u32) {
    Assert(g_Core != null, "Core module is null");
    g_Core.Dispatch(pass, num_groups_x, num_groups_y, num_groups_z);
}

Draw :: inline (pass : *GfxRenderPass, vertex_count : u32, instance_count : u32, base_vertex : u32 = 0, base_instance : u32 = 0) {
    Assert(g_Core != null, "Core module is null");
    g_Core.Draw(pass, vertex_count, instance_count, base_vertex, base_instance);
}

DrawIndexed :: inline (pass : *GfxRenderPass, index_count : u32, instance_count : u32, base_index : u32 = 0, base_vertex : u32 = 0, base_instance : u32 = 0) {
    Assert(g_Core != null, "Core module is null");
    g_Core.DrawIndexed(pass, index_count, instance_count, base_index, base_vertex, base_instance);
}

EndGfxComputePass :: inline (pass : *GfxComputePass) {
    Assert(g_Core != null, "Core module is null");
    g_Core.EndGfxComputePass(pass);
}

EndGfxCopyPass :: inline (pass : *GfxCopyPass) {
    Assert(g_Core != null, "Core module is null");
    g_Core.EndGfxCopyPass(pass);
}

EndGfxDebugMarker :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.EndGfxDebugMarker_1();
}

EndGfxDebugMarker :: inline (cmd_buffer : *GfxCommandBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.EndGfxDebugMarker_2(cmd_buffer);
}

EndGfxRenderPass :: inline (pass : *GfxRenderPass) {
    Assert(g_Core != null, "Core module is null");
    g_Core.EndGfxRenderPass(pass);
}

GenerateMipmaps :: inline (pass : *GfxCopyPass, texture : *GfxTexture, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout) {
    Assert(g_Core != null, "Core module is null");
    g_Core.GenerateMipmaps(pass, texture, old_layout, new_layout);
}

GetAssets :: inline () -> *Assets {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetAssets();
}

GetBoxSplittingPlanes :: inline (center : Vector(N=3, T=float32)) -> x : Plane, y : Plane, z : Plane {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2 := g_Core.GetBoxSplittingPlanes(center);
    return _ret0, _ret1, _ret2;
}

GetCPUFrameProfiler :: inline () -> *CPUFrameProfiler {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetCPUFrameProfiler();
}

GetCVarBool :: inline (name : string, default : bool = false) -> bool, exists : bool {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetCVarBool(name, default);
    return _ret0, _ret1;
}

GetCVarFloat :: inline (name : string, default : float = 0) -> float, exists : bool {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetCVarFloat(name, default);
    return _ret0, _ret1;
}

GetCVarInt :: inline (name : string, default : s32 = 0) -> s32, exists : bool {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetCVarInt(name, default);
    return _ret0, _ret1;
}

GetCVarString :: inline (name : string, default : string = "") -> string, exists : bool {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetCVarString(name, default);
    return _ret0, _ret1;
}

GetCVarUInt :: inline (name : string, default : u32 = 0) -> u32, exists : bool {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetCVarUInt(name, default);
    return _ret0, _ret1;
}

GetFrameInFlight :: inline () -> s64 {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetFrameInFlight();
}

GetGPUFrameProfiler :: inline () -> *GPUFrameProfiler {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetGPUFrameProfiler();
}

GetGfxContext :: inline () -> *GfxContext {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetGfxContext();
}

GetGfxLimits :: inline () -> GfxLimits {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetGfxLimits();
}

GetKeyAxisValue :: inline (negative : KeyCode, positive : KeyCode) -> float {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetKeyAxisValue(negative, positive);
}

GetModState :: inline () -> KeyMods {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetModState();
}

GetModule :: inline (id : ModuleID) -> *Module {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetModule(id);
}

GetMousePixelPosition :: inline (window : *void) -> x : s32, y : s32 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetMousePixelPosition(window);
    return _ret0, _ret1;
}

GetMousePixelPositionVector :: inline (window : *void) -> Vector(N=2, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetMousePixelPositionVector(window);
}

GetMousePointPosition :: inline (window : *void) -> x : s32, y : s32 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetMousePointPosition(window);
    return _ret0, _ret1;
}

GetMousePointPositionVector :: inline (window : *void) -> Vector(N=2, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetMousePointPositionVector(window);
}

GetMouseWheel :: inline () -> Vector(N=2, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetMouseWheel();
}

GetPointPenetrationInBox :: inline (point_inside_box : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetPointPenetrationInBox(point_inside_box, box_center, box_half_extents);
}

GetRawMouseDelta :: inline () -> Vector(N=2, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetRawMouseDelta();
}

GetVkAllocationCallbacks :: inline () -> *VkAllocationCallbacks {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetVkAllocationCallbacks();
}

GetWindow :: inline () -> *void {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetWindow();
}

GetWindowPixelSize :: inline (window : *void) -> width : s32, height : s32 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetWindowPixelSize(window);
    return _ret0, _ret1;
}

GetWindowPointSize :: inline (window : *void) -> width : s32, height : s32 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.GetWindowPointSize(window);
    return _ret0, _ret1;
}

GetWindowScaleFactor :: inline (window : *void) -> float {
    Assert(g_Core != null, "Core module is null");
    return g_Core.GetWindowScaleFactor(window);
}

InitGPUFrameProfiler :: inline (profiler : *GPUFrameProfiler, max_events : s64) {
    Assert(g_Core != null, "Core module is null");
    g_Core.InitGPUFrameProfiler(profiler, max_events);
}

IsKeyDown :: inline (key : KeyCode) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.IsKeyDown(key);
}

IsKeyPressed :: inline (key : KeyCode) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.IsKeyPressed(key);
}

IsKeyReleased :: inline (key : KeyCode) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.IsKeyReleased(key);
}

IsMouseButtonDown :: inline (button : MouseButton) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.IsMouseButtonDown(button);
}

IsMouseButtonPressed :: inline (button : MouseButton) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.IsMouseButtonPressed(button);
}

IsMouseButtonReleased :: inline (button : MouseButton) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.IsMouseButtonReleased(button);
}

LoadGfxShader :: inline (name : string, extra_compiler_args : []string = .[], dependencies : *[..]string = null) -> GfxShader {
    Assert(g_Core != null, "Core module is null");
    return g_Core.LoadGfxShader(name, extra_compiler_args, dependencies);
}

LoadPendingAssets :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.LoadPendingAssets();
}

PointIsInsideBox :: inline (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.PointIsInsideBox(point, box_center, box_half_extents);
}

PointIsOnTriangle :: inline (point : Vector(N=3, T=float32), triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), epsilon : float = 0.00001) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.PointIsOnTriangle(point, triangle_A, triangle_B, triangle_C, epsilon);
}

ProfilerBeginEvent :: inline (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, name : string) -> *GPUProfilingEvent {
    Assert(g_Core != null, "Core module is null");
    return g_Core.ProfilerBeginEvent(cmd_buffer, profiler, name);
}

ProfilerBeginFrame :: inline (profiler : *GPUFrameProfiler) {
    Assert(g_Core != null, "Core module is null");
    g_Core.ProfilerBeginFrame(profiler);
}

ProjectPointOnBox :: inline (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.ProjectPointOnBox_1(point, box_center, box_half_extents);
}

ProjectPointOnBox :: inline (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32)) -> Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.ProjectPointOnBox_2(point, box_center, box_half_extents, orientation);
}

ProjectPointOnCapsule :: inline (point : Vector(N=3, T=float32), capsule_base : Vector(N=3, T=float32), capsule_tip : Vector(N=3, T=float32), capsule_radius : float) -> Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.ProjectPointOnCapsule(point, capsule_base, capsule_tip, capsule_radius);
}

ProjectPointOnLine :: inline (point : Vector(N=3, T=float32), line_origin : Vector(N=3, T=float32), line_dir : Vector(N=3, T=float32)) -> Vector(N=3, T=float32), t : float {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.ProjectPointOnLine(point, line_origin, line_dir);
    return _ret0, _ret1;
}

ProjectPointOnPlane :: inline (point : Vector(N=3, T=float32), plane_origin : Vector(N=3, T=float32), plane_normal : Vector(N=3, T=float32)) -> Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.ProjectPointOnPlane(point, plane_origin, plane_normal);
}

ProjectPointOnRay :: inline (point : Vector(N=3, T=float32), ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float) -> Vector(N=3, T=float32), t : float {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1 := g_Core.ProjectPointOnRay(point, ray_origin, ray_dir, ray_length);
    return _ret0, _ret1;
}

ProjectPointOnSphere :: inline (point : Vector(N=3, T=float32), sphere_center : Vector(N=3, T=float32), sphere_radius : float) -> Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    return g_Core.ProjectPointOnSphere(point, sphere_center, sphere_radius);
}

QueueDestroyGfxBuffer :: inline (buffer : *GfxBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.QueueDestroyGfxBuffer(buffer);
}

QueueDestroyGfxSampler :: inline (sampler : *GfxSampler) {
    Assert(g_Core != null, "Core module is null");
    g_Core.QueueDestroyGfxSampler(sampler);
}

QueueDestroyGfxTexture :: inline (texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.QueueDestroyGfxTexture(texture);
}

QueueDestroyGfxTextureView :: inline (texture : *GfxTexture) {
    Assert(g_Core != null, "Core module is null");
    g_Core.QueueDestroyGfxTextureView(texture);
}

Quit :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.Quit();
}

RayIntersectsBox :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsBox_1(ray_origin, ray_dir, ray_length, half_extents, transform);
    return _ret0, _ret1, _ret2, _ret3;
}

RayIntersectsBox :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsBox_2(ray_origin, ray_dir, ray_length, box_center, box_half_extents);
    return _ret0, _ret1, _ret2, _ret3;
}

RayIntersectsBox :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsBox_3(ray_origin, ray_dir, ray_length, box_center, box_half_extents, orientation);
    return _ret0, _ret1, _ret2, _ret3;
}

RayIntersectsCapsule :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, capsule_base : Vector(N=3, T=float32), capsule_tip : Vector(N=3, T=float32), capsule_radius : float) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsCapsule(ray_origin, ray_dir, ray_length, capsule_base, capsule_tip, capsule_radius);
    return _ret0, _ret1, _ret2, _ret3;
}

RayIntersectsMesh :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, mesh : *StaticMesh, transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32), triangle_index : s64 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3, _ret4 := g_Core.RayIntersectsMesh_1(ray_origin, ray_dir, ray_length, mesh, transform);
    return _ret0, _ret1, _ret2, _ret3, _ret4;
}

RayIntersectsMesh :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, mesh : *StaticMesh, transform : Matrix(M=4, N=4, T=float32), inv_transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32), triangle_index : s64 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3, _ret4 := g_Core.RayIntersectsMesh_2(ray_origin, ray_dir, ray_length, mesh, transform, inv_transform);
    return _ret0, _ret1, _ret2, _ret3, _ret4;
}

RayIntersectsOctreeMesh :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), mesh : *CollisionMesh, octree_index : s64, octree_center : Vector(N=3, T=float32), octree_half_size : float) -> intersects : bool, point : Vector(N=3, T=float32), normal : Vector(N=3, T=float32), triangle_index : s64, octree_index : s64 {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3, _ret4 := g_Core.RayIntersectsOctreeMesh(ray_origin, ray_dir, mesh, octree_index, octree_center, octree_half_size);
    return _ret0, _ret1, _ret2, _ret3, _ret4;
}

RayIntersectsPlane :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, plane_origin : Vector(N=3, T=float32), plane_normal : Vector(N=3, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsPlane(ray_origin, ray_dir, ray_length, plane_origin, plane_normal);
    return _ret0, _ret1, _ret2, _ret3;
}

RayIntersectsSphere :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, sphere_center : Vector(N=3, T=float32), sphere_radius : float) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsSphere(ray_origin, ray_dir, ray_length, sphere_center, sphere_radius);
    return _ret0, _ret1, _ret2, _ret3;
}

RayIntersectsTriangle :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32)) -> intersets : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    Assert(g_Core != null, "Core module is null");
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsTriangle(ray_origin, ray_dir, ray_length, triangle_A, triangle_B, triangle_C);
    return _ret0, _ret1, _ret2, _ret3;
}

RegisterDataDirectoryChangeCallback :: inline (proc : (*File_Watcher(User_Data=void), *File_Change, *void), data : *void) -> s64 {
    Assert(g_Core != null, "Core module is null");
    return g_Core.RegisterDataDirectoryChangeCallback(proc, data);
}

ResetGfxBindingPool :: inline (pool : *GfxBindingPool) {
    Assert(g_Core != null, "Core module is null");
    g_Core.ResetGfxBindingPool(pool);
}

ResetGfxCommandPool :: inline (pool : *GfxCommandPool) {
    Assert(g_Core != null, "Core module is null");
    g_Core.ResetGfxCommandPool(pool);
}

SetBlendConstant :: inline (pass : *GfxRenderPass, color : Vector(N=4, T=float32)) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetBlendConstant(pass, color);
}

SetCVarBool :: inline (name : string, value : bool) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetCVarBool(name, value);
}

SetCVarFloat :: inline (name : string, value : float) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetCVarFloat(name, value);
}

SetCVarInt :: inline (name : string, value : s32) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetCVarInt(name, value);
}

SetCVarString :: inline (name : string, value : string) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetCVarString(name, value);
}

SetCVarUInt :: inline (name : string, value : u32) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetCVarUInt(name, value);
}

SetScissor :: inline (pass : *GfxRenderPass, rect : Rect(T=s32)) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetScissor(pass, rect);
}

SetStencilReference :: inline (pass : *GfxRenderPass, front_value : u32, back_value : u32) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetStencilReference(pass, front_value, back_value);
}

SetViewport :: inline (pass : *GfxRenderPass, viewport : GfxViewport) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SetViewport(pass, viewport);
}

SubmitGfxCommandBuffer :: inline (cmd_buffer : GfxCommandBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.SubmitGfxCommandBuffer(cmd_buffer);
}

SubmitGfxFrame :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.SubmitGfxFrame();
}

TextureUploadPass :: inline (cmd_buffer : *GfxCommandBuffer) {
    Assert(g_Core != null, "Core module is null");
    g_Core.TextureUploadPass(cmd_buffer);
}

TriangleIntersectsBox :: inline (triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), triangle_normal : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.TriangleIntersectsBox(triangle_A, triangle_B, triangle_C, triangle_normal, box_center, box_half_extents);
}

UnregisterDataDirectoryChangeCallback :: inline (index : s64) {
    Assert(g_Core != null, "Core module is null");
    g_Core.UnregisterDataDirectoryChangeCallback(index);
}

WaitForGPUIdle :: inline () {
    Assert(g_Core != null, "Core module is null");
    g_Core.WaitForGPUIdle();
}

WasKeyDown :: inline (key : KeyCode) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.WasKeyDown(key);
}

WasMouseButtonDown :: inline (button : MouseButton) -> bool {
    Assert(g_Core != null, "Core module is null");
    return g_Core.WasMouseButtonDown(button);
}

}
