CreateGfxPipelineLayout :: (name : string, desc : GfxPipelineLayoutDesc) -> GfxPipelineLayout {
    LogSectionScope(*Log_Vulkan);

    layout_info : VkPipelineLayoutCreateInfo;
    layout_info.setLayoutCount = xx desc.binding_sets.count;
    layout_info.pSetLayouts = Alloc(VkDescriptorSetLayout, desc.binding_sets.count, initialize=true ,, Temp);
    for desc.binding_sets {
        layout_info.pSetLayouts[it_index] = it.layout;
    }

    layout : VkPipelineLayout;
    if vkCreatePipelineLayout(g_gfx_context.device, *layout_info, g_vk_alloc_callbacks, *layout) != .SUCCESS {
        return .{};
    }

    SetDebugName(layout, TPrint("Pipeline Layout '%'", name));

    return .{layout=layout, name=StringClone(name)};
} @ModuleAPI

DestroyGfxPipelineLayout :: (layout : *GfxPipelineLayout) {
    Free(layout.name.data);
    vkDestroyPipelineLayout(g_gfx_context.device, layout.layout, g_vk_alloc_callbacks);
    layout.* = .{};
} @ModuleAPI

CreateGfxGraphicsPipeline :: (name : string, desc : GfxGraphicsPipelineDesc) -> GfxGraphicsPipeline {
    LogSectionScope(*Log_Vulkan);

    layout := CreateGfxPipelineLayout(name, desc.layout);
    if IsNull(*layout) {
        return .{};
    }

    vertex_stage : VkPipelineShaderStageCreateInfo;
    vertex_stage.stage = .VERTEX_BIT;
    vertex_stage.pName = "main";
    vertex_stage.module = desc.vertex_shader.module;

    fragment_stage : VkPipelineShaderStageCreateInfo;
    if !IsNull(desc.fragment_shader) {
        fragment_stage.stage = .FRAGMENT_BIT;
        fragment_stage.pName = "main";
        fragment_stage.module = desc.fragment_shader.module;
    }

    shader_stages := VkPipelineShaderStageCreateInfo.[vertex_stage, fragment_stage];

    vertex_input_state : VkPipelineVertexInputStateCreateInfo;
    vertex_input_state.vertexBindingDescriptionCount = xx desc.vertex_input.buffer_bindings.count;
    vertex_input_state.pVertexBindingDescriptions = Alloc(VkVertexInputBindingDescription, desc.vertex_input.buffer_bindings.count, initialize=true ,, Temp);
    for desc.vertex_input.buffer_bindings {
        vertex_input_state.pVertexBindingDescriptions[it_index].binding = it.binding;
        vertex_input_state.pVertexBindingDescriptions[it_index].stride = it.stride;
        vertex_input_state.pVertexBindingDescriptions[it_index].inputRate = .VERTEX;
    }

    vertex_input_state.vertexAttributeDescriptionCount = xx desc.vertex_input.attributes.count;
    vertex_input_state.pVertexAttributeDescriptions = Alloc(VkVertexInputAttributeDescription, desc.vertex_input.attributes.count, initialize=true ,, Temp);
    for desc.vertex_input.attributes {
        vertex_input_state.pVertexAttributeDescriptions[it_index].location = it.location;
        vertex_input_state.pVertexAttributeDescriptions[it_index].binding = it.binding;
        vertex_input_state.pVertexAttributeDescriptions[it_index].format = MakeVkFormat(it.format, it.normalized);
        vertex_input_state.pVertexAttributeDescriptions[it_index].offset = it.offset;
    }

    input_assembly_state : VkPipelineInputAssemblyStateCreateInfo;
    if #complete desc.primitive_topology == {
    case .PointList;    input_assembly_state.topology = .POINT_LIST;
    case .LineList;     input_assembly_state.topology = .LINE_LIST;
    case .TriangleList; input_assembly_state.topology = .TRIANGLE_LIST;
    }

    dynamic_states := VkDynamicState.[.VIEWPORT, .SCISSOR, .BLEND_CONSTANTS, .STENCIL_REFERENCE];
    dynamic_state : VkPipelineDynamicStateCreateInfo;
    dynamic_state.dynamicStateCount = dynamic_states.count;
    dynamic_state.pDynamicStates = dynamic_states.data;

    viewport_state : VkPipelineViewportStateCreateInfo;
    viewport_state.viewportCount = 1;
    viewport_state.scissorCount = 1;

    rasterizer_state : VkPipelineRasterizationStateCreateInfo;
    if #complete desc.rasterizer_state.fill_mode == {
    case .Fill;  rasterizer_state.polygonMode = .FILL;
    case .Lines; rasterizer_state.polygonMode = .LINE;
    }

    rasterizer_state.lineWidth = 1;
    if #complete desc.rasterizer_state.cull_face == {
    case .None;  rasterizer_state.cullMode = 0;
    case .Front; rasterizer_state.cullMode = .FRONT_BIT;
    case .Back;  rasterizer_state.cullMode = .BACK_BIT;
    }

    if #complete desc.rasterizer_state.winding_order == {
    case .Clockwise;        rasterizer_state.frontFace = .CLOCKWISE;
    case .CounterClockwise; rasterizer_state.frontFace = .COUNTER_CLOCKWISE;
    }

    multisample_state : VkPipelineMultisampleStateCreateInfo;
    multisample_state.sampleShadingEnable = VK_FALSE;

    if desc.rasterizer_state.num_samples == {
    case 1;  multisample_state.rasterizationSamples = ._1_BIT;
    case 2;  multisample_state.rasterizationSamples = ._2_BIT;
    case 4;  multisample_state.rasterizationSamples = ._4_BIT;
    case 8;  multisample_state.rasterizationSamples = ._8_BIT;
    case 16; multisample_state.rasterizationSamples = ._16_BIT;
    case 32; multisample_state.rasterizationSamples = ._32_BIT;
    case 64; multisample_state.rasterizationSamples = ._64_BIT;
    case; Panic("Invalid sample count % for texture (expected 1, 2, 4, 8, 16, 32 or 64)", desc.rasterizer_state.num_samples);
    }

    blend_states : [Gfx_Max_Color_Attachments]VkPipelineColorBlendAttachmentState;
    for desc.blend_states {
        blend_states[it_index].colorWriteMask = .R_BIT | .G_BIT | .B_BIT | .A_BIT;
        blend_states[it_index].blendEnable = cast(VkBool32, it.enabled);
        blend_states[it_index].srcColorBlendFactor = MakeVkBlendFactor(it.src_color_factor);
        blend_states[it_index].dstColorBlendFactor = MakeVkBlendFactor(it.dst_color_factor);
        blend_states[it_index].srcAlphaBlendFactor = MakeVkBlendFactor(it.src_alpha_factor);
        blend_states[it_index].dstAlphaBlendFactor = MakeVkBlendFactor(it.dst_alpha_factor);
        blend_states[it_index].colorBlendOp = MakeVkBlendOp(it.color_op);
        blend_states[it_index].alphaBlendOp = MakeVkBlendOp(it.alpha_op);
    }

    blend_state : VkPipelineColorBlendStateCreateInfo;
    blend_state.attachmentCount = desc.num_color_attachments;
    blend_state.pAttachments = blend_states.data;

    depth_stencil_state : VkPipelineDepthStencilStateCreateInfo;
    depth_stencil_state.depthTestEnable = cast(VkBool32, desc.depth_state.test_enabled);
    depth_stencil_state.depthWriteEnable = cast(VkBool32, desc.depth_state.write_enabled);
    depth_stencil_state.depthCompareOp = MakeVkCompareOp(desc.depth_state.compare_op);
    depth_stencil_state.stencilTestEnable = cast(VkBool32, desc.stencil_state.test_enabled);

    for i : 0..1 {
        result := ifx i == 0 then *depth_stencil_state.front else *depth_stencil_state.back;
        stencil := ifx i == 0 then *desc.stencil_state.front_face else *desc.stencil_state.back_face;

        result.failOp = MakeVkStencilOp(stencil.failed_op);
        result.passOp = MakeVkStencilOp(stencil.passed_op);
        result.depthFailOp = MakeVkStencilOp(stencil.depth_failed_op);
        result.compareOp = MakeVkCompareOp(stencil.compare_op);
        result.writeMask = stencil.write_mask;
        result.compareMask = stencil.read_mask;
    }

    color_attachments : [Gfx_Max_Color_Attachments]VkFormat;
    for desc.color_formats {
        color_attachments[it_index] = MakeVkFormat(it);
    }

    rendering_info : VkPipelineRenderingCreateInfo;
    rendering_info.colorAttachmentCount = desc.num_color_attachments;
    rendering_info.pColorAttachmentFormats = color_attachments.data;
    rendering_info.depthAttachmentFormat = MakeVkFormat(desc.depth_format);
    rendering_info.stencilAttachmentFormat = MakeVkFormat(desc.stencil_format);

    pipeline_info : VkGraphicsPipelineCreateInfo;
    pipeline_info.pNext = *rendering_info;
    pipeline_info.stageCount = xx ifx IsNull(desc.fragment_shader) then 1 else 2;
    pipeline_info.pStages = shader_stages.data;
    pipeline_info.pVertexInputState = *vertex_input_state;
    pipeline_info.pInputAssemblyState = *input_assembly_state;
    pipeline_info.pViewportState = *viewport_state;
    pipeline_info.pRasterizationState = *rasterizer_state;
    pipeline_info.pMultisampleState = *multisample_state;
    pipeline_info.pDepthStencilState = *depth_stencil_state;
    pipeline_info.pColorBlendState = *blend_state;
    pipeline_info.pDynamicState = *dynamic_state;
    pipeline_info.layout = layout.layout;

    pipeline : VkPipeline;
    if vkCreateGraphicsPipelines(g_gfx_context.device, VK_NULL_HANDLE, 1, *pipeline_info, g_vk_alloc_callbacks, *pipeline) != .SUCCESS {
        DestroyGfxPipelineLayout(*layout);
        return .{};
    }

    SetDebugName(pipeline, TPrint("Graphics Pipeline '%'", name));

    copied_desc := desc;
    copied_desc.vertex_input.attributes = ArrayClone(desc.vertex_input.attributes);
    copied_desc.vertex_input.buffer_bindings = ArrayClone(desc.vertex_input.buffer_bindings);

    return .{layout=layout, pipeline=pipeline, name=StringClone(name), desc=copied_desc};
} @ModuleAPI

