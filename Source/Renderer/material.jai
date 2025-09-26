MaterialPerInstance :: struct {
    type : MaterialType;
    flags : MaterialFlags;
    base_color_tint : Vec3f;
    metallic : float;
    roughness : float;
    emissive_tint : Vec3f;
    emissive_strength : float;
    depth_map_scale : float;
    alpha_cutoff : float;
} @ShaderType

operator== :: inline (a : MaterialPerInstance, b : MaterialPerInstance) -> bool {
    return memcmp(*a, *b, size_of(MaterialPerInstance)) == 0;
}

MakeMaterialPerInstance :: inline (material : *Material) -> MaterialPerInstance {
    return .{
        type=material.type,
        flags=MakeMaterialFlags(material),
        base_color_tint=material.base_color_tint,
        metallic=material.metallic,
        roughness=material.roughness,
        emissive_tint=material.emissive_tint,
        emissive_strength=material.emissive_strength,
        depth_map_scale=material.depth_map_scale,
        alpha_cutoff=material.alpha_cutoff,
    };
}

MaterialPerDrawCall :: struct {
    type : MaterialType;
    base_color : *Asset(Texture2D);
    normal_map : *Asset(Texture2D);
    metallic_roughness_map : *Asset(Texture2D);
    emissive : *Asset(Texture2D);
    depth_map : *Asset(Texture2D);
}

operator== :: inline (a : MaterialPerDrawCall, b : MaterialPerDrawCall) -> bool {
    return memcmp(*a, *b, size_of(MaterialPerInstance)) == 0;
}

MakeMaterialPerDrawCall :: inline (material : *Material) -> MaterialPerDrawCall {
    return .{
        type=material.type,
        base_color=material.base_color,
        normal_map=material.normal_map,
        metallic_roughness_map=material.metallic_roughness_map,
        emissive=material.emissive,
        depth_map=material.depth_map,
    };
}

// We have many pipelines to manage to render our meshes with different materials:
// num material types * num passes * num variations (wireframe * skinned * ...)
// This system creates pipelines for all the variations and for a given render pass
// based on a template desc and a description of the shaders each material type uses

// TLDR:
//  * MaterialDesc defines stuff per material type
//  * MaterialRenderPass defines stuff per render pass
//  * MaterialPipelines defines the pipelines for each variation of a given material (though MaterialRenderPass
// caches these so material types that end up using the same params will use the same pipelines)

MaterialDesc :: struct {
    vertex_shader : string;
    shading_fragment_shader : string;
    depth_only_fragment_shader : string;
    entity_guid_fragment_shader := "entity_guid";
}

// This array describes shaders to be used per material type. The vertex shader is always used in any render pass
// that draws meshes. The fragment shaders can be used or not, depending on the render pass.
g_material_descs : [Num_Material_Types]MaterialDesc = .[
    // Opaque
    .{vertex_shader="mesh_geometry", shading_fragment_shader="unlit"},
    .{vertex_shader="mesh_geometry", shading_fragment_shader="unlit", depth_only_fragment_shader="alpha_cutoff_depth_only", entity_guid_fragment_shader="alpha_cutoff_entity_guid"},
];

// MaterialPipelines stores pipelines for one material depending on variations (e.g. skinned, wireframe, skinned and wireframe)
MaterialPipelineFlags :: enum_flags {
    Skinned;
}

Num_Material_Pipelines :: #run -> int {
    count := type_info(MaterialPipelineFlags).values.count;
    return count * count + 1;
}

MaterialPipelines :: [Num_Material_Pipelines]GfxGraphicsPipeline;

CreateMaterialPipelines :: (pipelines : *MaterialPipelines, name : string, template : GfxGraphicsPipelineDesc, pass_binding_set_layout : *GfxBindingSetLayout, vertex_shader : string, fragment_shader : string) {
    for * pipelines.* {
        if !IsNull(it) {
            continue;
        }

        flags := cast(MaterialPipelineFlags, it_index);

        desc : GfxGraphicsPipelineDesc;

        if flags & .Skinned {
            desc.vertex_shader = GetVertexShader(TPrint("skinned_%", vertex_shader));
        } else {
            desc.vertex_shader = GetVertexShader(vertex_shader);
        }

        if fragment_shader {
            desc.fragment_shader = GetFragmentShader(fragment_shader);
        }

        if flags & .Skinned {
            desc.vertex_input = MakeVertexInputDesc(SkinnedVertex, 0);
        } else {
            desc.vertex_input = MakeVertexInputDesc(StaticVertex, 0);
        }

        desc.rasterizer_state = template.rasterizer_state;
        desc.depth_state = template.depth_state;
        desc.stencil_state = template.stencil_state;
        memcpy(desc.blend_states.data, template.blend_states.data, size_of(type_of(template.blend_states)));

        desc.num_color_attachments = template.num_color_attachments;

        memcpy(desc.color_formats.data, template.color_formats.data, size_of(type_of(template.color_formats)));
        desc.depth_format = template.depth_format;
        desc.stencil_format = template.stencil_format;

        desc.layout.binding_sets = .[
            g_binding_set_layouts.FrameBindingSet,
            pass_binding_set_layout,
            g_binding_set_layouts.MeshBindingSet,
        ];

        it.* = CreateGfxGraphicsPipeline(TPrint("% (%)", name, flags), desc);
        Assert(!IsNull(it), "Could not create material pipeline (%, %)", name, flags);
    }
}

