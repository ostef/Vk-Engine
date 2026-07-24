#pragma once

#include <JoltC_Core.h>
#include <JoltC_Body.h>

#ifndef JPH_DEBUG_RENDERER
#error "This file must only be included when JPH_DEBUG_RENDERER is defined"
#endif

typedef struct JPH_DebugRenderer  JPH_DebugRenderer;
typedef struct JPH_BodyDrawFilter JPH_BodyDrawFilter;

typedef uint32_t JPH_DebugRenderer_ECastShadow;
enum {
    JPH_DebugRenderer_ECastShadow_On,
    JPH_DebugRenderer_ECastShadow_Off,
};

typedef uint32_t JPH_DebugRenderer_EDrawMode;
enum {
    JPH_DebugRenderer_EDrawMode_Solid,
    JPH_DebugRenderer_EDrawMode_Wireframe,
};

typedef uint32_t JPH_DebugRenderer_ECullMode;
enum {
    JPH_DebugRenderer_ECullMode_CullBackFace,
    JPH_DebugRenderer_ECullMode_CullFrontFace,
    JPH_DebugRenderer_ECullMode_Off,
};

typedef uint32_t JPH_ESoftBodyConstraintColor;
enum {
    JPH_ESoftBodyConstraintColor_ConstraintType,
    JPH_ESoftBodyConstraintColor_ConstraintGroup,
    JPH_ESoftBodyConstraintColor_ConstraintOrder,
};

typedef uint32_t JPH_BodyManager_EShapeColor;
enum {
    JPH_BodyManager_EShapeColor_InstanceColor,
    JPH_BodyManager_EShapeColor_ShapeTypeColor,
    JPH_BodyManager_EShapeColor_MotionTypeColor,
    JPH_BodyManager_EShapeColor_SleepColor,
    JPH_BodyManager_EShapeColor_IslandColor,
    JPH_BodyManager_EShapeColor_MaterialColor,
};

typedef struct JPH_BodyManager_DrawSettings {
    bool drawGetSupportFunction;
    bool drawSupportDirection;
    bool drawGetSupportingFace;
    bool drawShape;
    bool drawShapeWireframe;
    JPH_BodyManager_EShapeColor drawShapeColor;
    bool drawBoundingBox;
    bool drawCenterOfMassTransform;
    bool drawWorldTransform;
    bool drawVelocity;
    bool drawMassAndInertia;
    bool drawSleepStats;
    bool drawSoftBodyVertices;
    bool drawSoftBodyVertexVelocities;
    bool drawSoftBodyEdgeConstraints;
    bool drawSoftBodyBendConstraints;
    bool drawSoftBodyVolumeConstraints;
    bool drawSoftBodySkinConstraints;
    bool drawSoftBodyLRAConstraints;
    bool drawSoftBodyRods;
    bool drawSoftBodyRodStates;
    bool drawSoftBodyRodBendTwistConstraints;
    bool drawSoftBodyPredictedBounds;
    JPH_ESoftBodyConstraintColor drawSoftBodyConstraintColor;
} JPH_BodyManager_DrawSettings;

typedef struct JPH_DebugRendererSimple_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    void (JOLTC_CALL *DrawLine)(void *data, JPH_RVec3 from, JPH_RVec3 to, JPH_Color color);
    void (JOLTC_CALL *DrawTriangle)(void *data, JPH_RVec3 v1, JPH_RVec3 v2, JPH_RVec3 v3, JPH_Color color, JPH_DebugRenderer_ECastShadow castShadow);
    void (JOLTC_CALL *DrawText3D)(void *data, JPH_RVec3 position, const char *str, uint64_t strLength, JPH_Color color, float height);
} JPH_DebugRendererSimple_Funcs;

JOLTC_API JPH_DebugRenderer *JPH_DebugRendererSimple_Create(void *data, JPH_DebugRendererSimple_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_DebugRenderer_Destroy(JPH_DebugRenderer *self);
JOLTC_API void JPH_DebugRenderer_NextFrame(JPH_DebugRenderer *self);
// @Todo: other DebugRenderer functions

typedef struct JPH_BodyDrawFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldDraw)(const void *data, const JPH_Body *body);
} JPH_BodyDrawFilter_Funcs;

JOLTC_API JPH_BodyDrawFilter *JPH_BodyDrawFilter_Create(void *data, JPH_BodyDrawFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_BodyDrawFilter_Destroy(JPH_BodyDrawFilter *self);
