MeshInstance :: struct {
    entity_id : Vec4u;
    transform : Mat4f;
    material : MaterialPerInstance;
    skinning_matrices_offset : u32;
} @ShaderType

MeshBuffer :: struct {
    Entry :: struct {
        key : u64;
        entity_id : UUID;
        vertex_buffer : *GfxBuffer;
        index_buffer : *GfxBuffer;
        vertex_count : u32;
        index_count : u32;
        transform : Mat4f;
        material : *Material;
        is_skinned : bool;
        skinning_matrices : []Mat4f;
    }

    DrawCall :: struct {
        vertex_buffer : *GfxBuffer;
        index_buffer : *GfxBuffer;
        vertex_count : u32;
        index_count : u32;
        material : MaterialPerDrawCall;
        instances_offset : u64;
        instance_count : u32;
        is_skinned : bool;

        binding_set : GfxBindingSet;
    }

    total_num_skinning_matrices : u64;
    skinning_matrices_offset : u64;
    meshes : [..]Entry;
    draw_calls : [..]DrawCall;
}

GetPipeline :: (pass : *MaterialRenderPass, draw_call : MeshBuffer.DrawCall, flags : MaterialPipelineFlags = 0) -> *GfxGraphicsPipeline {
    if draw_call.is_skinned {
        flags |= .Skinned;
    }

    return GetPipeline(pass, draw_call.material.type, flags);
}

MeshBindingSet :: struct {
    mesh_instances : GfxBindingStorageBuffer; @Binding(0) @VertexStage @FragmentStage
    skinning_matrices : GfxBindingStorageBuffer; @Binding(1) @VertexStage @AllowNull
    base_color : GfxBindingCombinedTextureSampler; @Binding(2) @FragmentStage
    normal_map : GfxBindingCombinedTextureSampler; @Binding(3) @FragmentStage
    metallic_roughness_map : GfxBindingCombinedTextureSampler; @Binding(4) @FragmentStage @AllowNull
    emissive : GfxBindingCombinedTextureSampler; @Binding(5) @FragmentStage
    depth_map : GfxBindingCombinedTextureSampler; @Binding(6) @FragmentStage @AllowNull
} @BindingSet

ClearMeshBuffer :: (buffer : *MeshBuffer) {
    buffer.total_num_skinning_matrices = 0;
    buffer.skinning_matrices_offset = 0;
    ArrayClear(*buffer.meshes);
    ArrayClear(*buffer.draw_calls);
}

FreeMeshBuffer :: (buffer : *MeshBuffer) {
    buffer.total_num_skinning_matrices = 0;
    buffer.skinning_matrices_offset = 0;
    ArrayFree(*buffer.meshes);
    ArrayFree(*buffer.draw_calls);
}

MakeMeshBufferKey :: (mesh : MeshToRender, depth : float) -> u64 {
    return MakeMeshBufferKey(mesh.vertex_buffer, mesh.index_buffer, mesh.material, mesh.is_skinned, depth);
} @NoProfile

MakeMeshBufferKey :: (vertex_buffer : *GfxBuffer, index_buffer : *GfxBuffer, material : *Material, is_skinned : bool, depth : float) -> u64 {
    mesh_buffers : [2]*GfxBuffer = .[vertex_buffer, index_buffer];

    textures : [5]*Asset(Texture2D) = .[
        material.base_color,
        material.normal_map,
        material.metallic_roughness_map,
        material.emissive,
        material.depth_map,
    ];

    mesh_buffers_hash := sdbm_hash(*mesh_buffers, size_of(type_of(mesh_buffers)));
    textures_hash := sdbm_hash(*textures, size_of(type_of(textures)));

    Depth_Offset :: 0;
    Depth_Bits :: 24;

    Mesh_Offset :: Depth_Offset + Depth_Bits;
    Mesh_Bits :: 16;

    Textures_Offset :: Mesh_Offset + Mesh_Bits;
    Textures_Bits :: 16;

    Material_Type_Offset :: Textures_Offset + Textures_Bits;
    Material_Type_Bits :: 7;

    #assert Num_Material_Types < 0b1111111;

    Is_Skinned_Offset :: Material_Type_Offset + Material_Type_Bits;
    Is_Skinned_Bits :: 1;

    End :: Is_Skinned_Offset + Is_Skinned_Bits;
    #assert End <= 64;
    result : u64;
    result |= (cast,no_check(u64, depth) & 0xffffff) << Depth_Offset; // 24 bits for depth
    result |= cast(u64, mesh_buffers_hash & 0xffff) << Mesh_Offset; // 16 bits for mesh
    result |= cast(u64, textures_hash & 0xffff) << Textures_Offset; // 16 bits for textures
    result |= cast(u64, material.type & 0b1111111) << Material_Type_Offset; // 7 bits for material type
    result |= cast(u64, is_skinned) << Is_Skinned_Offset; // 1 bit for skinning

    return result;
} @NoProfile