DestroyMaterialPipelines :: (pipelines : *MaterialPipelines) {
    for * pipelines.* {
        DestroyGfxGraphicsPipeline(it);
    }

    Free(pipelines);
}

MaterialPipelinesKey :: struct {
    vertex_shader : string;
    fragment_shader : string;
}

CompMaterialPipelinesKey :: (a : MaterialPipelinesKey, b : MaterialPipelinesKey) -> bool {
    return a.vertex_shader == b.vertex_shader && a.fragment_shader == b.fragment_shader;
}

HashMaterialPipelinesKey :: (key : MaterialPipelinesKey) -> u64 {
    #import "Hash";

    h := fnv1a_hash(key.vertex_shader.data, key.vertex_shader.count);
    if key.fragment_shader {
        h = fnv1a_hash(key.fragment_shader.data, key.fragment_shader.count, h);
    }

    return h;
}

// MaterialRenderPass stores pipelines cached for a specific render pass (pipelines can be shared per material,
// as in certain render passes materials use the same vertex and fragment shader, or none).
// It defines certain pipeline parameters, the binding set to be used for the whole pass, and the fragment shader
MaterialRenderPass :: struct {
    initialized : bool;

    name : string;

    // The shader name or one of the following special values:
    //  * FORWARD_SHADING will use MaterialDesc.shading_fragment_shader
    //  * DEPTH_ONLY will use MaterialDesc.depth_only_fragment_shader
    //  * ENTITY_GUID will use MaterialDesc.entity_guid_fragment_shader
    fragment_shader : string;

    pipeline_template : GfxGraphicsPipelineDesc;

    // Binding set bound for the whole pass at slot 1. 0 is always FrameBindingSet and 2 is always MeshBindingSet
    binding_set_layout : *GfxBindingSetLayout;
    pipeline_layout : GfxPipelineLayout;

    pipelines : HashMap(
        MaterialPipelinesKey, *MaterialPipelines,
        hash_func=HashMaterialPipelinesKey, comp_func=CompMaterialPipelinesKey
    );
}

InitMaterialRenderPass :: (pass : *MaterialRenderPass, binding_set_layout : *GfxBindingSetLayout) {
    Assert(!pass.initialized, "Material pass is already initialized");

    pass.binding_set_layout = binding_set_layout;

    layout_desc : GfxPipelineLayoutDesc;
    layout_desc.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        binding_set_layout,
        g_binding_set_layouts.MeshBindingSet,
    ];

    pass.pipeline_layout = CreateGfxPipelineLayout(pass.name, layout_desc);
    Assert(!IsNull(*pass.pipeline_layout), "Could not create material pass '%' pipeline layout", pass.name);

    pass.initialized = true;
}

DestroyMaterialRenderPass :: (pass : *MaterialRenderPass) {
    DestroyGfxPipelineLayout(*pass.pipeline_layout);
    pass.pipeline_layout = .{};

    for pass.pipelines {
        DestroyMaterialPipelines(it);
    }

    HashMapFree(*pass.pipelines);

    pass.initialized = false;
}

GetPipeline :: (pass : *MaterialRenderPass, type : MaterialType, flags : MaterialPipelineFlags) -> *GfxGraphicsPipeline {
    vertex_shader := g_material_descs[type].vertex_shader;
    fragment_shader : string;

    if pass.fragment_shader == {
    case "FORWARD_SHADING";
        fragment_shader = g_material_descs[type].shading_fragment_shader;
    case "DEPTH_ONLY";
        fragment_shader = g_material_descs[type].depth_only_fragment_shader;
    case "ENTITY_GUID";
        fragment_shader = g_material_descs[type].entity_guid_fragment_shader;
    case;
        fragment_shader = pass.fragment_shader;
    }

    pipelines := HashMapGet(*pass.pipelines, .{vertex_shader, fragment_shader});
    if !pipelines {
        pipelines = Alloc(MaterialPipelines);
        HashMapInsert(*pass.pipelines, .{vertex_shader, fragment_shader}, pipelines);
    }

    if IsNull(*pipelines.*[flags]) {
        CreateMaterialPipelines(pipelines, pass.name, pass.pipeline_template, pass.binding_set_layout, vertex_shader, fragment_shader);
    }

    return *pipelines.*[flags];
}
