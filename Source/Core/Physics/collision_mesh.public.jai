CompressedArray :: struct(T : Type, Count_Type : Type) {
    count : Count_Type;
    data : *T;
}

DecompressArray :: (arr : CompressedArray) -> []arr.T {
    return .{arr.count, arr.data};
}

for_expansion :: (arr : *CompressedArray, body : Code, flags : For_Flags) #expand {
    uncompressed : []arr.T = .{arr.count, arr.data};
    for *=(flags & .POINTER != 0) <=(flags & .REVERSE != 0) `it, `it_index : uncompressed {
        #insert body;
    }
}

operator *[] :: inline (arr : CompressedArray, index : s64) -> *arr.T {
    return *(([]arr.T).{count=arr.count,data=arr.data}[index]); // Prevent array bounds check if disabled using #no_abc
}

OctreeNode :: struct {
    first_child_index : s32 = -1; // All children are allocated contiguously
    elements : CompressedArray(u32, s32);
}

CollisionMeshTriangle :: struct {
    p0, p1, p2, normal : Vec3f;
}

// Mesh optimized for collision detection
CollisionMesh :: struct {
    triangles : []CollisionMeshTriangle; // Maps to the original StaticMesh's vertices and indices
    bounds : AABB;
    octree : [..]OctreeNode;
    max_octree_depth : u32;
    max_octree_num_triangles : u32;
    octree_size : int;
}
