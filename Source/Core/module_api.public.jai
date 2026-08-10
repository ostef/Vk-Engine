// This file was auto-generated. Do not modify it

CoreContext :: struct {
    base : Context_Base;
    log_section : *Log_Section;
    panicking : bool;
    print_style : Print_Style;
    profiling : ProfilingThreadContext;
    random_state : Random_State;
    uuid_random_state : Random_State;
}

CoreModule :: struct {
    #as base : Module;
    AddBarrier_1 : (cmd_buffer : *GfxCommandBuffer);
    AddBarrier_2 : (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, dst_sync_points : GfxBarrierSyncPointFlags);
    AddMemoryBarrier : (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags);
    AddPoses : (dest : *ArmaturePose, other : *ArmaturePose, weight : float = 1);
    AddTextureBarrier_1 : (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture);
    AddTextureBarrier_2 : (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture);
    AddTextureBarriers : (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, textures : []*GfxTexture);
    AdvanceToNextLine : (parser : *DeserializeParser);
    AllocGfxBindingSet : (pool : *GfxBindingPool, layout : *GfxBindingSetLayout) -> GfxBindingSet, GfxBindingPoolAllocResult;
    BeginGfxComputePass : (cmd_buffer : *GfxCommandBuffer, name : string, location : Source_Code_Location = #caller_location) -> GfxComputePass;
    BeginGfxCopyPass : (cmd_buffer : *GfxCommandBuffer, name : string, location : Source_Code_Location = #caller_location) -> GfxCopyPass;
    BeginGfxDebugMarker_1 : (name : string);
    BeginGfxDebugMarker_2 : (cmd_buffer : *GfxCommandBuffer, name : string);
    BeginGfxFrame : ();
    BeginGfxRenderPass : (cmd_buffer : *GfxCommandBuffer, name : string, desc : GfxRenderPassDesc, location : Source_Code_Location = #caller_location) -> GfxRenderPass;
    BindComputeBindingSet_1 : (pass : *GfxComputePass, index : u32, set : *GfxBindingSet);
    BindComputeBindingSet_2 : (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet);
    BindComputePipeline : (pass : *GfxComputePass, pipeline : *GfxComputePipeline);
    BindGraphicsBindingSet_1 : (pass : *GfxRenderPass, index : u32, set : *GfxBindingSet);
    BindGraphicsBindingSet_2 : (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet);
    BindGraphicsPipeline : (pass : *GfxRenderPass, pipeline : *GfxGraphicsPipeline);
    BindIndexBuffer : (pass : *GfxRenderPass, type : GfxIndexType, buffer : *GfxBuffer, offset : u64 = 0);
    BindVertexBuffer : (pass : *GfxRenderPass, binding : u32, buffer : *GfxBuffer, offset : u64 = 0);
    BlendPoses : (dest : *ArmaturePose, a : *ArmaturePose, b : *ArmaturePose, t : float);
    CalculatePoseTransforms : (pose : *ArmaturePose);
    CalculateSkinningMatrices : (pose : *ArmaturePose, matrices : *[]Matrix(M=4, N=4, T=float32));
    CancelTextureUpload : (texture : *Texture2D);
    ClearEnvironmentMapsToGenerate : ();
    ClearGPUFrameProfiler : (profiler : *GPUFrameProfiler);
    CopyBufferToBuffer : (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_buffer : *GfxBuffer, src_offset : u64, dst_offset : u64, size : u64);
    CopyBufferToTexture : (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_texture : *GfxTexture);
    CopyPose : (dest : *ArmaturePose, src : *ArmaturePose);
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
    DeserializeAny_1 : (str : string, value : Any) -> DeserializeResult;
    DeserializeAny_2 : (parser : *DeserializeParser, value : Any) -> DeserializeResult;
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
    FreeArmaturePose : (pose : *ArmaturePose);
    GenerateMipmaps : (pass : *GfxCopyPass, texture : *GfxTexture, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout);
    GetAssets : () -> *Assets;
    GetBoxSplittingPlanes : (center : Vector(N=3, T=float32)) -> x : Plane, y : Plane, z : Plane;
    GetCPUFrameProfiler : () -> *CPUFrameProfiler;
    GetDataDirectoryAbsolutePath : () -> string;
    GetDefaultNumWorkerThreads : () -> s32;
    GetDeltaTime : () -> float;
    GetEngineConfig : () -> *ConfigRegistry;
    GetEnvironmentMapConfig : () -> *EnvironmentMapConfig;
    GetEnvironmentMapsToGenerate : () -> []*EnvironmentMap;
    GetFrameInFlight : () -> s64;
    GetFrameTimes : () -> min : float, max : float, avg : float;
    GetGPUFrameProfiler : () -> *GPUFrameProfiler;
    GetGfxContext : () -> *GfxContext;
    GetGfxFrameStatistics : () -> GfxFrameStatistics;
    GetGfxLimits : () -> GfxLimits;
    GetJointName : (anim : *ArmatureAnimation, joint_id : s16) -> string;
    GetJointNamesArray : (anim : *ArmatureAnimation) -> [][64]u8;
    GetJointSample : (anim : *ArmatureAnimation, joint_id : s16, pose_index : s64) -> *JointSample;
    GetKeyAxisValue : (negative : KeyCode, positive : KeyCode) -> float;
    GetMappedPtr : (buffer : *GfxBuffer) -> *void;
    GetModState : () -> KeyMods;
    GetModule : (id : ModuleID) -> *Module;
    GetMousePixelPosition : (window : *void) -> x : s32, y : s32;
    GetMousePixelPositionVector : (window : *void) -> Vector(N=2, T=float32);
    GetMousePointPosition : (window : *void) -> x : s32, y : s32;
    GetMousePointPositionVector : (window : *void) -> Vector(N=2, T=float32);
    GetMouseWheel : () -> Vector(N=2, T=float32);
    GetNumCPUs : () -> s32;
    GetPointPenetrationInBox : (point_inside_box : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32);
    GetRawMouseDelta : () -> Vector(N=2, T=float32);
    GetVkAllocationCallbacks : () -> *VkAllocationCallbacks;
    GetWindow : () -> *void;
    GetWindowPixelSize : (window : *void) -> width : s32, height : s32;
    GetWindowPointSize : (window : *void) -> width : s32, height : s32;
    GetWindowScaleFactor : (window : *void) -> float;
    InitArmaturePose : (pose : *ArmaturePose, mesh : *Asset(DataType=SkinnedMesh));
    InitGPUFrameProfiler : (profiler : *GPUFrameProfiler, max_events : s64);
    InitParser : (parser : *DeserializeParser, contents : string);
    InterpolateJointSamples : (a : JointSample, b : JointSample, t : float) -> JointSample;
    IsKeyDown : (key : KeyCode) -> bool;
    IsKeyPressed : (key : KeyCode) -> bool;
    IsKeyReleased : (key : KeyCode) -> bool;
    IsMouseButtonDown : (button : MouseButton) -> bool;
    IsMouseButtonPressed : (button : MouseButton) -> bool;
    IsMouseButtonReleased : (button : MouseButton) -> bool;
    LoadConfigFromFile : (registry : *ConfigRegistry);
    LoadGfxShader : (name : string, extra_compiler_args : []string = .[], dependencies : *[..]string = null) -> GfxShader;
    LoadPendingAssets : ();
    PointIsInsideBox : (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool;
    PointIsOnTriangle : (point : Vector(N=3, T=float32), triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), epsilon : float = 0.00001) -> bool;
    ProfilerBeginEvent : (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, name : string, location : Source_Code_Location = #caller_location) -> *GPUProfilingEvent;
    ProfilerBeginFrame : (profiler : *GPUFrameProfiler);
    ProfilerEndEvent : (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, event : *GPUProfilingEvent);
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
    QueueTextureUpload : (data : *void, texture : *Texture2D);
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
    RegisterConfigEntry : (registry : *ConfigRegistry, name : string, entry : Any) -> bool;
    RegisterDataDirectoryChangeCallback : (proc : (*File_Watcher(User_Data=void), *File_Change, *void), data : *void) -> s64;
    ResetGfxBindingPool : (pool : *GfxBindingPool);
    ResetGfxCommandPool : (pool : *GfxCommandPool);
    ResetToBindPose : (pose : *ArmaturePose);
    SampleAnimation : (anim : *ArmatureAnimation, pose_index : float, output_pose : *ArmaturePose);
    SerializeAny : (serializer : *Serializer, value : Any);
    SetBlendConstant : (pass : *GfxRenderPass, color : Vector(N=4, T=float32));
    SetScissor : (pass : *GfxRenderPass, rect : Rect(T=s32));
    SetStencilReference : (pass : *GfxRenderPass, front_value : u32, back_value : u32);
    SetViewport : (pass : *GfxRenderPass, viewport : GfxViewport);
    SubmitGfxCommandBuffer : (cmd_buffer : *GfxCommandBuffer);
    SubmitGfxFrame : ();
    SubtractPoses : (dest : *ArmaturePose, other : *ArmaturePose, weight : float = 1);
    TextureUploadPass : (cmd_buffer : *GfxCommandBuffer);
    TriangleIntersectsBox : (triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), triangle_normal : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool;
    TrimSpaces : (parser : *DeserializeParser);
    UnregisterConfigEntry : (registry : *ConfigRegistry, name : string) -> bool;
    UnregisterDataDirectoryChangeCallback : (index : s64);
    UpdateIndentation : (parser : *DeserializeParser);
    WaitForGPUIdle : ();
    WasKeyDown : (key : KeyCode) -> bool;
    WasMouseButtonDown : (button : MouseButton) -> bool;
    WriteConfigToFile : (registry : *ConfigRegistry);
}

#if Import_Mode == .Foreign {
g_Core : *CoreModule;

AddBarrier :: inline (cmd_buffer : *GfxCommandBuffer) {
    g_Core.AddBarrier_1(cmd_buffer);
} @NoProfile

AddBarrier :: inline (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, dst_sync_points : GfxBarrierSyncPointFlags) {
    g_Core.AddBarrier_2(cmd_buffer, src_sync_points, dst_sync_points);
} @NoProfile

AddMemoryBarrier :: inline (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags) {
    g_Core.AddMemoryBarrier(cmd_buffer, src_sync_points, src_accesses, dst_sync_points, dst_accesses);
} @NoProfile

AddPoses :: inline (dest : *ArmaturePose, other : *ArmaturePose, weight : float = 1) {
    g_Core.AddPoses(dest, other, weight);
} @NoProfile

AddTextureBarrier :: inline (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture) {
    g_Core.AddTextureBarrier_1(cmd_buffer, old_layout, new_layout, texture);
} @NoProfile

AddTextureBarrier :: inline (cmd_buffer : *GfxCommandBuffer, src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags, dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, texture : *GfxTexture) {
    g_Core.AddTextureBarrier_2(cmd_buffer, src_sync_points, src_accesses, dst_sync_points, dst_accesses, old_layout, new_layout, texture);
} @NoProfile

AddTextureBarriers :: inline (cmd_buffer : *GfxCommandBuffer, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout, textures : []*GfxTexture) {
    g_Core.AddTextureBarriers(cmd_buffer, old_layout, new_layout, textures);
} @NoProfile

AdvanceToNextLine :: inline (parser : *DeserializeParser) {
    g_Core.AdvanceToNextLine(parser);
} @NoProfile

AllocGfxBindingSet :: inline (pool : *GfxBindingPool, layout : *GfxBindingSetLayout) -> GfxBindingSet, GfxBindingPoolAllocResult {
    _ret0, _ret1 := g_Core.AllocGfxBindingSet(pool, layout);
    return _ret0, _ret1;
} @NoProfile

BeginGfxComputePass :: inline (cmd_buffer : *GfxCommandBuffer, name : string, location : Source_Code_Location = #caller_location) -> GfxComputePass {
    return g_Core.BeginGfxComputePass(cmd_buffer, name, location);
} @NoProfile

BeginGfxCopyPass :: inline (cmd_buffer : *GfxCommandBuffer, name : string, location : Source_Code_Location = #caller_location) -> GfxCopyPass {
    return g_Core.BeginGfxCopyPass(cmd_buffer, name, location);
} @NoProfile

BeginGfxDebugMarker :: inline (name : string) {
    g_Core.BeginGfxDebugMarker_1(name);
} @NoProfile

BeginGfxDebugMarker :: inline (cmd_buffer : *GfxCommandBuffer, name : string) {
    g_Core.BeginGfxDebugMarker_2(cmd_buffer, name);
} @NoProfile

BeginGfxFrame :: inline () {
    g_Core.BeginGfxFrame();
} @NoProfile

BeginGfxRenderPass :: inline (cmd_buffer : *GfxCommandBuffer, name : string, desc : GfxRenderPassDesc, location : Source_Code_Location = #caller_location) -> GfxRenderPass {
    return g_Core.BeginGfxRenderPass(cmd_buffer, name, desc, location);
} @NoProfile

BindComputeBindingSet :: inline (pass : *GfxComputePass, index : u32, set : *GfxBindingSet) {
    g_Core.BindComputeBindingSet_1(pass, index, set);
} @NoProfile

BindComputeBindingSet :: inline (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet) {
    g_Core.BindComputeBindingSet_2(cmd_buffer, layout, index, set);
} @NoProfile

BindComputePipeline :: inline (pass : *GfxComputePass, pipeline : *GfxComputePipeline) {
    g_Core.BindComputePipeline(pass, pipeline);
} @NoProfile

BindGraphicsBindingSet :: inline (pass : *GfxRenderPass, index : u32, set : *GfxBindingSet) {
    g_Core.BindGraphicsBindingSet_1(pass, index, set);
} @NoProfile

BindGraphicsBindingSet :: inline (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet) {
    g_Core.BindGraphicsBindingSet_2(cmd_buffer, layout, index, set);
} @NoProfile

BindGraphicsPipeline :: inline (pass : *GfxRenderPass, pipeline : *GfxGraphicsPipeline) {
    g_Core.BindGraphicsPipeline(pass, pipeline);
} @NoProfile

BindIndexBuffer :: inline (pass : *GfxRenderPass, type : GfxIndexType, buffer : *GfxBuffer, offset : u64 = 0) {
    g_Core.BindIndexBuffer(pass, type, buffer, offset);
} @NoProfile

BindVertexBuffer :: inline (pass : *GfxRenderPass, binding : u32, buffer : *GfxBuffer, offset : u64 = 0) {
    g_Core.BindVertexBuffer(pass, binding, buffer, offset);
} @NoProfile

BlendPoses :: inline (dest : *ArmaturePose, a : *ArmaturePose, b : *ArmaturePose, t : float) {
    g_Core.BlendPoses(dest, a, b, t);
} @NoProfile

CalculatePoseTransforms :: inline (pose : *ArmaturePose) {
    g_Core.CalculatePoseTransforms(pose);
} @NoProfile

CalculateSkinningMatrices :: inline (pose : *ArmaturePose, matrices : *[]Matrix(M=4, N=4, T=float32)) {
    g_Core.CalculateSkinningMatrices(pose, matrices);
} @NoProfile

CancelTextureUpload :: inline (texture : *Texture2D) {
    g_Core.CancelTextureUpload(texture);
} @NoProfile

ClearEnvironmentMapsToGenerate :: inline () {
    g_Core.ClearEnvironmentMapsToGenerate();
} @NoProfile

ClearGPUFrameProfiler :: inline (profiler : *GPUFrameProfiler) {
    g_Core.ClearGPUFrameProfiler(profiler);
} @NoProfile

CopyBufferToBuffer :: inline (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_buffer : *GfxBuffer, src_offset : u64, dst_offset : u64, size : u64) {
    g_Core.CopyBufferToBuffer(pass, src_buffer, dst_buffer, src_offset, dst_offset, size);
} @NoProfile

CopyBufferToTexture :: inline (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_texture : *GfxTexture) {
    g_Core.CopyBufferToTexture(pass, src_buffer, dst_texture);
} @NoProfile

CopyPose :: inline (dest : *ArmaturePose, src : *ArmaturePose) {
    g_Core.CopyPose(dest, src);
} @NoProfile

CopyTextureToBuffer :: inline (pass : *GfxCopyPass, src_texture : *GfxTexture, dst_buffer : *GfxBuffer) {
    g_Core.CopyTextureToBuffer(pass, src_texture, dst_buffer);
} @NoProfile

CreateGfxBindingPool :: inline (name : string, desc : GfxBindingPoolDesc) -> GfxBindingPool {
    return g_Core.CreateGfxBindingPool(name, desc);
} @NoProfile

CreateGfxBindingSetLayout :: inline (name : string, desc : GfxBindingSetLayoutDesc) -> GfxBindingSetLayout {
    return g_Core.CreateGfxBindingSetLayout(name, desc);
} @NoProfile

CreateGfxBuffer :: inline (name : string, desc : GfxBufferDesc) -> GfxBuffer {
    return g_Core.CreateGfxBuffer(name, desc);
} @NoProfile

CreateGfxCommandBuffer :: inline (name : string) -> GfxCommandBuffer {
    return g_Core.CreateGfxCommandBuffer(name);
} @NoProfile

CreateGfxComputePipeline :: inline (name : string, desc : GfxComputePipelineDesc) -> GfxComputePipeline {
    return g_Core.CreateGfxComputePipeline(name, desc);
} @NoProfile

CreateGfxGraphicsPipeline :: inline (name : string, desc : GfxGraphicsPipelineDesc) -> GfxGraphicsPipeline {
    return g_Core.CreateGfxGraphicsPipeline(name, desc);
} @NoProfile

CreateGfxPipelineLayout :: inline (name : string, desc : GfxPipelineLayoutDesc) -> GfxPipelineLayout {
    return g_Core.CreateGfxPipelineLayout(name, desc);
} @NoProfile

CreateGfxSampler :: inline (name : string, desc : GfxSamplerDesc) -> GfxSampler {
    return g_Core.CreateGfxSampler(name, desc);
} @NoProfile

CreateGfxTexture :: inline (name : string, desc : GfxTextureDesc) -> GfxTexture {
    return g_Core.CreateGfxTexture(name, desc);
} @NoProfile

CreateGfxTextureView :: inline (name : string, desc : GfxTextureViewDesc, texture : *GfxTexture) -> GfxTexture {
    return g_Core.CreateGfxTextureView(name, desc, texture);
} @NoProfile

DeferNextAssetLoadsForAllCaches :: inline () {
    g_Core.DeferNextAssetLoadsForAllCaches();
} @NoProfile

DeserializeAny :: inline (str : string, value : Any) -> DeserializeResult {
    return g_Core.DeserializeAny_1(str, value);
} @NoProfile

DeserializeAny :: inline (parser : *DeserializeParser, value : Any) -> DeserializeResult {
    return g_Core.DeserializeAny_2(parser, value);
} @NoProfile

DestroyGPUFrameProfiler :: inline (profiler : *GPUFrameProfiler) {
    g_Core.DestroyGPUFrameProfiler(profiler);
} @NoProfile

DestroyGfxBindingPool :: inline (pool : *GfxBindingPool) {
    g_Core.DestroyGfxBindingPool(pool);
} @NoProfile

DestroyGfxBindingSetLayout :: inline (layout : *GfxBindingSetLayout) {
    g_Core.DestroyGfxBindingSetLayout(layout);
} @NoProfile

DestroyGfxBuffer :: inline (buffer : *GfxBuffer) {
    g_Core.DestroyGfxBuffer(buffer);
} @NoProfile

DestroyGfxCommandPool :: inline (pool : *GfxCommandPool) {
    g_Core.DestroyGfxCommandPool(pool);
} @NoProfile

DestroyGfxComputePipeline :: inline (pipeline : *GfxComputePipeline) {
    g_Core.DestroyGfxComputePipeline(pipeline);
} @NoProfile

DestroyGfxGraphicsPipeline :: inline (pipeline : *GfxGraphicsPipeline) {
    g_Core.DestroyGfxGraphicsPipeline(pipeline);
} @NoProfile

DestroyGfxPipelineLayout :: inline (layout : *GfxPipelineLayout) {
    g_Core.DestroyGfxPipelineLayout(layout);
} @NoProfile

DestroyGfxSampler :: inline (sampler : *GfxSampler) {
    g_Core.DestroyGfxSampler(sampler);
} @NoProfile

DestroyGfxShader :: inline (shader : *GfxShader) {
    g_Core.DestroyGfxShader(shader);
} @NoProfile

DestroyGfxTexture :: inline (texture : *GfxTexture) {
    g_Core.DestroyGfxTexture(texture);
} @NoProfile

DestroyGfxTextureView :: inline (texture : *GfxTexture) {
    g_Core.DestroyGfxTextureView(texture);
} @NoProfile

Dispatch :: inline (pass : *GfxComputePass, num_groups_x : u32, num_groups_y : u32, num_groups_z : u32) {
    g_Core.Dispatch(pass, num_groups_x, num_groups_y, num_groups_z);
} @NoProfile

Draw :: inline (pass : *GfxRenderPass, vertex_count : u32, instance_count : u32, base_vertex : u32 = 0, base_instance : u32 = 0) {
    g_Core.Draw(pass, vertex_count, instance_count, base_vertex, base_instance);
} @NoProfile

DrawIndexed :: inline (pass : *GfxRenderPass, index_count : u32, instance_count : u32, base_index : u32 = 0, base_vertex : u32 = 0, base_instance : u32 = 0) {
    g_Core.DrawIndexed(pass, index_count, instance_count, base_index, base_vertex, base_instance);
} @NoProfile

EndGfxComputePass :: inline (pass : *GfxComputePass) {
    g_Core.EndGfxComputePass(pass);
} @NoProfile

EndGfxCopyPass :: inline (pass : *GfxCopyPass) {
    g_Core.EndGfxCopyPass(pass);
} @NoProfile

EndGfxDebugMarker :: inline () {
    g_Core.EndGfxDebugMarker_1();
} @NoProfile

EndGfxDebugMarker :: inline (cmd_buffer : *GfxCommandBuffer) {
    g_Core.EndGfxDebugMarker_2(cmd_buffer);
} @NoProfile

EndGfxRenderPass :: inline (pass : *GfxRenderPass) {
    g_Core.EndGfxRenderPass(pass);
} @NoProfile

FreeArmaturePose :: inline (pose : *ArmaturePose) {
    g_Core.FreeArmaturePose(pose);
} @NoProfile

GenerateMipmaps :: inline (pass : *GfxCopyPass, texture : *GfxTexture, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout) {
    g_Core.GenerateMipmaps(pass, texture, old_layout, new_layout);
} @NoProfile

GetAssets :: inline () -> *Assets {
    return g_Core.GetAssets();
} @NoProfile

GetBoxSplittingPlanes :: inline (center : Vector(N=3, T=float32)) -> x : Plane, y : Plane, z : Plane {
    _ret0, _ret1, _ret2 := g_Core.GetBoxSplittingPlanes(center);
    return _ret0, _ret1, _ret2;
} @NoProfile

GetCPUFrameProfiler :: inline () -> *CPUFrameProfiler {
    return g_Core.GetCPUFrameProfiler();
} @NoProfile

GetDataDirectoryAbsolutePath :: inline () -> string {
    return g_Core.GetDataDirectoryAbsolutePath();
} @NoProfile

GetDefaultNumWorkerThreads :: inline () -> s32 {
    return g_Core.GetDefaultNumWorkerThreads();
} @NoProfile

GetDeltaTime :: inline () -> float {
    return g_Core.GetDeltaTime();
} @NoProfile

GetEngineConfig :: inline () -> *ConfigRegistry {
    return g_Core.GetEngineConfig();
} @NoProfile

GetEnvironmentMapConfig :: inline () -> *EnvironmentMapConfig {
    return g_Core.GetEnvironmentMapConfig();
} @NoProfile

GetEnvironmentMapsToGenerate :: inline () -> []*EnvironmentMap {
    return g_Core.GetEnvironmentMapsToGenerate();
} @NoProfile

GetFrameInFlight :: inline () -> s64 {
    return g_Core.GetFrameInFlight();
} @NoProfile

GetFrameTimes :: inline () -> min : float, max : float, avg : float {
    _ret0, _ret1, _ret2 := g_Core.GetFrameTimes();
    return _ret0, _ret1, _ret2;
} @NoProfile

GetGPUFrameProfiler :: inline () -> *GPUFrameProfiler {
    return g_Core.GetGPUFrameProfiler();
} @NoProfile

GetGfxContext :: inline () -> *GfxContext {
    return g_Core.GetGfxContext();
} @NoProfile

GetGfxFrameStatistics :: inline () -> GfxFrameStatistics {
    return g_Core.GetGfxFrameStatistics();
} @NoProfile

GetGfxLimits :: inline () -> GfxLimits {
    return g_Core.GetGfxLimits();
} @NoProfile

GetJointName :: inline (anim : *ArmatureAnimation, joint_id : s16) -> string {
    return g_Core.GetJointName(anim, joint_id);
} @NoProfile

GetJointNamesArray :: inline (anim : *ArmatureAnimation) -> [][64]u8 {
    return g_Core.GetJointNamesArray(anim);
} @NoProfile

GetJointSample :: inline (anim : *ArmatureAnimation, joint_id : s16, pose_index : s64) -> *JointSample {
    return g_Core.GetJointSample(anim, joint_id, pose_index);
} @NoProfile

GetKeyAxisValue :: inline (negative : KeyCode, positive : KeyCode) -> float {
    return g_Core.GetKeyAxisValue(negative, positive);
} @NoProfile

GetMappedPtr :: inline (buffer : *GfxBuffer) -> *void {
    return g_Core.GetMappedPtr(buffer);
} @NoProfile

GetModState :: inline () -> KeyMods {
    return g_Core.GetModState();
} @NoProfile

GetModule :: inline (id : ModuleID) -> *Module {
    return g_Core.GetModule(id);
} @NoProfile

GetMousePixelPosition :: inline (window : *void) -> x : s32, y : s32 {
    _ret0, _ret1 := g_Core.GetMousePixelPosition(window);
    return _ret0, _ret1;
} @NoProfile

GetMousePixelPositionVector :: inline (window : *void) -> Vector(N=2, T=float32) {
    return g_Core.GetMousePixelPositionVector(window);
} @NoProfile

GetMousePointPosition :: inline (window : *void) -> x : s32, y : s32 {
    _ret0, _ret1 := g_Core.GetMousePointPosition(window);
    return _ret0, _ret1;
} @NoProfile

GetMousePointPositionVector :: inline (window : *void) -> Vector(N=2, T=float32) {
    return g_Core.GetMousePointPositionVector(window);
} @NoProfile

GetMouseWheel :: inline () -> Vector(N=2, T=float32) {
    return g_Core.GetMouseWheel();
} @NoProfile

GetNumCPUs :: inline () -> s32 {
    return g_Core.GetNumCPUs();
} @NoProfile

GetPointPenetrationInBox :: inline (point_inside_box : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32) {
    return g_Core.GetPointPenetrationInBox(point_inside_box, box_center, box_half_extents);
} @NoProfile

GetRawMouseDelta :: inline () -> Vector(N=2, T=float32) {
    return g_Core.GetRawMouseDelta();
} @NoProfile

GetVkAllocationCallbacks :: inline () -> *VkAllocationCallbacks {
    return g_Core.GetVkAllocationCallbacks();
} @NoProfile

GetWindow :: inline () -> *void {
    return g_Core.GetWindow();
} @NoProfile

GetWindowPixelSize :: inline (window : *void) -> width : s32, height : s32 {
    _ret0, _ret1 := g_Core.GetWindowPixelSize(window);
    return _ret0, _ret1;
} @NoProfile

GetWindowPointSize :: inline (window : *void) -> width : s32, height : s32 {
    _ret0, _ret1 := g_Core.GetWindowPointSize(window);
    return _ret0, _ret1;
} @NoProfile

GetWindowScaleFactor :: inline (window : *void) -> float {
    return g_Core.GetWindowScaleFactor(window);
} @NoProfile

InitArmaturePose :: inline (pose : *ArmaturePose, mesh : *Asset(DataType=SkinnedMesh)) {
    g_Core.InitArmaturePose(pose, mesh);
} @NoProfile

InitGPUFrameProfiler :: inline (profiler : *GPUFrameProfiler, max_events : s64) {
    g_Core.InitGPUFrameProfiler(profiler, max_events);
} @NoProfile

InitParser :: inline (parser : *DeserializeParser, contents : string) {
    g_Core.InitParser(parser, contents);
} @NoProfile

InterpolateJointSamples :: inline (a : JointSample, b : JointSample, t : float) -> JointSample {
    return g_Core.InterpolateJointSamples(a, b, t);
} @NoProfile

IsKeyDown :: inline (key : KeyCode) -> bool {
    return g_Core.IsKeyDown(key);
} @NoProfile

IsKeyPressed :: inline (key : KeyCode) -> bool {
    return g_Core.IsKeyPressed(key);
} @NoProfile

IsKeyReleased :: inline (key : KeyCode) -> bool {
    return g_Core.IsKeyReleased(key);
} @NoProfile

IsMouseButtonDown :: inline (button : MouseButton) -> bool {
    return g_Core.IsMouseButtonDown(button);
} @NoProfile

IsMouseButtonPressed :: inline (button : MouseButton) -> bool {
    return g_Core.IsMouseButtonPressed(button);
} @NoProfile

IsMouseButtonReleased :: inline (button : MouseButton) -> bool {
    return g_Core.IsMouseButtonReleased(button);
} @NoProfile

LoadConfigFromFile :: inline (registry : *ConfigRegistry) {
    g_Core.LoadConfigFromFile(registry);
} @NoProfile

LoadGfxShader :: inline (name : string, extra_compiler_args : []string = .[], dependencies : *[..]string = null) -> GfxShader {
    return g_Core.LoadGfxShader(name, extra_compiler_args, dependencies);
} @NoProfile

LoadPendingAssets :: inline () {
    g_Core.LoadPendingAssets();
} @NoProfile

PointIsInsideBox :: inline (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool {
    return g_Core.PointIsInsideBox(point, box_center, box_half_extents);
} @NoProfile

PointIsOnTriangle :: inline (point : Vector(N=3, T=float32), triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), epsilon : float = 0.00001) -> bool {
    return g_Core.PointIsOnTriangle(point, triangle_A, triangle_B, triangle_C, epsilon);
} @NoProfile

ProfilerBeginEvent :: inline (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, name : string, location : Source_Code_Location = #caller_location) -> *GPUProfilingEvent {
    return g_Core.ProfilerBeginEvent(cmd_buffer, profiler, name, location);
} @NoProfile

ProfilerBeginFrame :: inline (profiler : *GPUFrameProfiler) {
    g_Core.ProfilerBeginFrame(profiler);
} @NoProfile

ProfilerEndEvent :: inline (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, event : *GPUProfilingEvent) {
    g_Core.ProfilerEndEvent(cmd_buffer, profiler, event);
} @NoProfile

ProjectPointOnBox :: inline (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> Vector(N=3, T=float32) {
    return g_Core.ProjectPointOnBox_1(point, box_center, box_half_extents);
} @NoProfile

ProjectPointOnBox :: inline (point : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32)) -> Vector(N=3, T=float32) {
    return g_Core.ProjectPointOnBox_2(point, box_center, box_half_extents, orientation);
} @NoProfile

ProjectPointOnCapsule :: inline (point : Vector(N=3, T=float32), capsule_base : Vector(N=3, T=float32), capsule_tip : Vector(N=3, T=float32), capsule_radius : float) -> Vector(N=3, T=float32) {
    return g_Core.ProjectPointOnCapsule(point, capsule_base, capsule_tip, capsule_radius);
} @NoProfile

ProjectPointOnLine :: inline (point : Vector(N=3, T=float32), line_origin : Vector(N=3, T=float32), line_dir : Vector(N=3, T=float32)) -> Vector(N=3, T=float32), t : float {
    _ret0, _ret1 := g_Core.ProjectPointOnLine(point, line_origin, line_dir);
    return _ret0, _ret1;
} @NoProfile

ProjectPointOnPlane :: inline (point : Vector(N=3, T=float32), plane_origin : Vector(N=3, T=float32), plane_normal : Vector(N=3, T=float32)) -> Vector(N=3, T=float32) {
    return g_Core.ProjectPointOnPlane(point, plane_origin, plane_normal);
} @NoProfile

ProjectPointOnRay :: inline (point : Vector(N=3, T=float32), ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float) -> Vector(N=3, T=float32), t : float {
    _ret0, _ret1 := g_Core.ProjectPointOnRay(point, ray_origin, ray_dir, ray_length);
    return _ret0, _ret1;
} @NoProfile

ProjectPointOnSphere :: inline (point : Vector(N=3, T=float32), sphere_center : Vector(N=3, T=float32), sphere_radius : float) -> Vector(N=3, T=float32) {
    return g_Core.ProjectPointOnSphere(point, sphere_center, sphere_radius);
} @NoProfile

QueueDestroyGfxBuffer :: inline (buffer : *GfxBuffer) {
    g_Core.QueueDestroyGfxBuffer(buffer);
} @NoProfile

QueueDestroyGfxSampler :: inline (sampler : *GfxSampler) {
    g_Core.QueueDestroyGfxSampler(sampler);
} @NoProfile

QueueDestroyGfxTexture :: inline (texture : *GfxTexture) {
    g_Core.QueueDestroyGfxTexture(texture);
} @NoProfile

QueueDestroyGfxTextureView :: inline (texture : *GfxTexture) {
    g_Core.QueueDestroyGfxTextureView(texture);
} @NoProfile

QueueTextureUpload :: inline (data : *void, texture : *Texture2D) {
    g_Core.QueueTextureUpload(data, texture);
} @NoProfile

Quit :: inline () {
    g_Core.Quit();
} @NoProfile

RayIntersectsBox :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsBox_1(ray_origin, ray_dir, ray_length, half_extents, transform);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RayIntersectsBox :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsBox_2(ray_origin, ray_dir, ray_length, box_center, box_half_extents);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RayIntersectsBox :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsBox_3(ray_origin, ray_dir, ray_length, box_center, box_half_extents, orientation);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RayIntersectsCapsule :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, capsule_base : Vector(N=3, T=float32), capsule_tip : Vector(N=3, T=float32), capsule_radius : float) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsCapsule(ray_origin, ray_dir, ray_length, capsule_base, capsule_tip, capsule_radius);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RayIntersectsMesh :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, mesh : *StaticMesh, transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32), triangle_index : s64 {
    _ret0, _ret1, _ret2, _ret3, _ret4 := g_Core.RayIntersectsMesh_1(ray_origin, ray_dir, ray_length, mesh, transform);
    return _ret0, _ret1, _ret2, _ret3, _ret4;
} @NoProfile

RayIntersectsMesh :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, mesh : *StaticMesh, transform : Matrix(M=4, N=4, T=float32), inv_transform : Matrix(M=4, N=4, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32), triangle_index : s64 {
    _ret0, _ret1, _ret2, _ret3, _ret4 := g_Core.RayIntersectsMesh_2(ray_origin, ray_dir, ray_length, mesh, transform, inv_transform);
    return _ret0, _ret1, _ret2, _ret3, _ret4;
} @NoProfile

RayIntersectsOctreeMesh :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), mesh : *CollisionMesh, octree_index : s64, octree_center : Vector(N=3, T=float32), octree_half_size : float) -> intersects : bool, point : Vector(N=3, T=float32), normal : Vector(N=3, T=float32), triangle_index : s64, octree_index : s64 {
    _ret0, _ret1, _ret2, _ret3, _ret4 := g_Core.RayIntersectsOctreeMesh(ray_origin, ray_dir, mesh, octree_index, octree_center, octree_half_size);
    return _ret0, _ret1, _ret2, _ret3, _ret4;
} @NoProfile

