// @Todo: set buffers to use host memory and upload using intermediate buffer

MeshFileFlags :: enum_flags u32 {
    HasTangents;
    HasOctree;
}

DestroyMesh :: (using mesh : *Mesh) {
    Free(vertices.data);
    Free(indices.data);
    QueueDestroyGfxBuffer(*vertex_buffer);
    QueueDestroyGfxBuffer(*index_buffer);
    mesh.* = .{};
}

LoadStaticMeshFromMemory :: (mesh : *StaticMesh, data : []u8, name : string) -> bool {
    #import "Binary_Reader";

    reader := MakeBinaryReader(data);

    if EqualsString(*reader, "SKINNED_MESH") {
        LogError("Trying to load skinned mesh as static mesh");
        return false;
    }

    str, ok := ReadString(*reader, "STATIC_MESH".count);
    if !ok || str != "STATIC_MESH" {
        LogError("Not a static mesh file");
        return false;
    }

    version:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read file version");
        return false;
    }

    if version != 10000 {
        LogError("Unknown version %", version);
        return false;
    }

    flags:, ok = ReadValue(*reader, MeshFileFlags);
    if !ok {
        LogError("Could not read flags");
        return false;
    }

    vertex_count:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read vertex count");
        return false;
    }

    triangle_count:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read triangle count");
        return false;
    }

    index_count := triangle_count * 3;

    mesh.vertices = AllocArray(StaticVertex, vertex_count);
    mesh.vertex_count = xx vertex_count;

    mesh.indices = AllocArray(u32, index_count);
    mesh.index_count = xx index_count;

    ok = ReadArray(*reader, mesh.vertices);
    if !ok {
        LogError("Could not read vertices");
        return false;
    }

    ok = ReadArray(*reader, mesh.indices);
    if !ok {
        LogError("Could not read indices");
        return false;
    }

    if flags & .HasOctree {
        octree_node_count:, ok = ReadValue(*reader, u32);
        if !ok || octree_node_count == 0 {
            LogError("Could not read octree node count");
            return false;
        }

        ArrayReserve(*mesh.collision_mesh.octree, octree_node_count);

        for i : 0..octree_node_count - 1 {
            child_index:, ok = ReadValue(*reader, s32);
            if !ok {
                LogError("Could not read octree node % child index", child_index);
                return false;
            }

            if child_index < -1 || child_index >= xx octree_node_count {
                LogError("Invalid octree child index %", child_index);
                return false;
            }

            ArrayPush(*mesh.collision_mesh.octree, .{first_child_index=child_index});
        }

        for * mesh.collision_mesh.octree {
            if it.first_child_index >= 0 {
                continue;
            }

            it.elements.count, ok = ReadValue(*reader, s32);
            if !ok {
                LogError("Could not read octree node % element count", it_index);
                return false;
            }

            it.elements.data = Alloc(u32, it.elements.count);

            ok = ReadArray(*reader, DecompressArray(it.elements));
            if !ok {
                LogError("Could not read octree node % elements", it_index);
                return false;
            }
        }
    }

    BuildCollisionMesh(mesh);

    if !(flags & .HasTangents) {
        CalculateTangents(mesh);
    }

    if vertex_count > 0 {
        desc : GfxBufferDesc;
        desc.size = vertex_count * size_of(StaticVertex);
        desc.usage = .VertexBuffer;
        desc.memory_usage = .Upload;

        mesh.vertex_buffer = CreateGfxBuffer(TPrint("% vertices", name), desc);
        if IsNull(*mesh.vertex_buffer) {
            LogError("Could not create vertex buffer for mesh '%'", name);
            return false;
        }

        vmaCopyMemoryToAllocation(g_gfx_context.allocator, mesh.vertices.data, mesh.vertex_buffer.allocation, 0, desc.size);
    }

    if index_count > 0 {
        desc : GfxBufferDesc;
        desc.size = index_count * size_of(u32);
        desc.usage = .IndexBuffer;
        desc.memory_usage = .Upload;

        mesh.index_buffer = CreateGfxBuffer(TPrint("% indices", name), desc);
        if IsNull(*mesh.index_buffer) {
            LogError("Could not create index buffer for mesh '%'", name);
            return false;
        }

        vmaCopyMemoryToAllocation(g_gfx_context.allocator, mesh.indices.data, mesh.index_buffer.allocation, 0, desc.size);
    }

    return true;
}

DestroyStaticMesh :: (mesh : *StaticMesh) {
    DestroyCollisionMesh(mesh);
    DestroyMesh(mesh);
}

