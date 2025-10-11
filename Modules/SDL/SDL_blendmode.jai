// SDL_blendmode.h

using SDL_BlendMode :: enum u32 {
    SDL_BLENDMODE_NONE :: 0;
    SDL_BLENDMODE_BLEND :: 1;
    SDL_BLENDMODE_ADD :: 2;
    SDL_BLENDMODE_MOD :: 4;
    SDL_BLENDMODE_INVALID :: 2147483647;
}

using SDL_BlendOperation :: enum u32 {
    SDL_BLENDOPERATION_ADD :: 1;
    SDL_BLENDOPERATION_SUBTRACT :: 2;
    SDL_BLENDOPERATION_REV_SUBTRACT :: 3;
    SDL_BLENDOPERATION_MINIMUM :: 4;
    SDL_BLENDOPERATION_MAXIMUM :: 5;
}

using SDL_BlendFactor :: enum u32 {
    SDL_BLENDFACTOR_ZERO :: 1;
    SDL_BLENDFACTOR_ONE :: 2;
    SDL_BLENDFACTOR_SRC_COLOR :: 3;
    SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR :: 4;
    SDL_BLENDFACTOR_SRC_ALPHA :: 5;
    SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA :: 6;
    SDL_BLENDFACTOR_DST_COLOR :: 7;
    SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR :: 8;
    SDL_BLENDFACTOR_DST_ALPHA :: 9;
    SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA :: 10;
}

SDL_ComposeCustomBlendMode :: (srcColorFactor: SDL_BlendFactor, dstColorFactor: SDL_BlendFactor, colorOperation: SDL_BlendOperation, srcAlphaFactor: SDL_BlendFactor, dstAlphaFactor: SDL_BlendFactor, alphaOperation: SDL_BlendOperation) -> SDL_BlendMode #foreign SDL2;
