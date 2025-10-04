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
