g_billboard_vertex_buffer : GfxBuffer;

InitBillboardVertexBuffer :: () {
    if !IsNull(*g_billboard_vertex_buffer) {
        return;
    }

    Vertices :: StaticVertex.[
        .{
            position=.{-0.5,-0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{0,0},
        },
        .{
            position=.{-0.5,0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{0,1},
        },
        .{
            position=.{0.5,0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{1,1},
        },
        .{
            position=.{-0.5,-0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{0,0},
        },
        .{
            position=.{0.5,0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{1,1},
        },
        .{
            position=.{0.5,-0.5,0},
            normal=.{0,0,1},
            tangent=.{1,0,0,1},
            tex_coords=.{1,0},
        },
    ];

    desc : GfxBufferDesc;
    desc.size = size_of(type_of(Vertices));
    desc.usage = .VertexBuffer;
    desc.memory_usage = .Upload;

    g_billboard_vertex_buffer = CreateGfxBuffer("Billboard Vertices", desc);
    Assert(!IsNull(*g_billboard_vertex_buffer), "Could not create vertex buffer for billboard mesh");

    ptr := GetMappedPtr(*g_billboard_vertex_buffer);
    memcpy(ptr, Vertices.data, size_of(type_of(Vertices)));
}

SubmitEditorWorldToRenderer :: (world : *World) {
    world_to_render : WorldToRender;

    SubmitWorldToRenderer(*world_to_render, world);

    for :AllEntitiesWithEditorIcon world {
        if !ShouldShowEntityEditorIcon(GetEntityTypeId(it.index)) {
            continue;
        }

        icon, icon_material := GetEditorIcon(world, it);
        if icon {
            width := icon.width;
            height := icon.height;
            aspect_ratio := height / cast(float, width);

            position := TranslationVector(it.world_transform);

            mesh := MeshToRender.{
                entity_guid = xx it.guid,
                transform=Mat4fTranslate(position) * Mat4fScale(.{1, aspect_ratio, 1}),
                vertex_buffer=*g_billboard_vertex_buffer,
                vertex_count=6,
                material=icon_material,
                is_billboard=true,
            };

            AddMeshToRender(*world_to_render, mesh);

            if EntityOrParentIsSelected(world, it) {
                AddSelectedMeshToRender(*world_to_render, mesh);
            }
        }
    }

    for :AllComponentsWithEditorIcon world {
        if !ShouldShowComponentEditorIcon(GetComponentTypeId(it)) {
            continue;
        }

        entity := GetEntity(world, it.entity_index);
        if !entity {
            continue;
        }

        icon, icon_material := GetEditorIcon(world, entity, it);
        if icon {
            width := icon.width;
            height := icon.height;
            aspect_ratio := height / cast(float, width);

            transform := ifx ComponentIsSpatial(it) then cast(*SpatialComponent, it).world_transform else entity.world_transform;
            position := TranslationVector(transform);
            transform = Mat4fTranslate(position) * Mat4fScale(.{1, aspect_ratio, 1});

            mesh := MeshToRender.{
                entity_guid = xx entity.guid,
                transform=Mat4fTranslate(position) * Mat4fScale(.{1, aspect_ratio, 1}),
                vertex_buffer=*g_billboard_vertex_buffer,
                vertex_count=6,
                material=icon_material,
                is_billboard=true,
            };

            AddMeshToRender(*world_to_render, mesh);

            if EntityOrParentIsSelected(world, entity) {
                AddSelectedMeshToRender(*world_to_render, mesh);
            }
        }
    }

    for g_editor_selected_entities {
        entity := GetEntity(world, it);
        if !entity {
            continue;
        }

        for :AllMeshesToRender entity {
            AddSelectedMeshToRender(*world_to_render, it);
        }
    }

    world_index := AddWorldToRender(world_to_render);

    for g_editor_viewports {
        if it.size.x <= 0 || it.size.y <= 0 {
            continue;
        }

        if !it.visible {
            continue;
        }

        viewpoint := MakeViewpointToRender(it);
        viewpoint.unique_id = it.unique_id;
        viewpoint.world_index = world_index;

        if it.show_wireframe {
            viewpoint.flags |= .ShowWireframe;
        }

        if !it.show_debug_drawings {
            viewpoint.flags |= .NoDebugLines;
        }

        if !it.show_grid {
            viewpoint.flags |= .NoGrids;
        }

        for widget : it.gizmo_ctx.widgets {
            mesh := it.gizmo_ctx.meshes.all[widget.mesh_id];

            to_render := GizmoWidgetToRender.{
                transform=widget.transform,
                color=widget.color,
                shaded=widget.shaded,
                vertex_buffer=*mesh.vertex_buffer,
                index_buffer=*mesh.index_buffer,
                vertex_count=mesh.vertex_count,
                index_count=mesh.index_count,
            };

            ArrayPush(*viewpoint.gizmo_widgets, to_render);
        }

        for line : it.gizmo_ctx.lines_to_draw {
            ArrayPush(*viewpoint.gizmo_lines, line);
        }

        AddViewpointToRender(viewpoint);
    }

    SubmitMaterialEditorPreviewToRenderer(world);
}

SubmitMaterialEditorPreviewToRenderer :: (world : *World) {
    if !g_material_editor.preview_visible || !g_material_editor.selected_material || !g_material_editor.preview_mesh {
        return;
    }

    world_to_render : WorldToRender;

    world_to_render.bloom_params = world.bloom_params;

    if g_material_editor.preview_use_world_skybox {
        world_to_render.skybox = world.skybox;
        world_to_render.skybox_light_intensity = world.skybox_light_intensity;
    }

    light : DirectionalLightToRender;
    light.direction = Normalized(Vec3f.{1,-1,1});
    light.intensity = 1;
    light.color = .{1,1,1};
    AddDirectionalLightToRender(*world_to_render, light);

    mesh : MeshToRender;
    mesh.vertex_buffer = *g_material_editor.preview_mesh.vertex_buffer;
    mesh.vertex_count = g_material_editor.preview_mesh.vertex_count;
    mesh.index_buffer = *g_material_editor.preview_mesh.index_buffer;
    mesh.index_count = g_material_editor.preview_mesh.index_count;
    mesh.static_bounds = g_material_editor.preview_mesh.static_bounds;
    mesh.transform = Mat4fFromQuat(g_material_editor.preview_mesh_rotation);
    mesh.material = g_material_editor.selected_material;

    AddMeshToRender(*world_to_render, mesh);

    world_index := AddWorldToRender(world_to_render);

    viewpoint := MakeViewpointToRender(*g_material_editor.preview_camera, .{xx Max(g_material_editor.preview_size.x, 0), xx Max(g_material_editor.preview_size.y, 0)});
    viewpoint.unique_id = Material_Editor_Preview_Viewport_ID;
    viewpoint.flags = .NoGrids;
    viewpoint.world_index = world_index;
    AddViewpointToRender(viewpoint);
}
