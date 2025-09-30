DirectionalLight :: struct {
    direction : Vec3f;
    color : Vec3f;
    intensity : float;
    shadow_map_index : s32;
    shadow_map_resolution : u32;
    shadow_map_cascade_sizes : [Num_Shadow_Map_Cascades]float = Shadow_Map_Cascade_Sizes;
    shadow_map_viewpoints : [Num_Shadow_Map_Cascades]Viewpoint;
} @ShaderType

PointLight :: struct {
    position : Vec3f;
    color : Vec3f;
    intensity : float;
    intensity_radius : float;
    source_radius : float;
    shadow_map_index : s32;
    shadow_map_resolution : u32;
    shadow_map_viewpoints : [6]Viewpoint;
} @ShaderType

LightCluster :: struct {
    min : Vec3f;
    max : Vec3f;
    num_lights : u32;
    lights : [Max_Lights_Per_Clusters]u32 = ---;
} @ShaderType

using _ :: struct {
    Max_Lights_Per_Clusters :: 100;
    Num_Clusters_X :: 16;
    Num_Clusters_Y :: 9;
    Num_Clusters_Z :: 24;
    Num_Clusters :: Num_Clusters_X * Num_Clusters_Y * Num_Clusters_Z;
    Populate_Cluster_Grid_Work_Group_Size :: Num_Clusters_X * Num_Clusters_Y;
} @ShaderType

ClusterGridBindingSet :: struct {
    clusters : GfxBindingStorageBuffer; @Binding(0) @ComputeStage
    viewpoint : GfxBindingUniformBuffer; @Binding(1) @ComputeStage
} @BindingSet

g_build_cluster_grid_pipeline : GfxComputePipeline;

CreateBuildClusterGridPipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("build_cluster_grid");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.ClusterGridBindingSet,
    ];

    ok := CreateGfxComputePipeline(*g_build_cluster_grid_pipeline, "Build Cluster Grid", desc);
    Assert(ok, "Could not create build cluster grid pipeline");
}

BuildClusterGrid :: (using ctx : *RenderContext) {
    if IsNull(*g_build_cluster_grid_pipeline) {
        CreateBuildClusterGridPipeline();
    }

    pass := BeginGfxComputePass(cmd_buffer, "Build Cluster Grid");
    {
        BindComputePipeline(*pass, *g_build_cluster_grid_pipeline);

        Dispatch(*pass, Num_Clusters_X, Num_Clusters_Y, Num_Clusters_Z);
    }
    EndGfxComputePass(*pass);
}

g_populate_cluster_grid_pipeline : GfxComputePipeline;

CreatePopulateClusterGridPipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("populate_cluster_grid");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.ClusterGridBindingSet,
    ];

    ok := CreateGfxComputePipeline(*g_populate_cluster_grid_pipeline, "Populate Cluster Grid", desc);
    Assert(ok, "Could not create populate cluster grid pipeline");
}

PopulateClusterGrid :: (using ctx : *RenderContext) {
    if IsNull(*g_populate_cluster_grid_pipeline) {
        CreatePopulateClusterGridPipeline();
    }

    pass := BeginGfxComputePass(cmd_buffer, "Populate Cluster Grid");
    {
        BindComputePipeline(*pass, *g_populate_cluster_grid_pipeline);
        Dispatch(*pass, Num_Clusters / Populate_Cluster_Grid_Work_Group_Size, 1, 1);
    }
    EndGfxComputePass(*pass);
}

// PrepareClusters :: (using ctx : *RenderContext, camera : *Camera) {
//     if IsNull(*g_build_cluster_grid_pipeline) {
//         CreateBuildClusterGridPipeline();
//     }

//     if IsNull(*g_populate_cluster_grid_pipeline) {
//         CreatePopulateClusterGridPipeline();
//     }

//     clusters_size = xx (GLSLStd430Size(LightCluster) * Num_Clusters);
//     clusters_offset = xx AllocFrameData(clusters_size);

//     viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(camera));

//     bindings := ClusterGridBindingSet.{
//         clusters=.{buffer=FrameDataBuffer(), offset=xx clusters_offset, size=xx clusters_size},
//         viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
//     };
//     binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
//     BindComputeBindingSet(cmd_buffer, *g_build_cluster_grid_pipeline.layout, 1, *binding_set);

//     BuildClusterGrid(ctx);

//     AddMemoryBarrier(cmd_buffer, .AllCompute, .AllWrites, .AllCompute, .AllReads | .AllWrites);

//     PopulateClusterGrid(ctx);

//     AddMemoryBarrier(cmd_buffer, .AllCompute, .AllWrites, .AllCompute, .AllReads | .AllWrites);
// }
