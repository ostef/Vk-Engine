DestroyCollisionMesh :: (mesh : *CollisionMesh) {
    Free(mesh.triangles.data);

    for mesh.octree {
        Free(it.elements.data);
    }

    Free(mesh.octree.data);

    mesh.* = .{};
}

BuildCollisionMesh :: (mesh : *StaticMesh) {
    Assert(mesh.collision_mesh.triangles.count == 0, "CollisionMesh has already been built");

    mesh.collision_mesh.triangles = AllocArray(CollisionMeshTriangle, mesh.indices.count / 3);

    min := Vec3f.{ F32_Inf,  F32_Inf,  F32_Inf};
    max := Vec3f.{-F32_Inf, -F32_Inf, -F32_Inf};
    for * mesh.collision_mesh.triangles #no_abc {
        i0 := mesh.indices[it_index * 3 + 0];
        i1 := mesh.indices[it_index * 3 + 1];
        i2 := mesh.indices[it_index * 3 + 2];

        it.p0 = mesh.vertices[i0].position;
        it.p1 = mesh.vertices[i1].position;
        it.p2 = mesh.vertices[i2].position;
        it.normal = Normalized(Cross(it.p1 - it.p0, it.p2 - it.p0), epsilon=0);

        min = Min(min, Min(Min(it.p0, it.p1), it.p2));
        max = Max(max, Max(Max(it.p0, it.p1), it.p2));
    }

    mesh.static_bounds.center = (max + min) * 0.5;
    mesh.static_bounds.half_extents = (max - min) * 0.5;

    mesh.collision_mesh.bounds = mesh.static_bounds;

    if mesh.collision_mesh.octree.count <= 0 {
        BuildMeshOctree(*mesh.collision_mesh);
    }
}

Mesh_Octree_Max_Triangles :: 10; // If an octree contains more than this many triangles, we divide it
Mesh_Octree_Max_Depth :: 5;
Mesh_Octree_Max_Nodes :: S32_Max;

// Index is encoded as follows:
// bit 0: Z-axis
// bit 1: Y-axis
// bit 2: X-axis
// If a bit is 0, the axis is negative, otherwise it is positive
Octree_Child_Center_Vectors :: Vec3f.[
    .{-1,-1,-1},
    .{-1,-1, 1},
    .{-1, 1,-1},
    .{-1, 1, 1},
    .{ 1,-1,-1},
    .{ 1,-1, 1},
    .{ 1, 1,-1},
    .{ 1, 1, 1},
];

GetOctreeNodeCenter :: (parent_center : Vec3f, child_half_size : float, child_index : int) -> Vec3f {
    return parent_center + Octree_Child_Center_Vectors[child_index] * child_half_size;
}

BuildMeshOctree :: (mesh : *CollisionMesh) #no_abc {
    DivideIfMatchesCriteria :: (
        mesh : *CollisionMesh,
        octree_index : int,
        octree_center : Vec3f,
        octree_half_size : float,
        current_depth : u32 = 1
    ) -> divided : bool {
        if current_depth >= Mesh_Octree_Max_Depth {
            return false;
        }

        node := *mesh.octree[octree_index];
        if node.elements.count <= Mesh_Octree_Max_Triangles {
            return false;
        }

        if mesh.octree.count + 8 > Mesh_Octree_Max_Nodes {
            return false;
        }

        mesh.max_octree_depth = Max(mesh.max_octree_depth, current_depth + 1);
        node.first_child_index = xx mesh.octree.count;

        child_half_size := octree_half_size / 2;
        child_half_extents := Vec3f.{child_half_size,child_half_size,child_half_size};

        ArrayReserve(*mesh.octree, mesh.octree.count + 8);

        for i : 0..7 {
            child := ArrayPush(*mesh.octree);
            node = *mesh.octree[octree_index];

            child_elements : [..]u32;

            // Heuristically reserve 1/8th of the elements in the parent octree, because we divide by 8
            ArrayReserve(*child_elements, node.elements.count / 8);

            child_center := GetOctreeNodeCenter(octree_center, child_half_size, i);

            for node.elements {
                tri := mesh.triangles[it];

                if TriangleIntersectsBox(tri.p0, tri.p1, tri.p2, tri.normal, child_center, child_half_extents) {
                    // If we let ArrayPush reserve memory itself it will
                    // double the amount of memory, which is overkill
                    if child_elements.count == child_elements.allocated {
                        ArrayReserve(*child_elements, child_elements.allocated + 50);
                    }

                    ArrayPush(*child_elements, it);
                }
            }

            child.elements.data = child_elements.data;
            child.elements.count = xx child_elements.count;
        }

        Free(node.elements.data);
        node.elements = .{};

        for i : 0..7 {
            child_center := GetOctreeNodeCenter(octree_center, child_half_size, i);
            child_index := node.first_child_index + i;

            if !DivideIfMatchesCriteria(mesh, child_index, child_center, child_half_size, current_depth + 1) {
                child := mesh.octree[child_index];
                mesh.max_octree_num_triangles = Max(mesh.max_octree_num_triangles, cast(u32, child.elements.count));
                mesh.octree_size += child.elements.count * size_of(u32);
            }

            node = *mesh.octree[octree_index];
        }

        return true;
    }

    Assert(mesh.octree.count == 0, "Mesh octree has already been built");

    mesh.max_octree_depth = 1;

    // Create initial octree node
    root := ArrayPush(*mesh.octree);
    root.elements.data = Alloc(u32, mesh.triangles.count);
    root.elements.count = xx mesh.triangles.count;

    for i : 0..mesh.triangles.count - 1 {
        root.elements[i] = xx i;
    }

    octree_half_size := Max(Max(mesh.bounds.half_extents.x, mesh.bounds.half_extents.y), mesh.bounds.half_extents.z);

    DivideIfMatchesCriteria(mesh, 0, mesh.bounds.center, octree_half_size);
    if mesh.octree.count == 1 {
        mesh.max_octree_num_triangles = xx mesh.octree[0].elements.count;
    }

    mesh.octree_size += mesh.octree.count * size_of(OctreeNode);
}

DebugDrawMeshOctree :: (color : Vec4f, mesh : *CollisionMesh, thickness : float, transform : Mat4f) {
    Recurse :: (color : Vec4f, thickness : float, octree : []OctreeNode, node_index : int, octree_center : Vec3f, octree_half_size : float, transform : Mat4f) {
        node := octree[node_index];
        DebugDrawBoxOutline(color, octree_center, .{octree_half_size,octree_half_size,octree_half_size}, transform);

        if node.elements.count > 0 {
            // Gizmo.DrawText(TPrint("% tris", node.elements.count), TransformPoint(transform, octree_center), .{1,1,1,1}, .{0.1,0.1,0.1,1});
        } else if node.first_child_index > 0 {
            child_half_size := octree_half_size / 2;

            for i : 0..7 {
                child_center := octree_center + Octree_Child_Center_Vectors[i] * child_half_size;

                Recurse(color, thickness, octree, node.first_child_index + i, child_center, child_half_size, transform);
            }
        }
    }

    if mesh.octree.count <= 0 {
        return;
    }

    octree_half_size := Max(Max(mesh.bounds.half_extents.x, mesh.bounds.half_extents.y), mesh.bounds.half_extents.z);

    Recurse(color, thickness, mesh.octree, 0, mesh.bounds.center, octree_half_size, transform);
}
