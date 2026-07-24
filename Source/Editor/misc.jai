FlyingLightsMenu :: (world : *World) {
    if ImGui.BeginMenu("Tools") {
        defer ImGui.EndMenu();

        if ImGui.BeginMenu("Stress Test") {
            defer ImGui.EndMenu();

            if ImGui.MenuItem("Spawn 10 Flying Lights") {
                root := SpawnEntity(world, EmptyEntity, "Flying Lights");
                for 1..10 {
                    entity := SpawnEntity(world, FlyingLightEntity);
                    AttachEntity(world, entity, root);
                }
            }
            if ImGui.MenuItem("Spawn 50 Flying Lights") {
                root := SpawnEntity(world, EmptyEntity, "Flying Lights");
                for 1..50 {
                    entity := SpawnEntity(world, FlyingLightEntity);
                    AttachEntity(world, entity, root);
                }
            }
            if ImGui.MenuItem("Spawn 100 Flying Lights") {
                root := SpawnEntity(world, EmptyEntity, "Flying Lights");
                for 1..100 {
                    entity := SpawnEntity(world, FlyingLightEntity);
                    AttachEntity(world, entity, root);
                }
            }
            if ImGui.MenuItem("Spawn 1000 Flying Lights") {
                root := SpawnEntity(world, EmptyEntity, "Flying Lights");
                for 1..1000 {
                    entity := SpawnEntity(world, FlyingLightEntity);
                    AttachEntity(world, entity, root);
                }
            }
        }
    }
} @EditorMainMenu

IntersectionMenu :: (world : *World) {
    if ImGui.BeginMenu("Tools") {
        defer ImGui.EndMenu();

        if ImGui.MenuItem("Spawn Lots of Points in a Sphere") {
            R :: 10;

            root := SpawnEntity(world, EmptyEntity, "Points");
            for i_lat : 0..R - 1 {
                lat := Lerp(-Pi * 0.5, Pi * 0.5, i_lat / cast(float, R));
                for i_lon : 0..R - 1 {
                    lon := Lerp(-Pi, Pi, i_lon / cast(float, R));

                    p := SphericalToCartesian(lon, lat);
                    direction := -p;
                    right, up := ForwardToOrthonormalBasis(direction);
                    rotation_matrix := Mat3fFromRightUpForward(right, up, direction);
                    rotation := QuatfFromMatrix(rotation_matrix);

                    point := SpawnEntity(world, TestShapeEntity, TPrint("Point % %", i_lat, i_lon));
                    point.shape = .Point;
                    point.local_position = p * 10;
                    point.local_rotation = rotation;
                    UpdateWorldTransform(world, ray);
                    AttachEntity(world, point, root);
                }
            }
        }

        if ImGui.MenuItem("Spawn Lots of Rays in a Sphere") {
            R :: 10;

            root := SpawnEntity(world, EmptyEntity, "Rays");
            for i_lat : 0..R - 1 {
                lat := Lerp(-Pi * 0.5, Pi * 0.5, i_lat / cast(float, R));
                for i_lon : 0..R - 1 {
                    lon := Lerp(-Pi, Pi, i_lon / cast(float, R));

                    p := SphericalToCartesian(lon, lat);
                    direction := -p;
                    right, up := ForwardToOrthonormalBasis(direction);
                    rotation_matrix := Mat3fFromRightUpForward(right, up, direction);
                    rotation := QuatfFromMatrix(rotation_matrix);

                    ray := SpawnEntity(world, TestShapeEntity, TPrint("Ray % %", i_lat, i_lon));
                    ray.shape = .Ray;
                    ray.local_position = p * 10;
                    ray.local_rotation = rotation;
                    UpdateWorldTransform(world, ray);
                    AttachEntity(world, ray, root);
                }
            }
        }
    }
} @EditorMainMenu
