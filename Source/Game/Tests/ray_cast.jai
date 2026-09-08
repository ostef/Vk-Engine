RayCastTests :: () -> TestsResult {
    result : TestsResult;

    world : World;
    InitWorld(*world);
    defer DestroyWorld(*world);

    sphere := CreateEntity(*world, .EmptyEntity);
    {
        sphere.local_position.x = 10;
        sphere.local_position.y = 10;
        sphere.local_position.z = 10;
        UpdateWorldTransform(*world, sphere);

        collider := AddComponent(*world, SphereColliderComponent, sphere);
        collider.radius = 1;

        rigid_body := AddComponent(*world, RigidBodyComponent, sphere);
        ExecuteEntityCallback(*world, sphere, "OnSpawn");

        sphere_center := TranslationVector(sphere.world_transform);

        // Should hit
        for i : 0..1000 {
            origin := Vec3f.{
                random_get_within_range(-1000, 1000),
                random_get_within_range(-1000, 1000),
                random_get_within_range(-1000, 1000),
            };
            direction := Normalized(sphere_center - origin);

            raycast := PhysicsCastRay(*world, origin, direction, 100000);
            result += raycast.hit;
            result += raycast.entity == sphere;
            result += raycast.rigid_body == rigid_body;
            result += raycast.collider == collider;
            result += ApproxEquals(Distance(raycast.point, sphere_center), collider.radius, 0.00001);
            result += ApproxEquals(raycast.normal, Normalized(raycast.point - sphere_center), 0.00001);
        }

        // Should not hit
    }

    return result;
}
