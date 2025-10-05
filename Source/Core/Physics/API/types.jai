Sphere :: struct {
    center : Vec3f;
    radius : float;
}

Capsule :: struct {
    center : Vec3f;
    normal : Vec3f;
    height : float;
    radius : float;
}

AABB :: struct {
    center : Vec3f;
    half_extents : Vec3f;
}

Ray :: struct {
    origin : Vec3f;
    direction : Vec3f;
    length : float;
}

Plane :: struct {
    origin : Vec3f;
    normal : Vec3f;
}

MakePlane :: inline (origin : Vec3f, normal : Vec3f) -> Plane {
    return .{origin, Normalized(normal)};
}

SignedDistanceToPlane :: inline (point : Vec3f, plane : Plane) -> float {
    return Dot(plane.normal, point) - Dot(plane.normal, plane.origin);
}

AABBIsInFrontOrOnPlane :: (aabb : AABB, plane : Plane) -> bool {
    r := aabb.half_extents.x * Abs(plane.normal.x)
        + aabb.half_extents.y * Abs(plane.normal.y)
        + aabb.half_extents.z * Abs(plane.normal.z);

    dist_to_plane := SignedDistanceToPlane(aabb.center, plane);

    return dist_to_plane > 0 || Abs(dist_to_plane) <= r;
}

Frustum :: struct {
    far_plane, near_plane : Plane;
    left_plane, right_plane : Plane;
    top_plane, bottom_plane : Plane;

    #place far_plane;
    planes : [6]Plane;
}

GetTransformedAABB :: (transform : Mat4f, aabb : AABB) -> AABB {
    //      e---g
    // a---c \  |
    // |\  |  \ |
    // | \ |   \|
    // |  \|h---f
    // d---b

    a := aabb.center - aabb.half_extents;
    f := aabb.center + aabb.half_extents;
    b := Vec3f.{f.x, f.y, a.z};
    c := Vec3f.{f.x, a.y, a.z};
    d := Vec3f.{a.x, f.y, a.z};
    e := Vec3f.{a.x, a.y, f.z};
    g := Vec3f.{f.x, a.y, f.z};
    h := Vec3f.{a.x, f.y, f.z};

    a = TransformPoint(transform, a);
    b = TransformPoint(transform, b);
    c = TransformPoint(transform, c);
    d = TransformPoint(transform, d);
    e = TransformPoint(transform, e);
    f = TransformPoint(transform, f);
    g = TransformPoint(transform, g);
    h = TransformPoint(transform, h);

    min := Min(Min(Min(Min(Min(Min(Min(a, b), c), d), e), f), g), h);
    max := Max(Max(Max(Max(Max(Max(Max(a, b), c), d), e), f), g), h);

    return .{center=(max + min) * 0.5, half_extents=(max - min) * 0.5};
}

AABBIsInFrustum :: inline (aabb : AABB, using frustum : Frustum) -> bool {
    return AABBIsInFrontOrOnPlane(aabb, left_plane)
        && AABBIsInFrontOrOnPlane(aabb, right_plane)
        && AABBIsInFrontOrOnPlane(aabb, top_plane)
        && AABBIsInFrontOrOnPlane(aabb, bottom_plane)
        && AABBIsInFrontOrOnPlane(aabb, near_plane)
        && AABBIsInFrontOrOnPlane(aabb, far_plane);
}

PointIsInFrustum :: inline (point : Vec3f, using frustum : Frustum) -> bool {
    return SignedDistanceToPlane(point, left_plane) >= 0
        && SignedDistanceToPlane(point, right_plane) >= 0
        && SignedDistanceToPlane(point, top_plane) >= 0
        && SignedDistanceToPlane(point, bottom_plane) >= 0
        && SignedDistanceToPlane(point, near_plane) >= 0
        && SignedDistanceToPlane(point, far_plane) >= 0;
}

MakePerspectiveFrustum :: (transform : Mat4f, fov_in_degrees : float, aspect_ratio : float, z_near : float, z_far : float) -> Frustum {
    inv_aspect_ratio := 1 / aspect_ratio;
    if !Math.is_finite(inv_aspect_ratio) {
        return .{};
    }

    half_near_v_side := z_near * Tan(ToRads(fov_in_degrees * 0.5));
    half_near_h_side := half_near_v_side * aspect_ratio;
    half_near_h_hypothenuse := Sqrt(z_near * z_near + half_near_h_side * half_near_h_side);
    half_near_v_hypothenuse := Sqrt(z_near * z_near + half_near_v_side * half_near_v_side);

    half_far_v_side := z_far * Tan(ToRads(fov_in_degrees * 0.5));
    half_far_h_side := half_far_v_side * aspect_ratio;
    half_far_h_hypothenuse := Sqrt(z_far * z_far + half_far_h_side * half_far_h_side);
    half_far_v_hypothenuse := Sqrt(z_far * z_far + half_far_v_side * half_far_v_side);

    right   := RightVector(transform);
    up      := UpVector(transform);
    forward := ForwardVector (transform);
    position := TranslationVector(transform);

    using result : Frustum = ---;
    near_plane   = MakePlane(position + z_near * forward, forward);
    far_plane    = MakePlane(position + z_far * forward, -forward);

    far_center := z_far * forward;

    far_right := far_center + right * half_far_h_side;
    far_left  := far_center - right * half_far_h_side;
    right_center := far_right - Normalized(far_right) * (half_far_h_hypothenuse - half_near_h_hypothenuse) * 0.5;
    left_center  := far_left - Normalized(far_left) * (half_far_h_hypothenuse - half_near_h_hypothenuse) * 0.5;

    right_plane  = MakePlane(position + right_center, Cross(far_right, up));
    left_plane   = MakePlane(position + left_center, Cross(up, far_left));

    far_top    := far_center + up * half_far_v_side;
    far_bottom := far_center - up * half_far_v_side;
    top_center    := far_top - Normalized(far_top) * (half_far_v_hypothenuse - half_near_v_hypothenuse) * 0.5;
    bottom_center := far_bottom - Normalized(far_bottom) * (half_far_v_hypothenuse - half_near_v_hypothenuse) * 0.5;

    top_plane    = MakePlane(position + top_center, Cross(right, far_top));
    bottom_plane = MakePlane(position + bottom_center, Cross(far_bottom, right));

    return result;
}

MakeOrthographicFrustum :: (transform : Mat4f, l : float, r : float, t : float, b : float, z_near : float, z_far : float) -> Frustum {
    forward := ForwardVector (transform);
    right   := RightVector(transform);
    up      := UpVector(transform);
    position := TranslationVector(transform);

    using result : Frustum = ---;
    near_plane = MakePlane(position + z_near * forward, forward);
    far_plane  = MakePlane(position + z_far * forward, -forward);

    forward_center := forward * (z_near + z_far) * 0.5;
    right_plane = MakePlane(position + forward_center + r * right, -right);
    left_plane  = MakePlane(position + forward_center + l * right, right);

    top_plane    = MakePlane(position + forward_center - t * up, -up);
    bottom_plane = MakePlane(position + forward_center - b * up, up);

    return result;
}
