// SDL_audio.h

SDL_AudioFormat :: u16;
//SDL_AudioFormat :: enum_flags u16 {

    SDL_AUDIO_MASK_BITSIZE ::       (0xFF);
    SDL_AUDIO_MASK_DATATYPE ::      (1<<8);
    SDL_AUDIO_MASK_ENDIAN ::        (1<<12);
    SDL_AUDIO_MASK_SIGNED ::        (1<<15);
    SDL_AUDIO_BITSIZE :: (x: SDL_AudioFormat) -> u16 {         return (x & SDL_AUDIO_MASK_BITSIZE); }
    SDL_AUDIO_ISFLOAT :: (x: SDL_AudioFormat) -> bool {         return xx (x & SDL_AUDIO_MASK_DATATYPE); }
    SDL_AUDIO_ISBIGENDIAN :: (x: SDL_AudioFormat) -> bool {     return xx (x & SDL_AUDIO_MASK_ENDIAN); }
    SDL_AUDIO_ISSIGNED :: (x: SDL_AudioFormat) -> bool {        return xx (x & SDL_AUDIO_MASK_SIGNED); };
    SDL_AUDIO_ISINT :: (x: SDL_AudioFormat) -> bool {           return !SDL_AUDIO_ISFLOAT(x); }
    SDL_AUDIO_ISLITTLEENDIAN :: (x: SDL_AudioFormat) -> bool {  return !SDL_AUDIO_ISBIGENDIAN(x); }
    SDL_AUDIO_ISUNSIGNED :: (x: SDL_AudioFormat) -> bool {      return !SDL_AUDIO_ISSIGNED(x);}

    AUDIO_U8 ::        0x0008;
    AUDIO_S8 ::        0x8008;
    AUDIO_U16LSB ::    0x0010;
    AUDIO_S16LSB ::    0x8010;
    AUDIO_U16MSB ::    0x1010;
    AUDIO_S16MSB ::    0x9010;
    AUDIO_U16 ::       AUDIO_U16LSB;
    AUDIO_S16 ::       AUDIO_S16LSB;

    AUDIO_S32LSB ::    0x8020;
    AUDIO_S32MSB ::    0x9020;
    AUDIO_S32 ::       AUDIO_S32LSB;

    AUDIO_F32LSB ::    0x8120;
    AUDIO_F32MSB ::    0x9120;
    AUDIO_F32 ::       AUDIO_F32LSB;

    AUDIO_U16SYS ::    AUDIO_U16LSB;
    AUDIO_S16SYS ::    AUDIO_S16LSB;
    AUDIO_S32SYS ::    AUDIO_S32LSB;
    AUDIO_F32SYS ::    AUDIO_F32LSB;

//}

SDL_AUDIO_ALLOW_FREQUENCY_CHANGE ::    0x00000001;
SDL_AUDIO_ALLOW_FORMAT_CHANGE ::       0x00000002;
SDL_AUDIO_ALLOW_CHANNELS_CHANGE ::     0x00000004;
SDL_AUDIO_ALLOW_SAMPLES_CHANGE ::      0x00000008;
SDL_AUDIO_ALLOW_ANY_CHANGE ::          (SDL_AUDIO_ALLOW_FREQUENCY_CHANGE|SDL_AUDIO_ALLOW_FORMAT_CHANGE|SDL_AUDIO_ALLOW_CHANNELS_CHANGE|SDL_AUDIO_ALLOW_SAMPLES_CHANGE);


SDL_AudioCallback :: #type (a0: *void, a1: *u8, a2: s32) #c_call;

SDL_AudioSpec :: struct {
    freq: s32;
    format: SDL_AudioFormat;
    channels: u8;
    silence: u8;
    samples: u16;
    padding: u16;
    size: u32;
    callback: SDL_AudioCallback;
    userdata: *void;
}



SDL_AudioFilter :: #type (a0: *SDL_AudioCVT, a1: SDL_AudioFormat) #c_call;

SDL_AudioCVT :: struct {
    needed: s32;
    src_format: SDL_AudioFormat;
    dst_format: SDL_AudioFormat;
    rate_incr: float64;
    buf: *u8;
    len: s32;
    len_cvt: s32;
    len_mult: s32;
    len_ratio: float64;
    filters: [10] SDL_AudioFilter;
    filter_index: s32;
}


