JointSample :: struct {
    local_position : Vec3f;
    local_orientation : Quatf;
    local_scale : Vec3f;
}

ArmatureAnimation :: struct {
    joint_count : s64;
    pose_count : s64;
    memory_block : *void;
    name_to_joint_id : HashMap(string, s16);
    joint_samples : []JointSample;
} @Asset

JointPose :: struct {
    parent : *JointPose;
    #as using sample : JointSample;

    // This is the transform matrix of the Joint in model space.
    // It is used for skinning matrices generation.
    model_space_transform : Mat4f;
}

ArmaturePose :: struct {
    mesh : *Asset(SkinnedMesh);
    using,only(armature) mesh;

    joint_count : s64;
    memory_block : *void;

    #overlay(joint_count)
    joints : []JointPose = ---;
}
