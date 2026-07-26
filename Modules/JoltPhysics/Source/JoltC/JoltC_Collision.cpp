#include <JoltC.hpp>

BEGIN_INTERFACE_WRAPPER_CLASS(BroadPhaseLayerInterface);

    virtual uint32_t GetNumBroadPhaseLayers() const override {
        if (funcs.GetNumBroadPhaseLayers) {
            return funcs.GetNumBroadPhaseLayers(data);
        }
        return 0;
    }

    virtual JPH::BroadPhaseLayer GetBroadPhaseLayer(JPH::ObjectLayer layer) const override {
        if (funcs.GetBroadPhaseLayer) {
            return JPH::BroadPhaseLayer(funcs.GetBroadPhaseLayer(data, layer));
        }
        return JPH::BroadPhaseLayer(0);
    }

#if defined(JPH_EXTERNAL_PROFILE) || defined(JPH_PROFILE_ENABLED)
    virtual const char *GetBroadPhaseLayerName(JPH::BroadPhaseLayer layer) const override {
        if (funcs.GetBroadPhaseLayerName) {
            return funcs.GetBroadPhaseLayerName(data, layer.GetValue());
        }
        return "";
    }
#endif

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BroadPhaseLayerInterface);

BEGIN_INTERFACE_WRAPPER_CLASS(ObjectVsBroadPhaseLayerFilter);

    virtual bool ShouldCollide(JPH::ObjectLayer layer1, JPH::BroadPhaseLayer layer2) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, layer1, layer2.GetValue());
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ObjectVsBroadPhaseLayerFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(ObjectLayerPairFilter);

    virtual bool ShouldCollide(JPH::ObjectLayer layer1, JPH::ObjectLayer layer2) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, layer1, layer2);
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ObjectLayerPairFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(BroadPhaseLayerFilter);

	virtual bool ShouldCollide(JPH::BroadPhaseLayer inLayer) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, inLayer.GetValue());
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BroadPhaseLayerFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(ObjectLayerFilter);

	virtual bool ShouldCollide(JPH::ObjectLayer inLayer) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, inLayer);
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ObjectLayerFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(BodyFilter);

    virtual bool ShouldCollide(const JPH::BodyID &bodyID) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, bodyID.GetIndexAndSequenceNumber());
        }
        return true;
    }

    virtual bool ShouldCollideLocked(const JPH::Body &body) const override {
        if (funcs.ShouldCollideLocked) {
            return funcs.ShouldCollideLocked(data, ToC(&body));
        } else {
            return ShouldCollide(body.GetID());
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BodyFilter);

JOLTC_API JPH_BodyFilter *JPH_IgnoreMultipleBodiesFilter_Create(const JPH_BodyID *bodyIDs, int numBodies, JPH_Allocator allocator) {
    void *ptr = JPH_Allocator_Allocate(allocator, sizeof(JPH::IgnoreMultipleBodiesFilter));
    auto filter = new(ptr) JPH::IgnoreMultipleBodiesFilter;
    for (int i = 0; i < numBodies; i += 1) {
        filter->IgnoreBody(JPH::BodyID(bodyIDs[i]));
    }

    return ToC(filter);
}

JOLTC_API JPH_BodyFilter *JPH_IgnoreSingleBodyFilter_Create(JPH_BodyID bodyID, JPH_Allocator allocator) {
    void *ptr = JPH_Allocator_Allocate(allocator, sizeof(JPH::IgnoreSingleBodyFilter));
    return ToC(new(ptr) JPH::IgnoreSingleBodyFilter(JPH::BodyID(bodyID)));
}

JOLTC_API JPH_BodyFilter *JPH_IgnoreSingleBodyFilterChained_Create(JPH_BodyID bodyID, const JPH_BodyFilter *otherFilter, JPH_Allocator allocator) {
    void *ptr = JPH_Allocator_Allocate(allocator, sizeof(JPH::IgnoreSingleBodyFilterChained));
    return ToC(new(ptr) JPH::IgnoreSingleBodyFilterChained(JPH::BodyID(bodyID), *ToCpp(otherFilter)));
}

BEGIN_INTERFACE_WRAPPER_CLASS(ShapeFilter);

    virtual bool ShouldCollide(const JPH::Shape *shape2, const JPH::SubShapeID &subShapeIDOfShape2) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, ToC(shape2), subShapeIDOfShape2.GetValue());
        }
        return true;
    }

    virtual bool ShouldCollide(const JPH::Shape *shape1, const JPH::SubShapeID &subShapeIDOfShape1, const JPH::Shape *shape2, const JPH::SubShapeID &subShapeIDOfShape2) const override {
        if (funcs.ShapesShouldCollide) {
            return funcs.ShapesShouldCollide(data, ToC(shape1), subShapeIDOfShape1.GetValue(), ToC(shape2), subShapeIDOfShape2.GetValue());
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ShapeFilter);

JOLTC_API JPH_ShapeFilter *JPH_ReversedShapeFilter_Create(const JPH_ShapeFilter *other, JPH_Allocator allocator) {
    void *ptr = JPH_Allocator_Allocate(allocator, sizeof(JPH::ReversedShapeFilter));
    return ToC(new(ptr) JPH::ReversedShapeFilter(*ToCpp(other)));
}

// Default filters

bool JPH_DefaultBroadPhaseLayerFilter_ShouldCollide(const void *data, JPH_BroadPhaseLayer layer) {
    auto filter = reinterpret_cast<const JPH_DefaultBroadPhaseLayerFilter *>(data);
    return ToCpp(filter->objectVsBroadPhaseLayerFilter)->ShouldCollide(filter->layer, JPH::BroadPhaseLayer(layer));
}

const JPH_BroadPhaseLayerFilter *JPH_DefaultBroadPhaseLayerFilter_CreateFilter(JPH_DefaultBroadPhaseLayerFilter *filter, JPH_Allocator allocator) {
    JPH_BroadPhaseLayerFilter_Funcs funcs = {};
    funcs.ShouldCollide = JPH_DefaultBroadPhaseLayerFilter_ShouldCollide;

    return JPH_BroadPhaseLayerFilter_Create(filter, funcs, allocator);
}

bool JPH_DefaultObjectLayerFilter_ShouldCollide(const void *data, JPH_ObjectLayer layer) {
    auto filter = reinterpret_cast<const JPH_DefaultObjectLayerFilter *>(data);
    return ToCpp(filter->objectLayerPairFilter)->ShouldCollide(filter->layer, layer);
}

const JPH_ObjectLayerFilter *JPH_DefaultObjectLayerFilter_CreateFilter(JPH_DefaultObjectLayerFilter *filter, JPH_Allocator allocator) {
    JPH_ObjectLayerFilter_Funcs funcs = {};
    funcs.ShouldCollide = JPH_DefaultObjectLayerFilter_ShouldCollide;

    return JPH_ObjectLayerFilter_Create(filter, funcs, allocator);
}

JPH_RayCast JPH_RayCast_Transformed(const JPH_RayCast *ray, JPH_Mat44 transform) {
    return ToC(ToCpp(ray)->Transformed(ToCpp(transform)));
}

JPH_RayCast JPH_RayCast_Translated(const JPH_RayCast *ray, JPH_Vec3 translation) {
    return ToC(ToCpp(ray)->Translated(ToCpp(translation)));
}

JPH_Vec3 JPH_RayCast_GetPointOnRay(const JPH_RayCast *ray, float fraction) {
    return ToC(ToCpp(ray)->GetPointOnRay(fraction));
}

JPH_RRayCast JPH_RRayCast_Transformed(const JPH_RRayCast *ray, JPH_RMat44 transform) {
    return ToC(ToCpp(ray)->Transformed(ToCpp(transform)));
}

JPH_RRayCast JPH_RRayCast_Translated(const JPH_RRayCast *ray, JPH_RVec3 translation) {
    return ToC(ToCpp(ray)->Translated(ToCpp(translation)));
}

JPH_RVec3 JPH_RRayCast_GetPointOnRay(const JPH_RRayCast *ray, float fraction) {
    return ToC(ToCpp(ray)->GetPointOnRay(fraction));
}

JPH_RayCastSettings JPH_RayCastSettings_Default() {
    auto result = JPH::RayCastSettings();
    return *reinterpret_cast<JPH_RayCastSettings *>(&result);
}

bool JPH_BroadPhaseQuery_CastRay(const JPH_BroadPhaseQuery *query, JPH_RayCast ray, JPH_ECollisionCollectorType collectorType, void *data, JPH_BroadPhaseQuery_CastRayHitCallback callback, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter) {
    switch (collectorType) {
    case JPH_ECollisionCollectorType_AnyHit: {
        JPH::AnyHitCollisionCollector<JPH::RayCastBodyCollector> collector;
        ToCpp(query)->CastRay(ToCpp(ray), collector, *ToCpp(broadPhaseLayerFilter), *ToCpp(objectLayerFilter));

        if (collector.HadHit()) {
            JPH_BroadPhaseCastResult result;
            result.bodyID = collector.mHit.mBodyID.GetIndexAndSequenceNumber();
            result.fraction = collector.mHit.mFraction;
            if (callback) {
                callback(data, &result);
            }
            return true;
        }
    } break;

    case JPH_ECollisionCollectorType_ClosestHit: {
        JPH::ClosestHitCollisionCollector<JPH::RayCastBodyCollector> collector;
        ToCpp(query)->CastRay(ToCpp(ray), collector, *ToCpp(broadPhaseLayerFilter), *ToCpp(objectLayerFilter));

        if (collector.HadHit()) {
            JPH_BroadPhaseCastResult result;
            result.bodyID = collector.mHit.mBodyID.GetIndexAndSequenceNumber();
            result.fraction = collector.mHit.mFraction;
            if (callback) {
                callback(data, &result);
            }
            return true;
        }
    } break;

    case JPH_ECollisionCollectorType_AllHitsSorted:
    case JPH_ECollisionCollectorType_AllHits: {
        JPH::AllHitCollisionCollector<JPH::RayCastBodyCollector> collector;
        ToCpp(query)->CastRay(ToCpp(ray), collector, *ToCpp(broadPhaseLayerFilter), *ToCpp(objectLayerFilter));

        if (collector.HadHit()) {
            if (callback) {
                if (collectorType == JPH_ECollisionCollectorType_AllHitsSorted) {
                    collector.Sort();
                }

                JPH_BroadPhaseCastResult result;

                for (const auto &hit : collector.mHits) {
                    result.bodyID = hit.mBodyID.GetIndexAndSequenceNumber();
                    result.fraction = hit.mFraction;
                    callback(data, &result);
                }
            }

            return true;
        }
    } break;
    }

    return false;
}

bool JPH_NarrowPhaseQuery_CastRay(const JPH_NarrowPhaseQuery *query, JPH_RRayCast ray, JPH_RayCastResult *ioHit, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter) {
    return ToCpp(query)->CastRay(ToCpp(ray), *ToCpp(ioHit), *ToCpp(broadPhaseLayerFilter), *ToCpp(objectLayerFilter), *ToCpp(bodyFilter));
}
