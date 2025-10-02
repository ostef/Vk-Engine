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
    SubmitWorldToRenderer(world);

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

            AddMeshToRender(mesh);

            if EntityOrParentIsSelected(world, it) {
                AddSelectedMeshToRender(mesh);
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

            AddMeshToRender(mesh);

            if EntityOrParentIsSelected(world, entity) {
                AddSelectedMeshToRender(mesh);
            }
        }
    }

    for g_editor_selected_entities {
        entity := GetEntity(world, it);
        if !entity {
            continue;
        }

        for :AllMeshesToRender entity {
            AddSelectedMeshToRender(it);
        }
    }

    for g_editor_viewports {
        if it.size.x == 0 || it.size.y == 0 {
            continue;
        }

        if !it.visible {
            continue;
        }

        viewpoint := MakeViewpointToRender(it);
        viewpoint.unique_id = it.unique_id;
        viewpoint.skybox = world.skybox;
        viewpoint.skybox_light_intensity = world.skybox_light_intensity;

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
}