CalculateStaticBounds :: (using mesh : *Mesh) {
    min := Vec3f.{ F32_Inf,  F32_Inf,  F32_Inf};
    max := Vec3f.{-F32_Inf, -F32_Inf, -F32_Inf};
    for vertices {
        min = Min(min, it.position);
        max = Max(max, it.position);
    }

    static_bounds.center = (max + min) * 0.5;
    static_bounds.half_extents = (max - min) * 0.5;
}

CalculateTangents :: (using mesh : *Mesh) {
    if !vertices || !indices {
        return;
    }

    AllocatorScope(Temp);
    TemporaryStorageScope();

    Assert(indices.count % 3 == 0, "Mesh is not constituted of triangles");

    // From Foundations of Game Engine Development, Volume 2: Rendering by Eric Lengyel
    // Chapter 7.5
    temp_tangents := AllocArray(Vec3f, vertex_count, initialize = true);
    temp_bitangents := AllocArray(Vec3f, vertex_count, initialize = true);

    for tri : 0..indices.count / 3 - 1 {
        i0 := indices[tri * 3 + 0];
        i1 := indices[tri * 3 + 1];
        i2 := indices[tri * 3 + 2];

        p0 := vertices[i0].position;
        p1 := vertices[i1].position;
        p2 := vertices[i2].position;
        t0 := vertices[i0].tex_coords;
        t1 := vertices[i1].tex_coords;
        t2 := vertices[i2].tex_coords;

        e1 := p1 - p0;
        e2 := p2 - p0;
        x1 := t1.x - t0.x;
        x2 := t2.x - t0.x;
        y1 := t1.y - t0.y;
        y2 := t2.y - t0.y;

        inv_r := x1 * y2 - x2 * y1;
        // @Todo:
        if inv_r == 0 {
            continue;
        }

        r := 1.0 / inv_r;
        t := (e1 * y2 - e2 * y1) * r;
        b := (e2 * x1 - e1 * x2) * r;

        temp_tangents[i0] += t;
        temp_tangents[i1] += t;
        temp_tangents[i2] += t;
        temp_bitangents[i0] += b;
        temp_bitangents[i1] += b;
        temp_bitangents[i2] += b;
    }

    for * vert, i : vertices {
        t := temp_tangents[i];
        b := temp_bitangents[i];
        n := vert.normal;

        vert.tangent.xyz = Normalized(Reject(t, n));
        vert.tangent.w = ifx Dot(Cross(t, b), n) > 0 then 1.0 else -1.0;
    }
}

DestroyArmature :: (using armature : *Armature) {
    Free(joints.data);
    Free(joint_names.data);
    HashMapFree(*name_to_joint_id);
    Initialize(armature);
}

GetJointName :: inline (armature : *Armature, joint_id : s16) -> string {
    return MakeString(armature.joint_names[joint_id].data);
}

