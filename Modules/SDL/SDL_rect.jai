// SDL_rect.h

SDL_Point :: struct {
    x: s32;
    y: s32;
}

SDL_Rect :: struct {
    x, y: s32;
    w, h: s32;
}


SDL_PointInRect :: (p: *SDL_Point, r: *SDL_Rect) -> SDL_bool {
    return xx ( (p.x >= r.x) && (p.x < (r.x + r.w)) && (p.y >= r.y) && (p.y < (r.y + r.h)) );
}
SDL_RectEmpty :: (r: *SDL_Rect) -> SDL_bool {
    return xx ((!r) || (r.w <= 0) || (r.h <= 0));
}
SDL_RectEquals :: (a: *SDL_Rect, b: *SDL_Rect) -> SDL_bool {
    return xx (a && b && (a.x == b.x) && (a.y == b.y) && (a.w == b.w) && (a.h == b.h));
}
SDL_HasIntersection :: (A: *SDL_Rect, B: *SDL_Rect) -> SDL_bool #foreign SDL2;
SDL_IntersectRect :: (A: *SDL_Rect, B: *SDL_Rect, result: *SDL_Rect) -> SDL_bool #foreign SDL2;
SDL_UnionRect :: (A: *SDL_Rect, B: *SDL_Rect, result: *SDL_Rect) #foreign SDL2;
SDL_EnclosePoints :: (points: *SDL_Point, count: s32, clip: *SDL_Rect, result: *SDL_Rect) -> SDL_bool #foreign SDL2;
SDL_IntersectRectAndLine :: (rect: *SDL_Rect, X1: *s32, Y1: *s32, X2: *s32, Y2: *s32) -> SDL_bool #foreign SDL2;