RayIntersectsPlane :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, plane_origin : Vector(N=3, T=float32), plane_normal : Vector(N=3, T=float32)) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsPlane(ray_origin, ray_dir, ray_length, plane_origin, plane_normal);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RayIntersectsSphere :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, sphere_center : Vector(N=3, T=float32), sphere_radius : float) -> intersects : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsSphere(ray_origin, ray_dir, ray_length, sphere_center, sphere_radius);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RayIntersectsTriangle :: inline (ray_origin : Vector(N=3, T=float32), ray_dir : Vector(N=3, T=float32), ray_length : float, triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32)) -> intersets : bool, point : Vector(N=3, T=float32), dist : float, normal : Vector(N=3, T=float32) {
    _ret0, _ret1, _ret2, _ret3 := g_Core.RayIntersectsTriangle(ray_origin, ray_dir, ray_length, triangle_A, triangle_B, triangle_C);
    return _ret0, _ret1, _ret2, _ret3;
} @NoProfile

RegisterConfigEntry :: inline (registry : *ConfigRegistry, name : string, entry : Any) -> bool {
    return g_Core.RegisterConfigEntry(registry, name, entry);
} @NoProfile

RegisterDataDirectoryChangeCallback :: inline (proc : (*File_Watcher(User_Data=void), *File_Change, *void), data : *void) -> s64 {
    return g_Core.RegisterDataDirectoryChangeCallback(proc, data);
} @NoProfile

