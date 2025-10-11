// SDL_version.h

SDL_version :: struct {
    major: u8;        // major version
    minor: u8;        // minor version
    patch: u8;        // update version
}

SDL_MAJOR_VERSION ::   2;
SDL_MINOR_VERSION ::   0;
SDL_PATCHLEVEL ::      1;

SDL_VERSION :: (x: *$T) {
    x.major = SDL_MAJOR_VERSION;
    x.minor = SDL_MINOR_VERSION;
    x.patch = SDL_PATCHLEVEL;
}

SDL_VERSIONNUM :: (X:s32, Y:s32, Z:s32) -> s32 {
    return (X*1000 + Y*100 + Z);
}

SDL_GetVersion :: (ver: *SDL_version) #foreign SDL2;
SDL_GetRevision :: () -> *u8 #foreign SDL2;
SDL_GetRevisionNumber :: () -> s32 #foreign SDL2;
