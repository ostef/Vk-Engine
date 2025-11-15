CalculateArmatureAnimationMemoryBlockSize :: inline (joint_count : int, pose_count : int) -> int {
    map_capacity := HashMapGetMinCapacityForElementCount(ArmatureAnimation.name_to_joint_id.Load_Factor, joint_count);

    return size_of(JointSample) * joint_count * pose_count
        + joint_count * Max_Armature_Joint_Name_Length
        + map_capacity * size_of(ArmatureAnimation.name_to_joint_id.Entry);
}

AllocArmatureAnimationData :: (anim : *ArmatureAnimation, joint_count : int, pose_count : int) {
    memory_block_size := CalculateArmatureAnimationMemoryBlockSize(joint_count, pose_count);
    anim.memory_block = Alloc(memory_block_size);

    anim.joint_count = joint_count;
    anim.pose_count = pose_count;

    anim.joint_samples.data = anim.memory_block;
    anim.joint_samples.count = joint_count * pose_count;

    map_data := anim.memory_block + size_of(JointSample) * joint_count * pose_count;
    map_data += Max_Armature_Joint_Name_Length * joint_count;

    capacity := HashMapGetMinCapacityForElementCount(ArmatureAnimation.name_to_joint_id.Load_Factor, joint_count);
    HashMapInitFromPreallocatedMemory(*anim.name_to_joint_id, map_data, capacity, Trap);
}

GetJointNamesArray :: inline (using anim : *ArmatureAnimation) -> [][Max_Armature_Joint_Name_Length]u8 {
    result : [][Max_Armature_Joint_Name_Length]u8 = ---;
    result.count = joint_count;
    result.data = memory_block + size_of(JointSample) * joint_count * pose_count;

    return result;
} @ModuleAPI

GetJointName :: inline (anim : *ArmatureAnimation, joint_id : s16) -> string {
    Assert(joint_id >= 0 && joint_id < anim.joint_count, "Invalid joint id %", joint_id);

    names_data := cast(*[Max_Armature_Joint_Name_Length]u8) (anim.memory_block + size_of(JointSample) * anim.joint_count * anim.pose_count);

    return MakeString(names_data[joint_id].data);
} @ModuleAPI

GetJointSample :: inline (using anim : *ArmatureAnimation, joint_id : s16, pose_index : int) -> *JointSample {
    Assert(joint_id >= 0 && joint_id < joint_count, "Invalid joint id %", joint_id);
    Assert(pose_index >= 0 && pose_index < pose_count, "Pose index % out of bounds %", pose_index, pose_count);

    return *joint_samples[pose_index * joint_count + joint_id];
} @ModuleAPI

LoadArmatureAnimationFromMemory :: (anim : *ArmatureAnimation, data : []u8, name : string) -> bool {
    reader := MakeBinaryReader(data);

    str, ok := ReadString(*reader, "ARMATURE_ANIMATION".count);
    if !ok || str != "ARMATURE_ANIMATION" {
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

    pose_count:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read pose count");
        return false;
    }

    joint_count:, ok = ReadValue(*reader, u32);
    if !ok {
        LogError("Could not read joint count");
        return false;
    }

    AllocArmatureAnimationData(anim, joint_count, pose_count);
    joint_names := GetJointNamesArray(anim);

    for i : 0..joint_count - 1 {
        name:, ok = ReadNullTerminatedString(*reader);
        if !ok {
            LogError("Could not read joint % name", i);
            return false;
        }

        if name.count == 0 || name.count > Max_Armature_Joint_Name_Length {
            LogError("Invalid joint name %", name);
            return false;
        }

        joint_name := joint_names[i].data;
        memcpy(joint_name, name.data, name.count + 1);
        name.data = joint_name;

        _, was_present := HashMapInsert(*anim.name_to_joint_id, name, xx i);
        if was_present {
            LogError("Duplicate joint %", name);
            return false;
        }
    }

    ok = ReadArray(*reader, anim.joint_samples);
    if !ok {
        LogError("Could not read joint samples");
        return false;
    }

    if !IsAtEnd(reader) {
        LogError("Trailing data (% bytes) in static mesh '%' file", reader.size - reader.offset, name);
    }

    return true;
}

LoadArmatureAnimationFromFile :: inline (anim : *ArmatureAnimation, filename : string) -> bool {
    data, ok := read_entire_file(filename);
    if !ok {
        return false;
    }

    ok = LoadArmatureAnimationFromMemory(anim, xx data, filename);
    Free(data.data);

    return ok;
}

DestroyArmatureAnimation :: inline (using anim : *ArmatureAnimation) {
    Free(memory_block);
    Initialize(anim);
}

