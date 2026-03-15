StaticVertex :: struct {
    position : Vec3f;
    normal : Vec3f;
    tangent : Vec4f;
    tex_coords : Vec2f;
}

StaticMesh :: struct {
    #as using _ : Mesh(StaticVertex);

    #as collision_mesh : CollisionMesh;
} @Asset

Mesh :: struct(VertexType : Type) {
    vertices : []VertexType;
    indices : []u32;

    vertex_count : u32;
    index_count : u32;

    vertex_buffer : GfxBuffer;
    index_buffer : GfxBuffer;

    static_bounds : AABB;
}

SkinnedVertex :: struct {
    position : Vec3f;
    normal : Vec3f;
    tangent : Vec4f;
    tex_coords : Vec2f;
    joint_ids : Vec4s;
    joint_weights : Vec3f;
}

SkinnedMesh :: struct {
    #as using _ : Mesh(SkinnedVertex);
    #as using,except(memory_block) armature : Armature;
} @Asset

Max_Joints :: 1000;
Max_Armature_Joint_Name_Length :: 64;

ArmatureJoint :: struct {
    id : s16;

    local_bind_position : Vec3f;
    local_bind_orientation : Quatf;
    local_bind_scale : Vec3f;

    inverse_bind_transform : Mat4f;
    parent : *ArmatureJoint;
}

Armature :: struct {
    joint_count : s64;
    memory_block : *void;
    // Layout of the memory:
    // [joint_count]ArmatureJoint
    // [joint_count][Max_Armature_Joint_Name_Length]u8
    // [map_capacity]HashMap(string, s16).Entry

    #overlay(joint_count)
    joints : []ArmatureJoint = ---;
    name_to_joint_id : HashMap(string, s16);
}