SDL_GetNumAudioDrivers :: () -> s32 #foreign SDL2;
SDL_GetAudioDriver :: (index: s32) -> *u8 #foreign SDL2;
SDL_AudioInit :: (driver_name: *u8) -> s32 #foreign SDL2;
SDL_AudioQuit :: () #foreign SDL2;
SDL_GetCurrentAudioDriver :: () -> *u8 #foreign SDL2;
SDL_OpenAudio :: (desired: *SDL_AudioSpec, obtained: *SDL_AudioSpec) -> s32 #foreign SDL2;
SDL_AudioDeviceID :: u32;

SDL_GetNumAudioDevices :: (iscapture: s32) -> s32 #foreign SDL2;
SDL_GetAudioDeviceName :: (index: s32, iscapture: s32) -> *u8 #foreign SDL2;
SDL_OpenAudioDevice :: (device: *u8, iscapture: s32, desired: *SDL_AudioSpec, obtained: *SDL_AudioSpec, allowed_changes: s32) -> SDL_AudioDeviceID #foreign SDL2;

using SDL_AudioStatus :: enum u32 {
        SDL_AUDIO_STOPPED :: 0;
        SDL_AUDIO_PLAYING :: 1;
        SDL_AUDIO_PAUSED :: 2;
}

SDL_GetAudioStatus :: () -> SDL_AudioStatus #foreign SDL2;
SDL_GetAudioDeviceStatus :: (dev: SDL_AudioDeviceID) -> SDL_AudioStatus #foreign SDL2;
SDL_PauseAudio :: (pause_on: s32) #foreign SDL2;
SDL_PauseAudioDevice :: (dev: SDL_AudioDeviceID, pause_on: s32) #foreign SDL2;
//SDL_LoadWAV_RW :: (src: *SDL_RWops, freesrc: s32, spec: *SDL_AudioSpec, audio_buf: **u8, audio_len: *u32) -> *SDL_AudioSpec #foreign SDL2;
SDL_FreeWAV :: (audio_buf: *u8) #foreign SDL2;
SDL_BuildAudioCVT :: (cvt: *SDL_AudioCVT, src_format: SDL_AudioFormat, src_channels: u8, src_rate: s32, dst_format: SDL_AudioFormat, dst_channels: u8, dst_rate: s32) -> s32 #foreign SDL2;
SDL_ConvertAudio :: (cvt: *SDL_AudioCVT) -> s32 #foreign SDL2;

SDL_AudioStream :: struct {};

SDL_NewAudioStream :: (src_format: SDL_AudioFormat, src_channels: u8, src_rate: s32, dst_format: SDL_AudioFormat, dst_channels: u8, dst_rate: s32) -> *SDL_AudioStream #foreign SDL2;
SDL_AudioStreamPut :: (stream: *SDL_AudioStream, buf: *void, len: s32) -> s32 #foreign SDL2;
SDL_AudioStreamGet :: (stream: *SDL_AudioStream, buf: *void, len: s32) -> s32 #foreign SDL2;
SDL_AudioStreamAvailable :: (stream: *SDL_AudioStream) -> s32 #foreign SDL2;
SDL_AudioStreamFlush :: (stream: *SDL_AudioStream) -> s32 #foreign SDL2;
SDL_AudioStreamClear :: (stream: *SDL_AudioStream) #foreign SDL2;
SDL_FreeAudioStream :: (stream: *SDL_AudioStream) #foreign SDL2;
SDL_MixAudio :: (dst: *u8, src: *u8, len: u32, volume: s32) #foreign SDL2;
SDL_MixAudioFormat :: (dst: *u8, src: *u8, format: SDL_AudioFormat, len: u32, volume: s32) #foreign SDL2;
SDL_QueueAudio :: (dev: SDL_AudioDeviceID, data: *void, len: u32) -> s32 #foreign SDL2;
SDL_DequeueAudio :: (dev: SDL_AudioDeviceID, data: *void, len: u32) -> u32 #foreign SDL2;
SDL_GetQueuedAudioSize :: (dev: SDL_AudioDeviceID) -> u32 #foreign SDL2;
SDL_ClearQueuedAudio :: (dev: SDL_AudioDeviceID) #foreign SDL2;
SDL_LockAudio :: () #foreign SDL2;
SDL_LockAudioDevice :: (dev: SDL_AudioDeviceID) #foreign SDL2;
SDL_UnlockAudio :: () #foreign SDL2;
SDL_UnlockAudioDevice :: (dev: SDL_AudioDeviceID) #foreign SDL2;
SDL_CloseAudio :: () #foreign SDL2;
SDL_CloseAudioDevice :: (dev: SDL_AudioDeviceID) #foreign SDL2;