ResetGfxBindingPool :: inline (pool : *GfxBindingPool) {
    g_Core.ResetGfxBindingPool(pool);
} @NoProfile

ResetGfxCommandPool :: inline (pool : *GfxCommandPool) {
    g_Core.ResetGfxCommandPool(pool);
} @NoProfile

ResetToBindPose :: inline (pose : *ArmaturePose) {
    g_Core.ResetToBindPose(pose);
} @NoProfile

SampleAnimation :: inline (anim : *ArmatureAnimation, pose_index : float, output_pose : *ArmaturePose) {
    g_Core.SampleAnimation(anim, pose_index, output_pose);
} @NoProfile

SerializeAny :: inline (serializer : *Serializer, value : Any) {
    g_Core.SerializeAny(serializer, value);
} @NoProfile

SetBlendConstant :: inline (pass : *GfxRenderPass, color : Vector(N=4, T=float32)) {
    g_Core.SetBlendConstant(pass, color);
} @NoProfile

SetScissor :: inline (pass : *GfxRenderPass, rect : Rect(T=s32)) {
    g_Core.SetScissor(pass, rect);
} @NoProfile

SetStencilReference :: inline (pass : *GfxRenderPass, front_value : u32, back_value : u32) {
    g_Core.SetStencilReference(pass, front_value, back_value);
} @NoProfile