PushMesh :: (
    buffer : *MeshBuffer,
    key : u64,
    mesh : MeshToRender
) {
    PushMesh(
        buffer,
        key,
        mesh.entity_id,
        mesh.vertex_buffer, mesh.index_buffer,
        mesh.vertex_count, mesh.index_count,
        mesh.transform,
        mesh.material,
        mesh.is_skinned,
        mesh.skinning_matrices
    );
} @NoProfile

g_billboard_vertex_buffer : GfxBuffer;

InitBillboardVertexBuffer :: () {
    if !IsNull(*g_billboard_vertex_buffer) {
        return;
    }

    Vertices :: StaticVertex.[
        .{
            position=.{-0.5,-0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{0,0},
        },
        .{
            position=.{-0.5,0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{0,1},
        },
        .{
            position=.{0.5,0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{1,1},
        },
        .{
            position=.{-0.5,-0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{0,0},
        },
        .{
            position=.{0.5,0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{1,1},
        },
        .{
            position=.{0.5,-0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{1,0},
        },
    ];

    desc : GfxBufferDesc;
    desc.size = size_of(type_of(Vertices));
    desc.usage = .VertexBuffer;
    desc.memory_usage = .Upload;

    g_billboard_vertex_buffer = CreateGfxBuffer("Billboard Vertices", desc);
    Assert(!IsNull(*g_billboard_vertex_buffer), "Could not create vertex buffer for billboard mesh");

    vmaCopyMemoryToAllocation(g_gfx_context.allocator, Vertices.data, g_billboard_vertex_buffer.allocation, 0, desc.size);
}

PushBillboard :: (
    buffer : *MeshBuffer,
    key : u64,
    entity_id : UUID,
    material : *Material,
    position : Vec3f,
    camera_transform : Mat4f,
    scale : Vec2f
) {
    InitBillboardVertexBuffer();

    if !material || !material.base_color {
        return;
    }

    width := material.base_color.width;
    height := material.base_color.height;
    aspect_ratio := height / cast(float, width);

    model_matrix := Mat4fLookAt(position, position - ForwardVector(camera_transform), UpVector(camera_transform));
    model_matrix *= Mat4fScale(.{scale.x, scale.y * aspect_ratio, 1});

    PushMesh(
        buffer,
        key,
        entity_id=entity_id,
        vertex_buffer=*g_billboard_vertex_buffer, index_buffer=null,
        vertex_count=6, index_count=0,
        transform=model_matrix,
        material=material,
        is_skinned=false, skinning_matrices=.[]
    );
} @NoProfile

PushMesh :: (
    buffer : *MeshBuffer,
    key : u64,
    entity_id : UUID,
    vertex_buffer : *GfxBuffer,
    index_buffer : *GfxBuffer,
    vertex_count : u32,
    index_count : u32,
    transform : Mat4f,
    material : *Material,
    is_skinned : bool,
    skinning_matrices : []Mat4f
) {
    Assert(vertex_buffer != null, "Vertex buffer is null");
    Assert(material != null, "Material is null");

    entry := ArrayPush(*buffer.meshes);
    entry.key = key;
    entry.entity_id = entity_id;
    entry.vertex_buffer = vertex_buffer;
    entry.index_buffer = index_buffer;
    entry.vertex_count = vertex_count;
    entry.index_count = index_count;
    entry.transform = transform;
    entry.material = material;
    entry.is_skinned = is_skinned;
    entry.skinning_matrices = skinning_matrices;

    buffer.total_num_skinning_matrices += xx skinning_matrices.count;
} @NoProfile

SortMeshBuffer :: (buffer : *MeshBuffer) {
    QuickSort(buffer.meshes, (a, b) => ifx a.key < b.key then -1 else ifx a.key > b.key then 1 else 0);
}

CanInstantiateMeshes :: inline (a : MeshBuffer.Entry, b : MeshBuffer.Entry) -> bool {
    return a.vertex_buffer == b.vertex_buffer
        && a.index_buffer  == b.index_buffer
        && a.vertex_count  == b.vertex_count
        && a.index_count   == b.index_count
        && (a.material == b.material || MakeMaterialPerDrawCall(a.material) == MakeMaterialPerDrawCall(b.material));
} @NoProfile

AllocDrawData :: (buffer : *MeshBuffer) {
    skinning_matrices : *Mat4f;
    current_skinning_matrices_offset : u32;

    if buffer.total_num_skinning_matrices > 0 {
        buffer.skinning_matrices_offset, skinning_matrices = AllocFrameData(xx (size_of(Mat4f) * buffer.total_num_skinning_matrices));
    }

    i := 0;
    while i < buffer.meshes.count {
        instance_count : u32 = 1;
        while i + instance_count < buffer.meshes.count #no_abc {
            if !CanInstantiateMeshes(buffer.meshes[i], buffer.meshes[i + instance_count]) {
                break;
            }

            instance_count += 1;
        }

        mesh := buffer.meshes[i];
        draw := ArrayPush(*buffer.draw_calls);
        draw.vertex_buffer = mesh.vertex_buffer;
        draw.index_buffer = mesh.index_buffer;
        draw.vertex_count = mesh.vertex_count;
        draw.index_count = mesh.index_count;
        draw.instance_count = instance_count;
        draw.is_skinned = mesh.is_skinned;

        draw.material = MakeMaterialPerDrawCall(mesh.material);

        packed_instances : *void;
        draw.instances_offset, packed_instances
            = AllocFrameData(GLSLStd430Size(MeshInstance) * instance_count);

        for j : 0..instance_count - 1 #no_abc {
            mesh := buffer.meshes[i + j];

            instance : MeshInstance = ---;
            instance.entity_id = cast(*Vec4u, *mesh.entity_id).*;
            instance.transform = mesh.transform;
            instance.material = MakeMaterialPerInstance(mesh.material);
            instance.skinning_matrices_offset = current_skinning_matrices_offset;

            PackToGLSLStd(instance, packed_instances, .Std430);
            packed_instances += GLSLStd430Size(MeshInstance);

            for mesh.skinning_matrices {
                (skinning_matrices + current_skinning_matrices_offset)[it_index] = Transposed(it);
            }

            current_skinning_matrices_offset += xx mesh.skinning_matrices.count;
        }

        bindings : MeshBindingSet;
        bindings.mesh_instances = .{buffer=FrameDataBuffer(), offset=xx draw.instances_offset, size=xx (GLSLStd430Size(MeshInstance) * instance_count)};
        bindings.skinning_matrices = .{buffer=FrameDataBuffer(), offset=xx buffer.skinning_matrices_offset, size=xx (size_of(Mat4f) * buffer.total_num_skinning_matrices)};
        bindings.base_color = .{
            texture=ifx mesh.material.base_color && !IsNull(*mesh.material.base_color.texture)
                then *mesh.material.base_color.texture
                else *g_default_base_color.texture,
            sampler=*g_material_texture_sampler
        };
        bindings.normal_map = .{
            texture=ifx mesh.material.normal_map && !IsNull(*mesh.material.normal_map.texture)
                then *mesh.material.normal_map.texture
                else *g_default_normal_map.texture,
            sampler=*g_material_texture_sampler
        };
        bindings.metallic_roughness_map = .{
            texture=ifx mesh.material.metallic_roughness_map then *mesh.material.metallic_roughness_map.texture,
            sampler=*g_material_texture_sampler
        };
        bindings.emissive = .{
            texture=ifx mesh.material.emissive && !IsNull(*mesh.material.emissive.texture)
                then *mesh.material.emissive.texture
                else *g_default_emissive.texture,
            sampler=*g_material_texture_sampler
        };
        bindings.depth_map = .{
            texture=ifx mesh.material.depth_map then *mesh.material.depth_map.texture,
            sampler=*g_material_texture_sampler
        };

        draw.binding_set = CreateGfxBindingSet(MeshBindingSetAllocator(), bindings);

        i += instance_count;
    }
}