DestroyGfxGraphicsPipeline :: (pipeline : *GfxGraphicsPipeline) {
    LogSectionScope(*Log_Vulkan);

    Free(pipeline.name.data);
    Free(pipeline.desc.vertex_input.attributes.data);
    Free(pipeline.desc.vertex_input.buffer_bindings.data);

    DestroyGfxPipelineLayout(*pipeline.layout);
    vkDestroyPipeline(g_gfx_context.device, pipeline.pipeline, g_vk_alloc_callbacks);
    pipeline.* = .{};
} @ModuleAPI

CreateGfxComputePipeline :: (name : string, desc : GfxComputePipelineDesc) -> GfxComputePipeline {
    LogSectionScope(*Log_Vulkan);

    layout := CreateGfxPipelineLayout(name, desc.layout);
    if IsNull(*layout) {
        return .{};
    }

    create_info : VkComputePipelineCreateInfo;
    create_info.stage.stage = .COMPUTE_BIT;
    create_info.stage.pName = "main";
    create_info.stage.module = desc.shader.module;
    create_info.layout = layout.layout;

    pipeline : VkPipeline;
    if vkCreateComputePipelines(g_gfx_context.device, VK_NULL_HANDLE, 1, *create_info, g_vk_alloc_callbacks, *pipeline) != .SUCCESS {
        DestroyGfxPipelineLayout(*layout);
        return .{};
    }

    SetDebugName(pipeline, TPrint("Compute Pipeline '%'", name));

    return .{layout=layout, pipeline=pipeline, name=StringClone(name), desc=desc};
} @ModuleAPI

DestroyGfxComputePipeline :: (pipeline : *GfxComputePipeline) {
    LogSectionScope(*Log_Vulkan);

    Free(pipeline.name.data);
    DestroyGfxPipelineLayout(*pipeline.layout);
    vkDestroyPipeline(g_gfx_context.device, pipeline.pipeline, g_vk_alloc_callbacks);
    pipeline.* = .{};
} @ModuleAPI