SetViewport :: inline (pass : *GfxRenderPass, viewport : GfxViewport) {
    g_Core.SetViewport(pass, viewport);
} @NoProfile

SubmitGfxCommandBuffer :: inline (cmd_buffer : *GfxCommandBuffer) {
    g_Core.SubmitGfxCommandBuffer(cmd_buffer);
} @NoProfile

SubmitGfxFrame :: inline () {
    g_Core.SubmitGfxFrame();
} @NoProfile

SubtractPoses :: inline (dest : *ArmaturePose, other : *ArmaturePose, weight : float = 1) {
    g_Core.SubtractPoses(dest, other, weight);
} @NoProfile

TextureUploadPass :: inline (cmd_buffer : *GfxCommandBuffer) {
    g_Core.TextureUploadPass(cmd_buffer);
} @NoProfile

TriangleIntersectsBox :: inline (triangle_A : Vector(N=3, T=float32), triangle_B : Vector(N=3, T=float32), triangle_C : Vector(N=3, T=float32), triangle_normal : Vector(N=3, T=float32), box_center : Vector(N=3, T=float32), box_half_extents : Vector(N=3, T=float32)) -> bool {
    return g_Core.TriangleIntersectsBox(triangle_A, triangle_B, triangle_C, triangle_normal, box_center, box_half_extents);
} @NoProfile

TrimSpaces :: inline (parser : *DeserializeParser) {
    g_Core.TrimSpaces(parser);
} @NoProfile

UnregisterConfigEntry :: inline (registry : *ConfigRegistry, name : string) -> bool {
    return g_Core.UnregisterConfigEntry(registry, name);
} @NoProfile

UnregisterDataDirectoryChangeCallback :: inline (index : s64) {
    g_Core.UnregisterDataDirectoryChangeCallback(index);
} @NoProfile

UpdateIndentation :: inline (parser : *DeserializeParser) {
    g_Core.UpdateIndentation(parser);
} @NoProfile

WaitForGPUIdle :: inline () {
    g_Core.WaitForGPUIdle();
} @NoProfile

WasKeyDown :: inline (key : KeyCode) -> bool {
    return g_Core.WasKeyDown(key);
} @NoProfile

WasMouseButtonDown :: inline (button : MouseButton) -> bool {
    return g_Core.WasMouseButtonDown(button);
} @NoProfile

WriteConfigToFile :: inline (registry : *ConfigRegistry) {
    g_Core.WriteConfigToFile(registry);
} @NoProfile

}