InitArmaturePose :: (pose : *ArmaturePose, mesh : *Asset(SkinnedMesh)) {
    pose.mesh = mesh;
    AddRef(pose.mesh);

    pose.joints = AllocArray(JointPose, mesh.joints.count, initialize = true);

    for * pose.joints {
        joint_in_armature := *mesh.joints[it_index];
        if joint_in_armature.parent {
            parent_id := joint_in_armature.parent - mesh.joints.data;
            it.parent = *pose.joints[parent_id];
        } else {
            it.parent = null;
        }
    }

    ResetToBindPose(pose);
} @ModuleAPI

FreeArmaturePose :: inline (using pose : *ArmaturePose) {
    RemoveRef(mesh);
    Free(memory_block);

    Initialize(pose);
} @ModuleAPI

ResetToBindPose :: (using pose : *ArmaturePose) {
    for * joints {
        bind_joint := armature.joints[it_index];
        it.local_position = bind_joint.local_bind_position;
        it.local_orientation = bind_joint.local_bind_orientation;
        it.local_scale = bind_joint.local_bind_scale;
    }
} @ModuleAPI

InterpolateJointSamples :: inline (
    a : JointSample,
    b : JointSample,
    t : float
) -> JointSample {
    result : JointSample = ---;
    result.local_position = Lerp(a.local_position, b.local_position, t);
    result.local_orientation = NLerp(a.local_orientation, b.local_orientation, t);
    result.local_scale = Lerp(a.local_scale, b.local_scale, t);

    return result;
} @ModuleAPI

SampleAnimation :: (
    anim : *ArmatureAnimation,
    pose_index : float,
    output_pose : *ArmaturePose
) {
    pose_index = Math.fmod_cycling(pose_index, cast(float, anim.pose_count));

    for * pose_joint : output_pose.joints {
        joint_name := GetJointName(*output_pose.armature, cast(s16, it_index));
        anim_joint_id, exists := HashMapGet(*anim.name_to_joint_id, joint_name);
        if !exists {
            continue;
        }

        first_pose_index  := cast(s64, pose_index);
        second_pose_index := (first_pose_index + 1) % anim.pose_count;
        first  := GetJointSample(anim, anim_joint_id, first_pose_index);
        second := GetJointSample(anim, anim_joint_id, second_pose_index);
        pose_joint.sample = InterpolateJointSamples(
            first,
            second,
            Clamp(pose_index - first_pose_index, 0, 1)
        );
    }
} @ModuleAPI

CalculatePoseTransforms :: (using pose : *ArmaturePose) {
    for * joints {
        local_transform := Mat4fTransformSRT(it.local_position, it.local_orientation, it.local_scale);

        if it.parent {
            it.model_space_transform = it.parent.model_space_transform * local_transform;
        } else {
            it.model_space_transform = local_transform;
        }
    }
} @ModuleAPI

CalculateSkinningMatrices :: (pose : *ArmaturePose, matrices : *[]Mat4f) {
    if matrices.count != pose.joints.count {
        Free(matrices.data);
        matrices.* = AllocArray(Mat4f, pose.joints.count);
    }

    for * matrices.* {
        it.* = pose.joints[it_index].model_space_transform * pose.mesh.joints[it_index].inverse_bind_transform;
    }
} @ModuleAPI

CopyPose :: (dest : *ArmaturePose, src : *ArmaturePose) {
    Assert(dest.mesh == src.mesh, "Armatures do not match");

    for * dest.joints {
        it.sample = src.joints[it_index].sample;
    }
} @ModuleAPI

BlendPoses :: (dest : *ArmaturePose, a : *ArmaturePose, b : *ArmaturePose, t : float) {
    Assert(dest.mesh == a.mesh, "Armatures do not match");
    Assert(dest.mesh == b.mesh, "Armatures do not match");

    for i : 0..dest.joints.count - 1 {
        dest.joints[i].sample = InterpolateJointSamples(a.joints[i], b.joints[i], t);
    }
} @ModuleAPI

AddPoses :: (dest : *ArmaturePose, other : *ArmaturePose, weight := 1.0) {
    Assert(dest.mesh == other.mesh);

    for * dest.joints {
        it.local_position += other.joints[it_index].local_position * weight;
        it.local_orientation *= NLerp(Quatf.{}, other.joints[it_index].local_orientation, weight);
        it.local_scale += other.joints[it_index].local_scale * weight;
    }
} @ModuleAPI

SubtractPoses :: (dest : *ArmaturePose, other : *ArmaturePose, weight := 1.0) {
    Assert(dest.mesh == other.mesh);

    for * dest.joints {
        it.local_position -= other.joints[it_index].local_position * weight;
        weighted_orientation := NLerp(Quatf.{}, other.joints[it_index].local_orientation, weight);
        it.local_orientation = Inverse(weighted_orientation) * it.local_orientation;
        it.local_scale -= other.joints[it_index].local_scale * weight;
    }
} @ModuleAPI
