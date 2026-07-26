#include <JoltC.hpp>

#ifdef JPH_DEBUG_RENDERER

BEGIN_INTERFACE_WRAPPER_CLASS(BodyDrawFilter);

    virtual bool ShouldDraw(const JPH::Body &body) const {
        if (funcs.ShouldDraw) {
            return funcs.ShouldDraw(data, &ToC(body));
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BodyDrawFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(DebugRendererSimple);

    virtual void DrawLine(JPH::RVec3Arg inFrom, JPH::RVec3Arg inTo, JPH::ColorArg inColor) override {
        if (funcs.DrawLine) {
            funcs.DrawLine(data, ToC(inFrom), ToC(inTo), inColor.GetUInt32());
        }
    }

    virtual void DrawTriangle(JPH::RVec3Arg inV1, JPH::RVec3Arg inV2, JPH::RVec3Arg inV3, JPH::ColorArg inColor, ECastShadow inCastShadow) override {
        if (funcs.DrawTriangle) {
            funcs.DrawTriangle(data, ToC(inV1), ToC(inV2), ToC(inV3), inColor.GetUInt32(), static_cast<JPH_DebugRenderer_ECastShadow>(inCastShadow));
        } else {
            DrawLine(inV1, inV2, inColor);
            DrawLine(inV2, inV3, inColor);
            DrawLine(inV3, inV1, inColor);
        }
    }

    virtual void DrawText3D(JPH::RVec3Arg inPosition, const std::string_view &inString, JPH::ColorArg inColor, float inHeight) override {
        if (funcs.DrawText3D) {
            funcs.DrawText3D(data, ToC(inPosition), inString.data(), inString.size(), inColor.GetUInt32(), inHeight);
        }
    }

END_INTERFACE_WRAPPER_CLASS();

JPH_DebugRenderer *JPH_DebugRendererSimple_Create(void *data, JPH_DebugRendererSimple_Funcs funcs, JPH_Allocator allocator) {
    void *ptr = JPH_Allocator_Allocate(allocator, sizeof(DebugRendererSimpleWrapper));
    return ToC(reinterpret_cast<JPH::DebugRenderer *>(new(ptr) DebugRendererSimpleWrapper(data, funcs, allocator)));
}

void JPH_DebugRenderer_Destroy(JPH_DebugRenderer *self) {
    delete ToCpp(self);
}

void JPH_DebugRenderer_NextFrame(JPH_DebugRenderer *self) {
    ToCpp(self)->NextFrame();
}

#endif