LoadSkinnedMeshFromMemory :: (mesh : *SkinnedMesh, data : []u8, name : string) -> bool {
    #import "Binary_Reader";

    reader := MakeBinaryReader(data);

    if EqualsString(*reader, "STATIC_MESH") {
        LogError("Trying to load static mesh as skinned mesh");
        return false;
    }

    str, ok := ReadString(*reader, "SKINNED_MESH".count);
    if !ok || str != "SKINNED_MESH" {
        LogError("Not a skinned mesh file");
        return false;
    }

    version:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read file version");
        return false;
    }

    if version != MakeVersionNumber(1, 0, 0) {
        LogError("Unknown version %", version);
        return false;
    }

    flags:, ok = ReadValue(*reader, MeshFileFlags);
    if !ok {
        LogError("Could not read flags");
        return false;
    }

    vertex_count:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read vertex count");
        return false;
    }

    triangle_count:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read triangle count");
        return false;
    }

    index_count := triangle_count * 3;

    mesh.vertices = AllocArray(SkinnedVertex, vertex_count);
    mesh.vertex_count = xx vertex_count;

    mesh.indices = AllocArray(u32, index_count);
    mesh.index_count = xx index_count;

    ok = ReadArray(*reader, mesh.vertices);
    if !ok {
        LogError("Could not read vertices");
        return false;
    }

    ok = ReadArray(*reader, mesh.indices);
    if !ok {
        LogError("Could not read indices");
        return false;
    }

    joint_count:, ok = ReadValue(*reader, s16);
    if !ok {
        LogError("Could not read joint count");
        return false;
    }

    if joint_count < 0 {
        LogError("Invalid negative joint count");
        return false;
    }

    if joint_count > Max_Joints {
        LogError("Too many joints in mesh (%)", joint_count);
        return false;
    }

    mesh.joint_count = joint_count;
    mesh.joints = AllocArray(ArmatureJoint, joint_count, initialize=false);
    mesh.joint_names = AllocArray([Max_Armature_Joint_Name_Length]u8, joint_count, initialize=false);

    for i : 0..joint_count - 1 {
        name:, ok = ReadNullTerminatedString(*reader);
        if !ok {
            LogError("Could not read joint % name", i);
            return false;
        }

        if name.count == 0 || name.count >= Max_Armature_Joint_Name_Length {
            LogError("Invalid joint name %", name);
            return false;
        }

        memcpy(mesh.joint_names[i].data, name.data, name.count + 1);
        name.data = mesh.joint_names[i].data;

        _, was_present := HashMapInsert(*mesh.name_to_joint_id, name, i);
        if was_present {
            LogError("Duplicate joint %", name);
            return false;
        }

        joint := *mesh.joints[i];
        joint.id = i;

        joint.local_bind_position, ok = ReadValue(*reader, Vec3f);
        if !ok {
            LogError("Could not read joint % local bind position", name);
            return false;
        }

        joint.local_bind_orientation, ok = ReadValue(*reader, Quatf);
        if !ok {
            LogError("Could not read joint % local bind orientation", name);
            return false;
        }

        joint.local_bind_scale, ok = ReadValue(*reader, Vec3f);
        if !ok {
            LogError("Could not read joint % local bind scale", name);
            return false;
        }

        parent_id:, ok = ReadValue(*reader, s16);
        if !ok {
            LogError("Could not read joint % parent id", name);
            return false;
        }

        local_bind_transform := Mat4fTransformSRT(joint.local_bind_position, joint.local_bind_orientation, joint.local_bind_scale);

        if parent_id >= 0 {
            if parent_id > joint.id {
                LogError("Parent id (%) for joint % is larger than the joint id (%)",
                    name, parent_id, joint.id);
                return false;
            }

            if parent_id == joint.id {
                LogError("Joint % is parented to itself", name);
                return false;
            }

            if parent_id >= mesh.joints.count {
                LogError("Invalid parent id for joint %", name);
                return false;
            }

            joint.parent = *mesh.joints[parent_id];
            joint.inverse_bind_transform = joint.parent.inverse_bind_transform
                * local_bind_transform;
        } else {
            joint.parent = null;
            joint.inverse_bind_transform = local_bind_transform;
        }
    }

    if !IsAtEnd(reader) {
        LogError("Trailing data (% bytes) in static mesh '%' file", reader.size - reader.offset, name);
    }

    for * mesh.joints {
        it.inverse_bind_transform = Inverse(it.inverse_bind_transform);
    }

    if !(flags & .HasTangents) {
        CalculateTangents(mesh);
    }

    if vertex_count > 0 {
        desc : GfxBufferDesc;
        desc.size = vertex_count * size_of(SkinnedVertex);
        desc.usage = .VertexBuffer;
        desc.memory_usage = .Upload;

        mesh.vertex_buffer = CreateGfxBuffer(TPrint("% vertices", name), desc);
        if IsNull(*mesh.vertex_buffer) {
            LogError("Could not create vertex buffer for mesh '%'", name);
            return false;
        }

        vmaCopyMemoryToAllocation(g_gfx_context.allocator, mesh.vertices.data, mesh.vertex_buffer.allocation, 0, desc.size);
    }

    if index_count > 0 {
        desc : GfxBufferDesc;
        desc.size = index_count * size_of(u32);
        desc.usage = .IndexBuffer;
        desc.memory_usage = .Upload;

        mesh.index_buffer = CreateGfxBuffer(TPrint("% indices", name), desc);
        if IsNull(*mesh.index_buffer) {
            LogError("Could not create index buffer for mesh '%'", name);
            return false;
        }

        vmaCopyMemoryToAllocation(g_gfx_context.allocator, mesh.indices.data, mesh.index_buffer.allocation, 0, desc.size);
    }

    return true;
}

LoadSkinnedMeshFromFile :: (mesh : *SkinnedMesh, filename : string) -> bool {
    data, ok := read_entire_file(filename);
    if !ok {
        return false;
    }

    ok = LoadSkinnedMeshFromMemory(mesh, xx data, filename);
    Free(data.data);

    return ok;
}

DestroySkinnedMesh :: (mesh : *SkinnedMesh) {
    DestroyMesh(mesh);
    DestroyArmature(mesh);
}
