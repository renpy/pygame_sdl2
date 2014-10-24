# Taken from https://gist.github.com/krischer/4219808
# This is incomplete and partly broken

cdef extern from "sys/types.h" nogil:
    ctypedef signed char int8_t
    ctypedef short int16_t
    ctypedef int int32_t
    ctypedef long long int64_t

cdef extern from "iconv.h" nogil:
    ctypedef void *iconv_t

cdef extern from "stdlib.h" nogil:
    ctypedef int wchar_t

cdef extern from "sys/types.h" nogil:
    ctypedef unsigned long size_t

cdef extern from "stdint.h" nogil:
    ctypedef unsigned char uint8_t
    ctypedef unsigned short uint16_t
    ctypedef unsigned int uint32_t
    ctypedef unsigned long long uint64_t

cdef extern from "stdio.h" nogil:
    cdef struct __sFILE:
        pass
    ctypedef __sFILE FILE

cdef extern from "stdarg.h" nogil:
    ctypedef void *va_list

cdef extern from "SDL.h" nogil:
    enum: _SDL_H
    enum: _SDL_main_h
    enum: _SDL_stdinc_h
    enum: _SDL_config_h
    enum: _SDL_platform_h
    enum: __MACOSX__
    enum: _begin_code_h
    enum: DECLSPEC
    enum: SDLCALL
    enum: SDL_INLINE_OKAY
    enum: SIZEOF_VOIDP
    enum: HAVE_GCC_ATOMICS
    enum: HAVE_LIBC
    enum: HAVE_ALLOCA_H
    enum: HAVE_SYS_TYPES_H
    enum: HAVE_STDIO_H
    enum: STDC_HEADERS
    enum: HAVE_STDLIB_H
    enum: HAVE_STDARG_H
    enum: HAVE_MEMORY_H
    enum: HAVE_STRING_H
    enum: HAVE_STRINGS_H
    enum: HAVE_INTTYPES_H
    enum: HAVE_STDINT_H
    enum: HAVE_CTYPE_H
    enum: HAVE_MATH_H
    enum: HAVE_ICONV_H
    enum: HAVE_SIGNAL_H
    enum: HAVE_MALLOC
    enum: HAVE_CALLOC
    enum: HAVE_REALLOC
    enum: HAVE_FREE
    enum: HAVE_ALLOCA
    enum: HAVE_GETENV
    enum: HAVE_SETENV
    enum: HAVE_PUTENV
    enum: HAVE_UNSETENV
    enum: HAVE_QSORT
    enum: HAVE_ABS
    enum: HAVE_BCOPY
    enum: HAVE_MEMSET
    enum: HAVE_MEMCPY
    enum: HAVE_MEMMOVE
    enum: HAVE_MEMCMP
    enum: HAVE_STRLEN
    enum: HAVE_STRLCPY
    enum: HAVE_STRLCAT
    enum: HAVE_STRDUP
    enum: HAVE_STRCHR
    enum: HAVE_STRRCHR
    enum: HAVE_STRSTR
    enum: HAVE_STRTOL
    enum: HAVE_STRTOUL
    enum: HAVE_STRTOLL
    enum: HAVE_STRTOULL
    enum: HAVE_STRTOD
    enum: HAVE_ATOI
    enum: HAVE_ATOF
    enum: HAVE_STRCMP
    enum: HAVE_STRNCMP
    enum: HAVE_STRCASECMP
    enum: HAVE_STRNCASECMP
    enum: HAVE_SSCANF
    enum: HAVE_SNPRINTF
    enum: HAVE_VSNPRINTF
    enum: HAVE_M_PI
    enum: HAVE_ATAN
    enum: HAVE_ATAN2
    enum: HAVE_CEIL
    enum: HAVE_COPYSIGN
    enum: HAVE_COS
    enum: HAVE_COSF
    enum: HAVE_FABS
    enum: HAVE_FLOOR
    enum: HAVE_LOG
    enum: HAVE_POW
    enum: HAVE_SCALBN
    enum: HAVE_SIN
    enum: HAVE_SINF
    enum: HAVE_SQRT
    enum: HAVE_SIGACTION
    enum: HAVE_SA_SIGACTION
    enum: HAVE_SETJMP
    enum: HAVE_NANOSLEEP
    enum: HAVE_SYSCONF
    enum: HAVE_SYSCTLBYNAME
    enum: HAVE_MPROTECT
    enum: HAVE_ICONV
    enum: HAVE_PTHREAD_SETNAME_NP
    enum: SDL_AUDIO_DRIVER_COREAUDIO
    enum: SDL_AUDIO_DRIVER_DISK
    enum: SDL_AUDIO_DRIVER_DUMMY
    enum: SDL_JOYSTICK_IOKIT
    enum: SDL_HAPTIC_IOKIT
    enum: SDL_LOADSO_DLOPEN
    enum: SDL_THREAD_PTHREAD
    enum: SDL_THREAD_PTHREAD_RECURSIVE_MUTEX
    enum: SDL_TIMER_UNIX
    enum: SDL_VIDEO_DRIVER_COCOA
    enum: SDL_VIDEO_DRIVER_DUMMY
    enum: SDL_VIDEO_DRIVER_X11
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XEXT
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XCURSOR
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XINERAMA
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XINPUT
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XRANDR
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XSS
    enum: SDL_VIDEO_DRIVER_X11_DYNAMIC_XVIDMODE
    enum: SDL_VIDEO_DRIVER_X11_XCURSOR
    enum: SDL_VIDEO_DRIVER_X11_XINERAMA
    enum: SDL_VIDEO_DRIVER_X11_XINPUT
    enum: SDL_VIDEO_DRIVER_X11_XRANDR
    enum: SDL_VIDEO_DRIVER_X11_XSCRNSAVER
    enum: SDL_VIDEO_DRIVER_X11_XSHAPE
    enum: SDL_VIDEO_DRIVER_X11_XVIDMODE
    enum: SDL_VIDEO_RENDER_OGL
    enum: SDL_VIDEO_OPENGL
    enum: SDL_VIDEO_OPENGL_CGL
    enum: SDL_VIDEO_OPENGL_GLX
    enum: SDL_POWER_MACOSX
    enum: SDL_ASSEMBLY_ROUTINES
    enum: SDL_arraysize
    enum: SDL_TABLESIZE
    enum: SDL_static_cast
    enum: _begin_code_h
    enum: SDL_calloc
    enum: SDL_realloc
    enum: SDL_stack_alloc
    enum: SDL_getenv
    enum: SDL_qsort
    enum: SDL_abs
    enum: SDL_max
    enum: SDL_isdigit
    enum: SDL_isspace
    enum: SDL_tolower
    enum: SDL_memset4
    enum: SDL_memcpy
    enum: SDL_memcpy4
    enum: SDL_memmove
    enum: SDL_memcmp
    enum: SDL_strlen
    enum: SDL_strlcpy
    enum: SDL_strlcat
    enum: SDL_strdup
    enum: SDL_strchr
    enum: SDL_strrchr
    enum: SDL_strstr
    enum: SDL_itoa
    enum: SDL_uitoa
    enum: SDL_strtol
    enum: SDL_strtoul
    enum: SDL_strtoll
    enum: SDL_strtoull
    enum: SDL_strtod
    enum: SDL_atoi
    enum: SDL_atof
    enum: SDL_strcmp
    enum: SDL_strncmp
    enum: SDL_strcasecmp
    enum: SDL_strncasecmp
    enum: SDL_sscanf
    enum: SDL_snprintf
    enum: SDL_vsnprintf
    enum: SDL_atan
    enum: SDL_atan2
    enum: SDL_ceil
    enum: SDL_copysign
    enum: SDL_cos
    enum: SDL_cosf
    enum: SDL_fabs
    enum: SDL_floor
    enum: SDL_log
    enum: SDL_pow
    enum: SDL_scalbn
    enum: SDL_sin
    enum: SDL_sinf
    enum: SDL_sqrt
    enum: SDL_ICONV_ERROR
    enum: SDL_ICONV_E2BIG
    enum: SDL_ICONV_EILSEQ
    enum: SDL_ICONV_EINVAL
    enum: SDL_iconv_t
    enum: SDL_iconv_open
    enum: SDL_iconv_close
    enum: SDL_iconv_utf8_locale
    enum: SDL_iconv_utf8_ucs2
    enum: SDL_iconv_utf8_ucs4
    enum: C_LINKAGE
    enum: _begin_code_h
    enum: _SDL_assert_h
    enum: _begin_code_h
    enum: SDL_ASSERT_LEVEL
    enum: SDL_TriggerBreakpoint
    enum: SDL_FUNCTION
    enum: SDL_FILE
    enum: SDL_LINE
    enum: SDL_disabled_assert
    enum: SDL_enabled_assert
    enum: SDL_assert
    enum: SDL_assert_release
    enum: SDL_assert_paranoid
    enum: _SDL_atomic_h_
    enum: _begin_code_h
    enum: SDL_CompilerBarrier
    enum: SDL_AtomicCAS
    enum: SDL_AtomicCASPtr
    enum: SDL_AtomicIncRef
    enum: SDL_AtomicDecRef
    enum: _SDL_audio_h
    enum: _SDL_error_h
    enum: _begin_code_h
    enum: SDL_OutOfMemory
    enum: SDL_Unsupported
    enum: _SDL_endian_h
    enum: SDL_LIL_ENDIAN
    enum: SDL_BIG_ENDIAN
    enum: SDL_BYTEORDER
    enum: _begin_code_h
    enum: SDL_SwapLE16
    enum: SDL_SwapLE32
    enum: SDL_SwapLE64
    enum: SDL_SwapFloatLE
    enum: SDL_SwapBE16
    enum: SDL_SwapBE32
    enum: SDL_SwapBE64
    enum: SDL_SwapFloatBE
    enum: _SDL_mutex_h
    enum: _begin_code_h
    enum: SDL_MUTEX_TIMEDOUT
    enum: SDL_MUTEX_MAXWAIT
    enum: SDL_LockMutex
    enum: SDL_UnlockMutex
    enum: _SDL_thread_h
    enum: _begin_code_h
    enum: _SDL_rwops_h
    enum: _begin_code_h
    enum: RW_SEEK_SET
    enum: RW_SEEK_CUR
    enum: RW_SEEK_END
    enum: SDL_RWseek
    enum: SDL_RWtell
    enum: SDL_RWread
    enum: SDL_RWwrite
    enum: SDL_RWclose
    enum: _begin_code_h
    enum: SDL_AUDIO_MASK_BITSIZE
    enum: SDL_AUDIO_MASK_DATATYPE
    enum: SDL_AUDIO_MASK_ENDIAN
    enum: SDL_AUDIO_MASK_SIGNED
    enum: SDL_AUDIO_BITSIZE
    enum: SDL_AUDIO_ISFLOAT
    enum: SDL_AUDIO_ISBIGENDIAN
    enum: SDL_AUDIO_ISSIGNED
    enum: SDL_AUDIO_ISINT
    enum: SDL_AUDIO_ISLITTLEENDIAN
    enum: SDL_AUDIO_ISUNSIGNED
    enum: AUDIO_U8
    enum: AUDIO_S8
    enum: AUDIO_U16LSB
    enum: AUDIO_S16LSB
    enum: AUDIO_U16MSB
    enum: AUDIO_S16MSB
    enum: AUDIO_U16
    enum: AUDIO_S16
    enum: AUDIO_S32LSB
    enum: AUDIO_S32MSB
    enum: AUDIO_S32
    enum: AUDIO_F32LSB
    enum: AUDIO_F32MSB
    enum: AUDIO_F32
    enum: AUDIO_U16SYS
    enum: AUDIO_S16SYS
    enum: AUDIO_S32SYS
    enum: AUDIO_F32SYS
    enum: SDL_AUDIO_ALLOW_FREQUENCY_CHANGE
    enum: SDL_AUDIO_ALLOW_FORMAT_CHANGE
    enum: SDL_AUDIO_ALLOW_CHANNELS_CHANGE
    enum: SDL_AUDIO_ALLOW_ANY_CHANGE
    enum: SDL_LoadWAV
    enum: SDL_MIX_MAXVOLUME
    enum: _SDL_clipboard_h
    enum: _begin_code_h
    enum: _SDL_cpuinfo_h
    enum: _begin_code_h
    enum: SDL_CACHELINE_SIZE
    enum: _SDL_events_h
    enum: _SDL_video_h
    enum: _SDL_pixels_h
    enum: _begin_code_h
    enum: SDL_ALPHA_OPAQUE
    enum: SDL_ALPHA_TRANSPARENT
    enum: SDL_DEFINE_PIXELFOURCC
    enum: SDL_DEFINE_PIXELFORMAT
    enum: SDL_PIXELTYPE
    enum: SDL_PIXELORDER
    enum: SDL_PIXELLAYOUT
    enum: SDL_BITSPERPIXEL
    enum: SDL_BYTESPERPIXEL
    enum: SDL_ISPIXELFORMAT_INDEXED
    enum: SDL_ISPIXELFORMAT_ALPHA
    enum: SDL_ISPIXELFORMAT_FOURCC
    enum: SDL_Colour
    enum: _SDL_rect_h
    enum: _begin_code_h
    enum: SDL_RectEmpty
    enum: SDL_RectEquals
    enum: _SDL_surface_h
    enum: _SDL_blendmode_h
    enum: _begin_code_h
    enum: _begin_code_h
    enum: SDL_PREALLOC
    enum: SDL_RLEACCEL
    enum: SDL_DONTFREE
    enum: SDL_MUSTLOCK
    SDL_Surface* SDL_LoadBMP(const char* file)
    enum: SDL_SaveBMP
    int SDL_BlitSurface(SDL_Surface* src, const SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect)
    enum: SDL_BlitScaled
    enum: _begin_code_h
    enum: SDL_WINDOWPOS_UNDEFINED_MASK
    enum: SDL_WINDOWPOS_UNDEFINED_DISPLAY
    enum: SDL_WINDOWPOS_UNDEFINED
    enum: SDL_WINDOWPOS_ISUNDEFINED
    enum: SDL_WINDOWPOS_CENTERED_MASK
    enum: SDL_WINDOWPOS_CENTERED_DISPLAY
    enum: SDL_WINDOWPOS_CENTERED
    enum: SDL_WINDOWPOS_ISCENTERED
    enum: _SDL_keyboard_h
    enum: _SDL_keycode_h
    enum: _SDL_scancode_h
    enum: SDLK_SCANCODE_MASK
    enum: SDL_SCANCODE_TO_KEYCODE
    enum: KMOD_CTRL
    enum: KMOD_SHIFT
    enum: KMOD_ALT
    enum: KMOD_GUI
    enum: _begin_code_h
    enum: _SDL_mouse_h
    enum: _begin_code_h
    enum: SDL_BUTTON
    enum: SDL_BUTTON_LEFT
    enum: SDL_BUTTON_MIDDLE
    enum: SDL_BUTTON_RIGHT
    enum: SDL_BUTTON_X1
    enum: SDL_BUTTON_X2
    enum: SDL_BUTTON_LMASK
    enum: SDL_BUTTON_MMASK
    enum: SDL_BUTTON_RMASK
    enum: SDL_BUTTON_X1MASK
    enum: SDL_BUTTON_X2MASK
    enum: _SDL_joystick_h
    enum: _begin_code_h
    enum: SDL_HAT_CENTERED
    enum: SDL_HAT_UP
    enum: SDL_HAT_RIGHT
    enum: SDL_HAT_DOWN
    enum: SDL_HAT_LEFT
    enum: SDL_HAT_RIGHTUP
    enum: SDL_HAT_RIGHTDOWN
    enum: SDL_HAT_LEFTUP
    enum: SDL_HAT_LEFTDOWN
    enum: _SDL_quit_h
    enum: SDL_QuitRequested
    enum: _SDL_gesture_h
    enum: _SDL_touch_h
    enum: _begin_code_h
    enum: _begin_code_h
    enum: _begin_code_h
    enum: SDL_RELEASED
    enum: SDL_PRESSED
    enum: SDL_TEXTEDITINGEVENT_TEXT_SIZE
    enum: SDL_TEXTINPUTEVENT_TEXT_SIZE
    enum: SDL_QUERY
    enum: SDL_IGNORE
    enum: SDL_DISABLE
    enum: SDL_ENABLE
    enum: SDL_GetEventState
    enum: _SDL_hints_h
    enum: _begin_code_h
    enum: SDL_HINT_FRAMEBUFFER_ACCELERATION
    enum: SDL_HINT_RENDER_DRIVER
    enum: SDL_HINT_RENDER_OPENGL_SHADERS
    enum: SDL_HINT_RENDER_SCALE_QUALITY
    enum: SDL_HINT_RENDER_VSYNC
    enum: SDL_HINT_IDLE_TIMER_DISABLED
    enum: SDL_HINT_ORIENTATIONS
    enum: _SDL_loadso_h
    enum: _begin_code_h
    enum: _SDL_log_h
    enum: _begin_code_h
    enum: SDL_MAX_LOG_MESSAGE
    enum: _SDL_power_h
    enum: _begin_code_h
    enum: _SDL_render_h
    enum: _begin_code_h
    enum: _SDL_timer_h
    enum: _begin_code_h
    enum: _SDL_version_h
    enum: _begin_code_h
    enum: SDL_MAJOR_VERSION
    enum: SDL_MINOR_VERSION
    enum: SDL_PATCHLEVEL
    enum: SDL_VERSION
    enum: SDL_VERSIONNUM
    enum: SDL_COMPILEDVERSION
    enum: SDL_VERSION_ATLEAST
    enum: _SDL_compat_h
    enum: _begin_code_h
    enum: SDL_SWSURFACE
    enum: SDL_SRCALPHA
    enum: SDL_SRCCOLORKEY
    enum: SDL_ANYFORMAT
    enum: SDL_HWPALETTE
    enum: SDL_DOUBLEBUF
    enum: SDL_FULLSCREEN
    enum: SDL_RESIZABLE
    enum: SDL_NOFRAME
    enum: SDL_OPENGL
    enum: SDL_HWSURFACE
    enum: SDL_ASYNCBLIT
    enum: SDL_RLEACCELOK
    enum: SDL_HWACCEL
    enum: SDL_APPMOUSEFOCUS
    enum: SDL_APPINPUTFOCUS
    enum: SDL_APPACTIVE
    enum: SDL_LOGPAL
    enum: SDL_PHYSPAL
    enum: SDL_ACTIVEEVENT
    enum: SDL_VIDEORESIZE
    enum: SDL_VIDEOEXPOSE
    enum: SDL_ACTIVEEVENTMASK
    enum: SDL_VIDEORESIZEMASK
    enum: SDL_VIDEOEXPOSEMASK
    enum: SDL_WINDOWEVENTMASK
    enum: SDL_KEYDOWNMASK
    enum: SDL_KEYUPMASK
    enum: SDL_KEYEVENTMASK
    enum: SDL_TEXTEDITINGMASK
    enum: SDL_TEXTINPUTMASK
    enum: SDL_MOUSEMOTIONMASK
    enum: SDL_MOUSEBUTTONDOWNMASK
    enum: SDL_MOUSEBUTTONUPMASK
    enum: SDL_MOUSEWHEELMASK
    enum: SDL_MOUSEEVENTMASK
    enum: SDL_JOYAXISMOTIONMASK
    enum: SDL_JOYBALLMOTIONMASK
    enum: SDL_JOYHATMOTIONMASK
    enum: SDL_JOYBUTTONDOWNMASK
    enum: SDL_JOYBUTTONUPMASK
    enum: SDL_JOYEVENTMASK
    enum: SDL_QUITMASK
    enum: SDL_SYSWMEVENTMASK
    enum: SDL_PROXIMITYINMASK
    enum: SDL_PROXIMITYOUTMASK
    enum: SDL_ALLEVENTS
    enum: SDL_BUTTON_WHEELUP
    enum: SDL_BUTTON_WHEELDOWN
    enum: SDL_DEFAULT_REPEAT_DELAY
    enum: SDL_DEFAULT_REPEAT_INTERVAL
    enum: SDL_YV12_OVERLAY
    enum: SDL_IYUV_OVERLAY
    enum: SDL_YUY2_OVERLAY
    enum: SDL_UYVY_OVERLAY
    enum: SDL_YVYU_OVERLAY
    enum: SDL_keysym
    enum: SDL_KeySym
    enum: SDL_scancode
    enum: SDL_ScanCode
    enum: SDLKey
    enum: SDLMod
    enum: SDLK_KP0
    enum: SDLK_KP1
    enum: SDLK_KP2
    enum: SDLK_KP3
    enum: SDLK_KP4
    enum: SDLK_KP5
    enum: SDLK_KP6
    enum: SDLK_KP7
    enum: SDLK_KP8
    enum: SDLK_KP9
    enum: SDLK_NUMLOCK
    enum: SDLK_SCROLLOCK
    enum: SDLK_PRINT
    enum: SDLK_LMETA
    enum: SDLK_RMETA
    enum: KMOD_LMETA
    enum: KMOD_RMETA
    enum: KMOD_META
    enum: SDLK_LSUPER
    enum: SDLK_RSUPER
    enum: SDLK_COMPOSE
    enum: SDLK_BREAK
    enum: SDLK_EURO
    enum: SDL_SetModuleHandle
    enum: SDL_AllocSurface
    enum: SDL_KillThread
    enum: SDL_TIMESLICE
    enum: TIMER_RESOLUTION
    enum: _begin_code_h
    enum: SDL_INIT_TIMER
    enum: SDL_INIT_AUDIO
    enum: SDL_INIT_VIDEO
    enum: SDL_INIT_JOYSTICK
    enum: SDL_INIT_HAPTIC
    enum: SDL_INIT_NOPARACHUTE
    enum: SDL_INIT_EVERYTHING
    char* SDL_GetPlatform()
    cdef enum Enum_temp_random_970738:
        SDL_FALSE
        SDL_TRUE
    ctypedef Enum_temp_random_970738 SDL_bool
    ctypedef int8_t Sint8
    ctypedef uint8_t Uint8
    ctypedef int16_t Sint16
    ctypedef uint16_t Uint16
    ctypedef int32_t Sint32
    ctypedef uint32_t Uint32
    ctypedef int64_t Sint64
    ctypedef uint64_t Uint64
    ctypedef int SDL_dummy_uint8[1]
    ctypedef int SDL_dummy_sint8[1]
    ctypedef int SDL_dummy_uint16[1]
    ctypedef int SDL_dummy_sint16[1]
    ctypedef int SDL_dummy_uint32[1]
    ctypedef int SDL_dummy_sint32[1]
    ctypedef int SDL_dummy_uint64[1]
    ctypedef int SDL_dummy_sint64[1]
    cdef enum Enum_temp_random_599645:
        DUMMY_ENUM_VALUE
    ctypedef Enum_temp_random_599645 SDL_DUMMY_ENUM
    ctypedef int SDL_dummy_enum[1]
    size_t SDL_wcslen(wchar_t *string)
    size_t SDL_wcslcpy(wchar_t *dst, wchar_t *src, size_t maxlen)
    size_t SDL_wcslcat(wchar_t *dst, wchar_t *src, size_t maxlen)
    size_t SDL_utf8strlcpy(char *dst, char *src, size_t dst_bytes)
    char* SDL_strrev(char *string)
    char* SDL_strupr(char *string)
    char* SDL_strlwr(char *string)
    char* SDL_ltoa(long value, char *string, int radix)
    char* SDL_ultoa(unsigned long value, char *string, int radix)
    char* SDL_lltoa(Sint64 value, char *string, int radix)
    char* SDL_ulltoa(Uint64 value, char *string, int radix)
    size_t SDL_iconv(iconv_t cd, char ** inbuf, size_t *inbytesleft, char ** outbuf, size_t *outbytesleft)
    char* SDL_iconv_string(char *tocode, char *fromcode, char *inbuf, size_t inbytesleft)
    int SDL_main(int argc, char ** argv)
    cdef enum Enum_temp_random_632324:
        SDL_ASSERTION_RETRY
        SDL_ASSERTION_BREAK
        SDL_ASSERTION_ABORT
        SDL_ASSERTION_IGNORE
        SDL_ASSERTION_ALWAYS_IGNORE
    ctypedef Enum_temp_random_632324 SDL_assert_state
    cdef struct SDL_assert_data:
        int always_ignore
        unsigned int trigger_count
        char *condition
        char *filename
        int linenum
        char *function
        SDL_assert_data *next
    SDL_assert_state SDL_ReportAssertion(SDL_assert_data *, char *, char *, int )
    ctypedef SDL_assert_state (*SDL_AssertionHandler)(SDL_assert_data* data, void* userdata)
    void SDL_SetAssertionHandler(SDL_assert_state (*handler)(), void *userdata)
    SDL_assert_data* SDL_GetAssertionReport()
    void SDL_ResetAssertionReport()
    ctypedef int SDL_SpinLock
    SDL_bool SDL_AtomicTryLock(SDL_SpinLock *lock)
    void SDL_AtomicLock(SDL_SpinLock *lock)
    void SDL_AtomicUnlock(SDL_SpinLock *lock)
    cdef struct Struct_temp_random_718135:
        int value
    ctypedef Struct_temp_random_718135 SDL_atomic_t
    SDL_bool SDL_AtomicCAS_(SDL_atomic_t *a, int oldval, int newval)
    int SDL_AtomicSet(SDL_atomic_t *a, int v)
    int SDL_AtomicGet(SDL_atomic_t *a)
    int SDL_AtomicAdd(SDL_atomic_t *a, int v)
    SDL_bool SDL_AtomicCASPtr_(void ** a, void *oldval, void *newval)
    void* SDL_AtomicSetPtr(void ** a, void *v)
    void* SDL_AtomicGetPtr(void ** a)
    void SDL_SetError(char *fmt)
    char* SDL_GetError()
    void SDL_ClearError()
    cdef enum Enum_temp_random_123493:
        SDL_ENOMEM
        SDL_EFREAD
        SDL_EFWRITE
        SDL_EFSEEK
        SDL_UNSUPPORTED
        SDL_LASTERROR
    ctypedef Enum_temp_random_123493 SDL_errorcode
    void SDL_Error(SDL_errorcode code)
    Uint16 SDL_Swap16(Uint16 x)
    Uint32 SDL_Swap32(Uint32 x)
    Uint64 SDL_Swap64(Uint64 x)
    float SDL_SwapFloat(float x)
    cdef struct SDL_mutex:
        pass
    SDL_mutex* SDL_CreateMutex()
    int SDL_mutexP(SDL_mutex *mutex)
    int SDL_mutexV(SDL_mutex *mutex)
    void SDL_DestroyMutex(SDL_mutex *mutex)
    cdef struct SDL_semaphore:
        pass
    ctypedef SDL_semaphore SDL_sem
    SDL_sem* SDL_CreateSemaphore(Uint32 initial_value)
    void SDL_DestroySemaphore(SDL_sem *sem)
    int SDL_SemWait(SDL_sem *sem)
    int SDL_SemTryWait(SDL_sem *sem)
    int SDL_SemWaitTimeout(SDL_sem *sem, Uint32 ms)
    int SDL_SemPost(SDL_sem *sem)
    Uint32 SDL_SemValue(SDL_sem *sem)
    cdef struct SDL_cond:
        pass
    SDL_cond* SDL_CreateCond()
    void SDL_DestroyCond(SDL_cond *cond)
    int SDL_CondSignal(SDL_cond *cond)
    int SDL_CondBroadcast(SDL_cond *cond)
    int SDL_CondWait(SDL_cond *cond, SDL_mutex *mutex)
    int SDL_CondWaitTimeout(SDL_cond *cond, SDL_mutex *mutex, Uint32 ms)
    cdef struct SDL_Thread:
        pass
    ctypedef unsigned long SDL_threadID
    cdef enum Enum_temp_random_234073:
        SDL_THREAD_PRIORITY_LOW
        SDL_THREAD_PRIORITY_NORMAL
        SDL_THREAD_PRIORITY_HIGH
    ctypedef Enum_temp_random_234073 SDL_ThreadPriority
    ctypedef int (*SDL_ThreadFunction)(void* data)
    SDL_Thread* SDL_CreateThread(int (*fn)(), char *name, void *data)
    char* SDL_GetThreadName(SDL_Thread *thread)
    SDL_threadID SDL_ThreadID()
    SDL_threadID SDL_GetThreadID(SDL_Thread *thread)
    int SDL_SetThreadPriority(SDL_ThreadPriority priority)
    void SDL_WaitThread(SDL_Thread *thread, int *status)
    cdef struct Struct_temp_random_697984:
        SDL_bool autoclose
        FILE *fp
    cdef struct Struct_temp_random_614396:
        Uint8 *base
        Uint8 *here
        Uint8 *stop
    cdef struct Struct_temp_random_176105:
        void *data1
    cdef union Union_temp_random_505832:
        Struct_temp_random_697984 stdio
        Struct_temp_random_614396 mem
        Struct_temp_random_176105 unknown
    cdef struct SDL_RWops:
        long (*seek)(SDL_RWops* context, long offset, int whence)
        unsigned long (*read)(SDL_RWops* context, void* ptr, size_t size, size_t maxnum)
        unsigned long (*write)(SDL_RWops* context, void* ptr, size_t size, size_t num)
        int (*close)(SDL_RWops* context)
        Uint32 type
        Union_temp_random_505832 hidden
    SDL_RWops* SDL_RWFromFile(char *file, char *mode)
    SDL_RWops* SDL_RWFromFP(FILE *fp, SDL_bool autoclose)
    SDL_RWops* SDL_RWFromMem(void *mem, int size)
    SDL_RWops* SDL_RWFromConstMem(void *mem, int size)
    SDL_RWops* SDL_AllocRW()
    void SDL_FreeRW(SDL_RWops *area)
    Uint16 SDL_ReadLE16(SDL_RWops *src)
    Uint16 SDL_ReadBE16(SDL_RWops *src)
    Uint32 SDL_ReadLE32(SDL_RWops *src)
    Uint32 SDL_ReadBE32(SDL_RWops *src)
    Uint64 SDL_ReadLE64(SDL_RWops *src)
    Uint64 SDL_ReadBE64(SDL_RWops *src)
    size_t SDL_WriteLE16(SDL_RWops *dst, Uint16 value)
    size_t SDL_WriteBE16(SDL_RWops *dst, Uint16 value)
    size_t SDL_WriteLE32(SDL_RWops *dst, Uint32 value)
    size_t SDL_WriteBE32(SDL_RWops *dst, Uint32 value)
    size_t SDL_WriteLE64(SDL_RWops *dst, Uint64 value)
    size_t SDL_WriteBE64(SDL_RWops *dst, Uint64 value)
    ctypedef Uint16 SDL_AudioFormat
    ctypedef void (*SDL_AudioCallback)(void* userdata, Uint8* stream, int len)
    cdef struct SDL_AudioSpec:
        int freq
        SDL_AudioFormat format
        Uint8 channels
        Uint8 silence
        Uint16 samples
        Uint16 padding
        Uint32 size
        void (*callback)()
        void *userdata
    cdef struct SDL_AudioCVT:
        pass
    ctypedef void (*SDL_AudioFilter)(SDL_AudioCVT* cvt, SDL_AudioFormat format)
    cdef struct SDL_AudioCVT:
        int needed
        SDL_AudioFormat src_format
        SDL_AudioFormat dst_format
        double rate_incr
        Uint8 *buf
        int len
        int len_cvt
        int len_mult
        double len_ratio
        SDL_AudioFilter filters[10]
        int filter_index
    int SDL_GetNumAudioDrivers()
    char* SDL_GetAudioDriver(int index)
    int SDL_AudioInit(char *driver_name)
    void SDL_AudioQuit()
    char* SDL_GetCurrentAudioDriver()
    int SDL_OpenAudio(SDL_AudioSpec *desired, SDL_AudioSpec *obtained)
    ctypedef Uint32 SDL_AudioDeviceID
    int SDL_GetNumAudioDevices(int iscapture)
    char* SDL_GetAudioDeviceName(int index, int iscapture)
    SDL_AudioDeviceID SDL_OpenAudioDevice(char *device, int iscapture, SDL_AudioSpec *desired, SDL_AudioSpec *obtained, int allowed_changes)
    cdef enum Enum_temp_random_404053:
        SDL_AUDIO_STOPPED
        SDL_AUDIO_PLAYING
        SDL_AUDIO_PAUSED
    ctypedef Enum_temp_random_404053 SDL_AudioStatus
    SDL_AudioStatus SDL_GetAudioStatus()
    SDL_AudioStatus SDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev)
    void SDL_PauseAudio(int pause_on)
    void SDL_PauseAudioDevice(SDL_AudioDeviceID dev, int pause_on)
    SDL_AudioSpec* SDL_LoadWAV_RW(SDL_RWops *src, int freesrc, SDL_AudioSpec *spec, Uint8 ** audio_buf, Uint32 *audio_len)
    void SDL_FreeWAV(Uint8 *audio_buf)
    int SDL_BuildAudioCVT(SDL_AudioCVT *cvt, SDL_AudioFormat src_format, Uint8 src_channels, int src_rate, SDL_AudioFormat dst_format, Uint8 dst_channels, int dst_rate)
    int SDL_ConvertAudio(SDL_AudioCVT *cvt)
    void SDL_MixAudio(Uint8 *dst, Uint8 *src, Uint32 len, int volume)
    void SDL_MixAudioFormat(Uint8 *dst, Uint8 *src, SDL_AudioFormat format, Uint32 len, int volume)
    void SDL_LockAudio()
    void SDL_LockAudioDevice(SDL_AudioDeviceID dev)
    void SDL_UnlockAudio()
    void SDL_UnlockAudioDevice(SDL_AudioDeviceID dev)
    void SDL_CloseAudio()
    void SDL_CloseAudioDevice(SDL_AudioDeviceID dev)
    int SDL_AudioDeviceConnected(SDL_AudioDeviceID dev)
    int SDL_SetClipboardText(char *text)
    char* SDL_GetClipboardText()
    SDL_bool SDL_HasClipboardText()
    int SDL_GetCPUCount()
    int SDL_GetCPUCacheLineSize()
    SDL_bool SDL_HasRDTSC()
    SDL_bool SDL_HasAltiVec()
    SDL_bool SDL_HasMMX()
    SDL_bool SDL_Has3DNow()
    SDL_bool SDL_HasSSE()
    SDL_bool SDL_HasSSE2()
    SDL_bool SDL_HasSSE3()
    SDL_bool SDL_HasSSE41()
    SDL_bool SDL_HasSSE42()
    cdef enum Enum_temp_random_060870:
        SDL_PIXELTYPE_UNKNOWN
        SDL_PIXELTYPE_INDEX1
        SDL_PIXELTYPE_INDEX4
        SDL_PIXELTYPE_INDEX8
        SDL_PIXELTYPE_PACKED8
        SDL_PIXELTYPE_PACKED16
        SDL_PIXELTYPE_PACKED32
        SDL_PIXELTYPE_ARRAYU8
        SDL_PIXELTYPE_ARRAYU16
        SDL_PIXELTYPE_ARRAYU32
        SDL_PIXELTYPE_ARRAYF16
        SDL_PIXELTYPE_ARRAYF32
    cdef enum Enum_temp_random_990265:
        SDL_BITMAPORDER_NONE
        SDL_BITMAPORDER_4321
        SDL_BITMAPORDER_1234
    cdef enum Enum_temp_random_451976:
        SDL_PACKEDORDER_NONE
        SDL_PACKEDORDER_XRGB
        SDL_PACKEDORDER_RGBX
        SDL_PACKEDORDER_ARGB
        SDL_PACKEDORDER_RGBA
        SDL_PACKEDORDER_XBGR
        SDL_PACKEDORDER_BGRX
        SDL_PACKEDORDER_ABGR
        SDL_PACKEDORDER_BGRA
    cdef enum Enum_temp_random_617275:
        SDL_ARRAYORDER_NONE
        SDL_ARRAYORDER_RGB
        SDL_ARRAYORDER_RGBA
        SDL_ARRAYORDER_ARGB
        SDL_ARRAYORDER_BGR
        SDL_ARRAYORDER_BGRA
        SDL_ARRAYORDER_ABGR
    cdef enum Enum_temp_random_336444:
        SDL_PACKEDLAYOUT_NONE
        SDL_PACKEDLAYOUT_332
        SDL_PACKEDLAYOUT_4444
        SDL_PACKEDLAYOUT_1555
        SDL_PACKEDLAYOUT_5551
        SDL_PACKEDLAYOUT_565
        SDL_PACKEDLAYOUT_8888
        SDL_PACKEDLAYOUT_2101010
        SDL_PACKEDLAYOUT_1010102
    cdef enum Enum_temp_random_897813:
        SDL_PIXELFORMAT_UNKNOWN
        SDL_PIXELFORMAT_INDEX1LSB
        SDL_PIXELFORMAT_INDEX1MSB
        SDL_PIXELFORMAT_INDEX4LSB
        SDL_PIXELFORMAT_INDEX4MSB
        SDL_PIXELFORMAT_INDEX8
        SDL_PIXELFORMAT_RGB332
        SDL_PIXELFORMAT_RGB444
        SDL_PIXELFORMAT_RGB555
        SDL_PIXELFORMAT_BGR555
        SDL_PIXELFORMAT_ARGB4444
        SDL_PIXELFORMAT_RGBA4444
        SDL_PIXELFORMAT_ABGR4444
        SDL_PIXELFORMAT_BGRA4444
        SDL_PIXELFORMAT_ARGB1555
        SDL_PIXELFORMAT_RGBA5551
        SDL_PIXELFORMAT_ABGR1555
        SDL_PIXELFORMAT_BGRA5551
        SDL_PIXELFORMAT_RGB565
        SDL_PIXELFORMAT_BGR565
        SDL_PIXELFORMAT_RGB24
        SDL_PIXELFORMAT_BGR24
        SDL_PIXELFORMAT_RGB888
        SDL_PIXELFORMAT_RGBX8888
        SDL_PIXELFORMAT_BGR888
        SDL_PIXELFORMAT_BGRX8888
        SDL_PIXELFORMAT_ARGB8888
        SDL_PIXELFORMAT_RGBA8888
        SDL_PIXELFORMAT_ABGR8888
        SDL_PIXELFORMAT_BGRA8888
        SDL_PIXELFORMAT_ARGB2101010
        SDL_PIXELFORMAT_YV12
        SDL_PIXELFORMAT_IYUV
        SDL_PIXELFORMAT_YUY2
        SDL_PIXELFORMAT_UYVY
        SDL_PIXELFORMAT_YVYU

    cdef struct SDL_Color:
        Uint8 r
        Uint8 g
        Uint8 b
        Uint8 a

    cdef struct SDL_Palette:
        int ncolors
        SDL_Color *colors
        Uint32 version
        int refcount

    cdef struct SDL_PixelFormat:
        Uint32 format
        SDL_Palette *palette
        Uint8 BitsPerPixel
        Uint8 BytesPerPixel
        Uint8 padding[2]
        Uint32 Rmask
        Uint32 Gmask
        Uint32 Bmask
        Uint32 Amask
        Uint8 Rloss
        Uint8 Gloss
        Uint8 Bloss
        Uint8 Aloss
        Uint8 Rshift
        Uint8 Gshift
        Uint8 Bshift
        Uint8 Ashift
        int refcount
        SDL_PixelFormat *next
    char* SDL_GetPixelFormatName(Uint32 format)
    SDL_bool SDL_PixelFormatEnumToMasks(Uint32 format, int *bpp, Uint32 *Rmask, Uint32 *Gmask, Uint32 *Bmask, Uint32 *Amask)
    Uint32 SDL_MasksToPixelFormatEnum(int bpp, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)
    SDL_PixelFormat* SDL_AllocFormat(Uint32 pixel_format)
    void SDL_FreeFormat(SDL_PixelFormat *format)
    SDL_Palette* SDL_AllocPalette(int ncolors)
    int SDL_SetPixelFormatPalette(SDL_PixelFormat *format, SDL_Palette *palette)
    int SDL_SetPaletteColors(SDL_Palette *palette, SDL_Color *colors, int firstcolor, int ncolors)
    void SDL_FreePalette(SDL_Palette *palette)
    Uint32 SDL_MapRGB(SDL_PixelFormat *format, Uint8 r, Uint8 g, Uint8 b)
    Uint32 SDL_MapRGBA(SDL_PixelFormat *format, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
    void SDL_GetRGB(Uint32 pixel, SDL_PixelFormat *format, Uint8 *r, Uint8 *g, Uint8 *b)
    void SDL_GetRGBA(Uint32 pixel, SDL_PixelFormat *format, Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a)
    void SDL_CalculateGammaRamp(float gamma, Uint16 *ramp)
    cdef struct Struct_temp_random_429112:
        int x
        int y
    ctypedef Struct_temp_random_429112 SDL_Point
    cdef struct SDL_Rect:
        int x
        int y
        int w
        int h
    SDL_bool SDL_HasIntersection(SDL_Rect *A, SDL_Rect *B)
    SDL_bool SDL_IntersectRect(SDL_Rect *A, SDL_Rect *B, SDL_Rect *result)
    void SDL_UnionRect(SDL_Rect *A, SDL_Rect *B, SDL_Rect *result)
    SDL_bool SDL_EnclosePoints(SDL_Point *points, int count, SDL_Rect *clip, SDL_Rect *result)
    SDL_bool SDL_IntersectRectAndLine(SDL_Rect *rect, int *X1, int *Y1, int *X2, int *Y2)
    cdef enum Enum_temp_random_990653:
        SDL_BLENDMODE_NONE
        SDL_BLENDMODE_BLEND
        SDL_BLENDMODE_ADD
        SDL_BLENDMODE_MOD
    ctypedef Enum_temp_random_990653 SDL_BlendMode
    cdef struct SDL_BlitMap:
        pass
    cdef struct SDL_Surface:
        Uint32 flags
        SDL_PixelFormat *format
        int w
        int h
        int pitch
        void *pixels
        void *userdata
        int locked
        void *lock_data
        SDL_Rect clip_rect
        SDL_BlitMap *map
        int refcount
    ctypedef int (*SDL_blit)(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect)
    SDL_Surface* SDL_CreateRGBSurface(Uint32 flags, int width, int height, int depth, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)
    SDL_Surface* SDL_CreateRGBSurfaceFrom(void *pixels, int width, int height, int depth, int pitch, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)
    void SDL_FreeSurface(SDL_Surface *surface)
    int SDL_SetSurfacePalette(SDL_Surface *surface, SDL_Palette *palette)
    int SDL_LockSurface(SDL_Surface *surface)
    void SDL_UnlockSurface(SDL_Surface *surface)
    SDL_Surface* SDL_LoadBMP_RW(SDL_RWops *src, int freesrc)
    int SDL_SaveBMP_RW(SDL_Surface *surface, SDL_RWops *dst, int freedst)
    int SDL_SetSurfaceRLE(SDL_Surface *surface, int flag)
    int SDL_SetColorKey(SDL_Surface *surface, int flag, Uint32 key)
    int SDL_GetColorKey(SDL_Surface *surface, Uint32 *key)
    int SDL_SetSurfaceColorMod(SDL_Surface *surface, Uint8 r, Uint8 g, Uint8 b)
    int SDL_GetSurfaceColorMod(SDL_Surface *surface, Uint8 *r, Uint8 *g, Uint8 *b)
    int SDL_SetSurfaceAlphaMod(SDL_Surface *surface, Uint8 alpha)
    int SDL_GetSurfaceAlphaMod(SDL_Surface *surface, Uint8 *alpha)
    int SDL_SetSurfaceBlendMode(SDL_Surface *surface, SDL_BlendMode blendMode)
    int SDL_GetSurfaceBlendMode(SDL_Surface *surface, SDL_BlendMode *blendMode)
    SDL_bool SDL_SetClipRect(SDL_Surface *surface, SDL_Rect *rect)
    void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect)
    SDL_Surface* SDL_ConvertSurface(SDL_Surface *src, SDL_PixelFormat *fmt, Uint32 flags)
    SDL_Surface* SDL_ConvertSurfaceFormat(SDL_Surface *src, Uint32 pixel_format, Uint32 flags)
    int SDL_ConvertPixels(int width, int height, Uint32 src_format, void *src, int src_pitch, Uint32 dst_format, void *dst, int dst_pitch)
    int SDL_FillRect(SDL_Surface *dst, SDL_Rect *rect, Uint32 color)
    int SDL_FillRects(SDL_Surface *dst, SDL_Rect *rects, int count, Uint32 color)
    int SDL_UpperBlit(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect)
    int SDL_LowerBlit(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect)
    int SDL_SoftStretch(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect)
    int SDL_UpperBlitScaled(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect)
    int SDL_LowerBlitScaled(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect)
    cdef struct Struct_temp_random_886508:
        Uint32 format
        int w
        int h
        int refresh_rate
        void *driverdata
    ctypedef Struct_temp_random_886508 SDL_DisplayMode
    cdef struct SDL_Window:
        pass
    cdef enum Enum_temp_random_307637:
        SDL_WINDOW_FULLSCREEN
        SDL_WINDOW_OPENGL
        SDL_WINDOW_SHOWN
        SDL_WINDOW_HIDDEN
        SDL_WINDOW_BORDERLESS
        SDL_WINDOW_RESIZABLE
        SDL_WINDOW_MINIMIZED
        SDL_WINDOW_MAXIMIZED
        SDL_WINDOW_INPUT_GRABBED
        SDL_WINDOW_INPUT_FOCUS
        SDL_WINDOW_MOUSE_FOCUS
        SDL_WINDOW_FOREIGN
    ctypedef Enum_temp_random_307637 SDL_WindowFlags
    cdef enum Enum_temp_random_068037:
        SDL_WINDOWEVENT_NONE
        SDL_WINDOWEVENT_SHOWN
        SDL_WINDOWEVENT_HIDDEN
        SDL_WINDOWEVENT_EXPOSED
        SDL_WINDOWEVENT_MOVED
        SDL_WINDOWEVENT_RESIZED
        SDL_WINDOWEVENT_SIZE_CHANGED
        SDL_WINDOWEVENT_MINIMIZED
        SDL_WINDOWEVENT_MAXIMIZED
        SDL_WINDOWEVENT_RESTORED
        SDL_WINDOWEVENT_ENTER
        SDL_WINDOWEVENT_LEAVE
        SDL_WINDOWEVENT_FOCUS_GAINED
        SDL_WINDOWEVENT_FOCUS_LOST
        SDL_WINDOWEVENT_CLOSE
    ctypedef Enum_temp_random_068037 SDL_WindowEventID
    ctypedef void *SDL_GLContext
    cdef enum Enum_temp_random_333345:
        SDL_GL_RED_SIZE
        SDL_GL_GREEN_SIZE
        SDL_GL_BLUE_SIZE
        SDL_GL_ALPHA_SIZE
        SDL_GL_BUFFER_SIZE
        SDL_GL_DOUBLEBUFFER
        SDL_GL_DEPTH_SIZE
        SDL_GL_STENCIL_SIZE
        SDL_GL_ACCUM_RED_SIZE
        SDL_GL_ACCUM_GREEN_SIZE
        SDL_GL_ACCUM_BLUE_SIZE
        SDL_GL_ACCUM_ALPHA_SIZE
        SDL_GL_STEREO
        SDL_GL_MULTISAMPLEBUFFERS
        SDL_GL_MULTISAMPLESAMPLES
        SDL_GL_ACCELERATED_VISUAL
        SDL_GL_RETAINED_BACKING
        SDL_GL_CONTEXT_MAJOR_VERSION
        SDL_GL_CONTEXT_MINOR_VERSION
    ctypedef Enum_temp_random_333345 SDL_GLattr
    int SDL_GetNumVideoDrivers()
    char* SDL_GetVideoDriver(int index)
    int SDL_VideoInit(char *driver_name)
    void SDL_VideoQuit()
    char* SDL_GetCurrentVideoDriver()
    int SDL_GetNumVideoDisplays()
    int SDL_GetDisplayBounds(int displayIndex, SDL_Rect *rect)
    int SDL_GetNumDisplayModes(int displayIndex)
    int SDL_GetDisplayMode(int displayIndex, int modeIndex, SDL_DisplayMode *mode)
    int SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode *mode)
    int SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode *mode)
    SDL_DisplayMode* SDL_GetClosestDisplayMode(int displayIndex, SDL_DisplayMode *mode, SDL_DisplayMode *closest)
    int SDL_GetWindowDisplay(SDL_Window *window)
    int SDL_SetWindowDisplayMode(SDL_Window *window, SDL_DisplayMode *mode)
    int SDL_GetWindowDisplayMode(SDL_Window *window, SDL_DisplayMode *mode)
    Uint32 SDL_GetWindowPixelFormat(SDL_Window *window)
    SDL_Window* SDL_CreateWindow(char *title, int x, int y, int w, int h, Uint32 flags)
    SDL_Window* SDL_CreateWindowFrom(void *data)
    Uint32 SDL_GetWindowID(SDL_Window *window)
    SDL_Window* SDL_GetWindowFromID(Uint32 id)
    Uint32 SDL_GetWindowFlags(SDL_Window *window)
    void SDL_SetWindowTitle(SDL_Window *window, char *title)
    char* SDL_GetWindowTitle(SDL_Window *window)
    void SDL_SetWindowIcon(SDL_Window *window, SDL_Surface *icon)
    void* SDL_SetWindowData(SDL_Window *window, char *name, void *userdata)
    void* SDL_GetWindowData(SDL_Window *window, char *name)
    void SDL_SetWindowPosition(SDL_Window *window, int x, int y)
    void SDL_GetWindowPosition(SDL_Window *window, int *x, int *y)
    void SDL_SetWindowSize(SDL_Window *window, int w, int h)
    void SDL_GetWindowSize(SDL_Window *window, int *w, int *h)
    void SDL_ShowWindow(SDL_Window *window)
    void SDL_HideWindow(SDL_Window *window)
    void SDL_RaiseWindow(SDL_Window *window)
    void SDL_MaximizeWindow(SDL_Window *window)
    void SDL_MinimizeWindow(SDL_Window *window)
    void SDL_RestoreWindow(SDL_Window *window)
    int SDL_SetWindowFullscreen(SDL_Window *window, SDL_bool fullscreen)
    SDL_Surface* SDL_GetWindowSurface(SDL_Window *window)
    int SDL_UpdateWindowSurface(SDL_Window *window)
    int SDL_UpdateWindowSurfaceRects(SDL_Window *window, SDL_Rect *rects, int numrects)
    void SDL_SetWindowGrab(SDL_Window *window, SDL_bool grabbed)
    SDL_bool SDL_GetWindowGrab(SDL_Window *window)
    int SDL_SetWindowBrightness(SDL_Window *window, float brightness)
    float SDL_GetWindowBrightness(SDL_Window *window)
    int SDL_SetWindowGammaRamp(SDL_Window *window, Uint16 *red, Uint16 *green, Uint16 *blue)
    int SDL_GetWindowGammaRamp(SDL_Window *window, Uint16 *red, Uint16 *green, Uint16 *blue)
    void SDL_DestroyWindow(SDL_Window *window)
    SDL_bool SDL_IsScreenSaverEnabled()
    void SDL_EnableScreenSaver()
    void SDL_DisableScreenSaver()
    int SDL_GL_LoadLibrary(char *path)
    void* SDL_GL_GetProcAddress(char *proc)
    void SDL_GL_UnloadLibrary()
    SDL_bool SDL_GL_ExtensionSupported(char *extension)
    int SDL_GL_SetAttribute(SDL_GLattr attr, int value)
    int SDL_GL_GetAttribute(SDL_GLattr attr, int *value)
    SDL_GLContext SDL_GL_CreateContext(SDL_Window *window)
    int SDL_GL_MakeCurrent(SDL_Window *window, SDL_GLContext context)
    int SDL_GL_SetSwapInterval(int interval)
    int SDL_GL_GetSwapInterval()
    void SDL_GL_SwapWindow(SDL_Window *window)
    void SDL_GL_DeleteContext(SDL_GLContext context)
    cdef enum Enum_temp_random_257052:
        SDL_SCANCODE_UNKNOWN
        SDL_SCANCODE_A
        SDL_SCANCODE_B
        SDL_SCANCODE_C
        SDL_SCANCODE_D
        SDL_SCANCODE_E
        SDL_SCANCODE_F
        SDL_SCANCODE_G
        SDL_SCANCODE_H
        SDL_SCANCODE_I
        SDL_SCANCODE_J
        SDL_SCANCODE_K
        SDL_SCANCODE_L
        SDL_SCANCODE_M
        SDL_SCANCODE_N
        SDL_SCANCODE_O
        SDL_SCANCODE_P
        SDL_SCANCODE_Q
        SDL_SCANCODE_R
        SDL_SCANCODE_S
        SDL_SCANCODE_T
        SDL_SCANCODE_U
        SDL_SCANCODE_V
        SDL_SCANCODE_W
        SDL_SCANCODE_X
        SDL_SCANCODE_Y
        SDL_SCANCODE_Z
        SDL_SCANCODE_1
        SDL_SCANCODE_2
        SDL_SCANCODE_3
        SDL_SCANCODE_4
        SDL_SCANCODE_5
        SDL_SCANCODE_6
        SDL_SCANCODE_7
        SDL_SCANCODE_8
        SDL_SCANCODE_9
        SDL_SCANCODE_0
        SDL_SCANCODE_RETURN
        SDL_SCANCODE_ESCAPE
        SDL_SCANCODE_BACKSPACE
        SDL_SCANCODE_TAB
        SDL_SCANCODE_SPACE
        SDL_SCANCODE_MINUS
        SDL_SCANCODE_EQUALS
        SDL_SCANCODE_LEFTBRACKET
        SDL_SCANCODE_RIGHTBRACKET
        SDL_SCANCODE_BACKSLASH
        SDL_SCANCODE_NONUSHASH
        SDL_SCANCODE_SEMICOLON
        SDL_SCANCODE_APOSTROPHE
        SDL_SCANCODE_GRAVE
        SDL_SCANCODE_COMMA
        SDL_SCANCODE_PERIOD
        SDL_SCANCODE_SLASH
        SDL_SCANCODE_CAPSLOCK
        SDL_SCANCODE_F1
        SDL_SCANCODE_F2
        SDL_SCANCODE_F3
        SDL_SCANCODE_F4
        SDL_SCANCODE_F5
        SDL_SCANCODE_F6
        SDL_SCANCODE_F7
        SDL_SCANCODE_F8
        SDL_SCANCODE_F9
        SDL_SCANCODE_F10
        SDL_SCANCODE_F11
        SDL_SCANCODE_F12
        SDL_SCANCODE_PRINTSCREEN
        SDL_SCANCODE_SCROLLLOCK
        SDL_SCANCODE_PAUSE
        SDL_SCANCODE_INSERT
        SDL_SCANCODE_HOME
        SDL_SCANCODE_PAGEUP
        SDL_SCANCODE_DELETE
        SDL_SCANCODE_END
        SDL_SCANCODE_PAGEDOWN
        SDL_SCANCODE_RIGHT
        SDL_SCANCODE_LEFT
        SDL_SCANCODE_DOWN
        SDL_SCANCODE_UP
        SDL_SCANCODE_NUMLOCKCLEAR
        SDL_SCANCODE_KP_DIVIDE
        SDL_SCANCODE_KP_MULTIPLY
        SDL_SCANCODE_KP_MINUS
        SDL_SCANCODE_KP_PLUS
        SDL_SCANCODE_KP_ENTER
        SDL_SCANCODE_KP_1
        SDL_SCANCODE_KP_2
        SDL_SCANCODE_KP_3
        SDL_SCANCODE_KP_4
        SDL_SCANCODE_KP_5
        SDL_SCANCODE_KP_6
        SDL_SCANCODE_KP_7
        SDL_SCANCODE_KP_8
        SDL_SCANCODE_KP_9
        SDL_SCANCODE_KP_0
        SDL_SCANCODE_KP_PERIOD
        SDL_SCANCODE_NONUSBACKSLASH
        SDL_SCANCODE_APPLICATION
        SDL_SCANCODE_POWER
        SDL_SCANCODE_KP_EQUALS
        SDL_SCANCODE_F13
        SDL_SCANCODE_F14
        SDL_SCANCODE_F15
        SDL_SCANCODE_F16
        SDL_SCANCODE_F17
        SDL_SCANCODE_F18
        SDL_SCANCODE_F19
        SDL_SCANCODE_F20
        SDL_SCANCODE_F21
        SDL_SCANCODE_F22
        SDL_SCANCODE_F23
        SDL_SCANCODE_F24
        SDL_SCANCODE_EXECUTE
        SDL_SCANCODE_HELP
        SDL_SCANCODE_MENU
        SDL_SCANCODE_SELECT
        SDL_SCANCODE_STOP
        SDL_SCANCODE_AGAIN
        SDL_SCANCODE_UNDO
        SDL_SCANCODE_CUT
        SDL_SCANCODE_COPY
        SDL_SCANCODE_PASTE
        SDL_SCANCODE_FIND
        SDL_SCANCODE_MUTE
        SDL_SCANCODE_VOLUMEUP
        SDL_SCANCODE_VOLUMEDOWN
        SDL_SCANCODE_KP_COMMA
        SDL_SCANCODE_KP_EQUALSAS400
        SDL_SCANCODE_INTERNATIONAL1
        SDL_SCANCODE_INTERNATIONAL2
        SDL_SCANCODE_INTERNATIONAL3
        SDL_SCANCODE_INTERNATIONAL4
        SDL_SCANCODE_INTERNATIONAL5
        SDL_SCANCODE_INTERNATIONAL6
        SDL_SCANCODE_INTERNATIONAL7
        SDL_SCANCODE_INTERNATIONAL8
        SDL_SCANCODE_INTERNATIONAL9
        SDL_SCANCODE_LANG1
        SDL_SCANCODE_LANG2
        SDL_SCANCODE_LANG3
        SDL_SCANCODE_LANG4
        SDL_SCANCODE_LANG5
        SDL_SCANCODE_LANG6
        SDL_SCANCODE_LANG7
        SDL_SCANCODE_LANG8
        SDL_SCANCODE_LANG9
        SDL_SCANCODE_ALTERASE
        SDL_SCANCODE_SYSREQ
        SDL_SCANCODE_CANCEL
        SDL_SCANCODE_CLEAR
        SDL_SCANCODE_PRIOR
        SDL_SCANCODE_RETURN2
        SDL_SCANCODE_SEPARATOR
        SDL_SCANCODE_OUT
        SDL_SCANCODE_OPER
        SDL_SCANCODE_CLEARAGAIN
        SDL_SCANCODE_CRSEL
        SDL_SCANCODE_EXSEL
        SDL_SCANCODE_KP_00
        SDL_SCANCODE_KP_000
        SDL_SCANCODE_THOUSANDSSEPARATOR
        SDL_SCANCODE_DECIMALSEPARATOR
        SDL_SCANCODE_CURRENCYUNIT
        SDL_SCANCODE_CURRENCYSUBUNIT
        SDL_SCANCODE_KP_LEFTPAREN
        SDL_SCANCODE_KP_RIGHTPAREN
        SDL_SCANCODE_KP_LEFTBRACE
        SDL_SCANCODE_KP_RIGHTBRACE
        SDL_SCANCODE_KP_TAB
        SDL_SCANCODE_KP_BACKSPACE
        SDL_SCANCODE_KP_A
        SDL_SCANCODE_KP_B
        SDL_SCANCODE_KP_C
        SDL_SCANCODE_KP_D
        SDL_SCANCODE_KP_E
        SDL_SCANCODE_KP_F
        SDL_SCANCODE_KP_XOR
        SDL_SCANCODE_KP_POWER
        SDL_SCANCODE_KP_PERCENT
        SDL_SCANCODE_KP_LESS
        SDL_SCANCODE_KP_GREATER
        SDL_SCANCODE_KP_AMPERSAND
        SDL_SCANCODE_KP_DBLAMPERSAND
        SDL_SCANCODE_KP_VERTICALBAR
        SDL_SCANCODE_KP_DBLVERTICALBAR
        SDL_SCANCODE_KP_COLON
        SDL_SCANCODE_KP_HASH
        SDL_SCANCODE_KP_SPACE
        SDL_SCANCODE_KP_AT
        SDL_SCANCODE_KP_EXCLAM
        SDL_SCANCODE_KP_MEMSTORE
        SDL_SCANCODE_KP_MEMRECALL
        SDL_SCANCODE_KP_MEMCLEAR
        SDL_SCANCODE_KP_MEMADD
        SDL_SCANCODE_KP_MEMSUBTRACT
        SDL_SCANCODE_KP_MEMMULTIPLY
        SDL_SCANCODE_KP_MEMDIVIDE
        SDL_SCANCODE_KP_PLUSMINUS
        SDL_SCANCODE_KP_CLEAR
        SDL_SCANCODE_KP_CLEARENTRY
        SDL_SCANCODE_KP_BINARY
        SDL_SCANCODE_KP_OCTAL
        SDL_SCANCODE_KP_DECIMAL
        SDL_SCANCODE_KP_HEXADECIMAL
        SDL_SCANCODE_LCTRL
        SDL_SCANCODE_LSHIFT
        SDL_SCANCODE_LALT
        SDL_SCANCODE_LGUI
        SDL_SCANCODE_RCTRL
        SDL_SCANCODE_RSHIFT
        SDL_SCANCODE_RALT
        SDL_SCANCODE_RGUI
        SDL_SCANCODE_MODE
        SDL_SCANCODE_AUDIONEXT
        SDL_SCANCODE_AUDIOPREV
        SDL_SCANCODE_AUDIOSTOP
        SDL_SCANCODE_AUDIOPLAY
        SDL_SCANCODE_AUDIOMUTE
        SDL_SCANCODE_MEDIASELECT
        SDL_SCANCODE_WWW
        SDL_SCANCODE_MAIL
        SDL_SCANCODE_CALCULATOR
        SDL_SCANCODE_COMPUTER
        SDL_SCANCODE_AC_SEARCH
        SDL_SCANCODE_AC_HOME
        SDL_SCANCODE_AC_BACK
        SDL_SCANCODE_AC_FORWARD
        SDL_SCANCODE_AC_STOP
        SDL_SCANCODE_AC_REFRESH
        SDL_SCANCODE_AC_BOOKMARKS
        SDL_SCANCODE_BRIGHTNESSDOWN
        SDL_SCANCODE_BRIGHTNESSUP
        SDL_SCANCODE_DISPLAYSWITCH
        SDL_SCANCODE_KBDILLUMTOGGLE
        SDL_SCANCODE_KBDILLUMDOWN
        SDL_SCANCODE_KBDILLUMUP
        SDL_SCANCODE_EJECT
        SDL_SCANCODE_SLEEP
        SDL_NUM_SCANCODES
    ctypedef Enum_temp_random_257052 SDL_Scancode
    ctypedef Sint32 SDL_Keycode
    cdef enum Enum_temp_random_041424:
        SDLK_UNKNOWN
        SDLK_RETURN
        SDLK_ESCAPE
        SDLK_BACKSPACE
        SDLK_TAB
        SDLK_SPACE
        SDLK_EXCLAIM
        SDLK_QUOTEDBL
        SDLK_HASH
        SDLK_PERCENT
        SDLK_DOLLAR
        SDLK_AMPERSAND
        SDLK_QUOTE
        SDLK_LEFTPAREN
        SDLK_RIGHTPAREN
        SDLK_ASTERISK
        SDLK_PLUS
        SDLK_COMMA
        SDLK_MINUS
        SDLK_PERIOD
        SDLK_SLASH
        SDLK_0
        SDLK_1
        SDLK_2
        SDLK_3
        SDLK_4
        SDLK_5
        SDLK_6
        SDLK_7
        SDLK_8
        SDLK_9
        SDLK_COLON
        SDLK_SEMICOLON
        SDLK_LESS
        SDLK_EQUALS
        SDLK_GREATER
        SDLK_QUESTION
        SDLK_AT
        SDLK_LEFTBRACKET
        SDLK_BACKSLASH
        SDLK_RIGHTBRACKET
        SDLK_CARET
        SDLK_UNDERSCORE
        SDLK_BACKQUOTE
        SDLK_a
        SDLK_b
        SDLK_c
        SDLK_d
        SDLK_e
        SDLK_f
        SDLK_g
        SDLK_h
        SDLK_i
        SDLK_j
        SDLK_k
        SDLK_l
        SDLK_m
        SDLK_n
        SDLK_o
        SDLK_p
        SDLK_q
        SDLK_r
        SDLK_s
        SDLK_t
        SDLK_u
        SDLK_v
        SDLK_w
        SDLK_x
        SDLK_y
        SDLK_z
        SDLK_CAPSLOCK
        SDLK_F1
        SDLK_F2
        SDLK_F3
        SDLK_F4
        SDLK_F5
        SDLK_F6
        SDLK_F7
        SDLK_F8
        SDLK_F9
        SDLK_F10
        SDLK_F11
        SDLK_F12
        SDLK_PRINTSCREEN
        SDLK_SCROLLLOCK
        SDLK_PAUSE
        SDLK_INSERT
        SDLK_HOME
        SDLK_PAGEUP
        SDLK_DELETE
        SDLK_END
        SDLK_PAGEDOWN
        SDLK_RIGHT
        SDLK_LEFT
        SDLK_DOWN
        SDLK_UP
        SDLK_NUMLOCKCLEAR
        SDLK_KP_DIVIDE
        SDLK_KP_MULTIPLY
        SDLK_KP_MINUS
        SDLK_KP_PLUS
        SDLK_KP_ENTER
        SDLK_KP_1
        SDLK_KP_2
        SDLK_KP_3
        SDLK_KP_4
        SDLK_KP_5
        SDLK_KP_6
        SDLK_KP_7
        SDLK_KP_8
        SDLK_KP_9
        SDLK_KP_0
        SDLK_KP_PERIOD
        SDLK_APPLICATION
        SDLK_POWER
        SDLK_KP_EQUALS
        SDLK_F13
        SDLK_F14
        SDLK_F15
        SDLK_F16
        SDLK_F17
        SDLK_F18
        SDLK_F19
        SDLK_F20
        SDLK_F21
        SDLK_F22
        SDLK_F23
        SDLK_F24
        SDLK_EXECUTE
        SDLK_HELP
        SDLK_MENU
        SDLK_SELECT
        SDLK_STOP
        SDLK_AGAIN
        SDLK_UNDO
        SDLK_CUT
        SDLK_COPY
        SDLK_PASTE
        SDLK_FIND
        SDLK_MUTE
        SDLK_VOLUMEUP
        SDLK_VOLUMEDOWN
        SDLK_KP_COMMA
        SDLK_KP_EQUALSAS400
        SDLK_ALTERASE
        SDLK_SYSREQ
        SDLK_CANCEL
        SDLK_CLEAR
        SDLK_PRIOR
        SDLK_RETURN2
        SDLK_SEPARATOR
        SDLK_OUT
        SDLK_OPER
        SDLK_CLEARAGAIN
        SDLK_CRSEL
        SDLK_EXSEL
        SDLK_KP_00
        SDLK_KP_000
        SDLK_THOUSANDSSEPARATOR
        SDLK_DECIMALSEPARATOR
        SDLK_CURRENCYUNIT
        SDLK_CURRENCYSUBUNIT
        SDLK_KP_LEFTPAREN
        SDLK_KP_RIGHTPAREN
        SDLK_KP_LEFTBRACE
        SDLK_KP_RIGHTBRACE
        SDLK_KP_TAB
        SDLK_KP_BACKSPACE
        SDLK_KP_A
        SDLK_KP_B
        SDLK_KP_C
        SDLK_KP_D
        SDLK_KP_E
        SDLK_KP_F
        SDLK_KP_XOR
        SDLK_KP_POWER
        SDLK_KP_PERCENT
        SDLK_KP_LESS
        SDLK_KP_GREATER
        SDLK_KP_AMPERSAND
        SDLK_KP_DBLAMPERSAND
        SDLK_KP_VERTICALBAR
        SDLK_KP_DBLVERTICALBAR
        SDLK_KP_COLON
        SDLK_KP_HASH
        SDLK_KP_SPACE
        SDLK_KP_AT
        SDLK_KP_EXCLAM
        SDLK_KP_MEMSTORE
        SDLK_KP_MEMRECALL
        SDLK_KP_MEMCLEAR
        SDLK_KP_MEMADD
        SDLK_KP_MEMSUBTRACT
        SDLK_KP_MEMMULTIPLY
        SDLK_KP_MEMDIVIDE
        SDLK_KP_PLUSMINUS
        SDLK_KP_CLEAR
        SDLK_KP_CLEARENTRY
        SDLK_KP_BINARY
        SDLK_KP_OCTAL
        SDLK_KP_DECIMAL
        SDLK_KP_HEXADECIMAL
        SDLK_LCTRL
        SDLK_LSHIFT
        SDLK_LALT
        SDLK_LGUI
        SDLK_RCTRL
        SDLK_RSHIFT
        SDLK_RALT
        SDLK_RGUI
        SDLK_MODE
        SDLK_AUDIONEXT
        SDLK_AUDIOPREV
        SDLK_AUDIOSTOP
        SDLK_AUDIOPLAY
        SDLK_AUDIOMUTE
        SDLK_MEDIASELECT
        SDLK_WWW
        SDLK_MAIL
        SDLK_CALCULATOR
        SDLK_COMPUTER
        SDLK_AC_SEARCH
        SDLK_AC_HOME
        SDLK_AC_BACK
        SDLK_AC_FORWARD
        SDLK_AC_STOP
        SDLK_AC_REFRESH
        SDLK_AC_BOOKMARKS
        SDLK_BRIGHTNESSDOWN
        SDLK_BRIGHTNESSUP
        SDLK_DISPLAYSWITCH
        SDLK_KBDILLUMTOGGLE
        SDLK_KBDILLUMDOWN
        SDLK_KBDILLUMUP
        SDLK_EJECT
        SDLK_SLEEP
    cdef enum Enum_temp_random_172795:
        KMOD_NONE
        KMOD_LSHIFT
        KMOD_RSHIFT
        KMOD_LCTRL
        KMOD_RCTRL
        KMOD_LALT
        KMOD_RALT
        KMOD_LGUI
        KMOD_RGUI
        KMOD_NUM
        KMOD_CAPS
        KMOD_MODE
        KMOD_RESERVED
    ctypedef Enum_temp_random_172795 SDL_Keymod
    cdef struct SDL_Keysym:
        SDL_Scancode scancode
        SDL_Keycode sym
        Uint16 mod
        Uint32 unicode
    SDL_Window* SDL_GetKeyboardFocus()
    Uint8* SDL_GetKeyboardState(int *numkeys)
    SDL_Keymod SDL_GetModState()
    void SDL_SetModState(SDL_Keymod modstate)
    SDL_Keycode SDL_GetKeyFromScancode(SDL_Scancode scancode)
    SDL_Scancode SDL_GetScancodeFromKey(SDL_Keycode key)
    char* SDL_GetScancodeName(SDL_Scancode scancode)
    SDL_Scancode SDL_GetScancodeFromName(char *name)
    char* SDL_GetKeyName(SDL_Keycode key)
    SDL_Keycode SDL_GetKeyFromName(char *name)
    void SDL_StartTextInput()
    void SDL_StopTextInput()
    void SDL_SetTextInputRect(SDL_Rect *rect)
    cdef struct SDL_Cursor:
        pass
    SDL_Window* SDL_GetMouseFocus()
    Uint8 SDL_GetMouseState(int *x, int *y)
    Uint8 SDL_GetRelativeMouseState(int *x, int *y)
    void SDL_WarpMouseInWindow(SDL_Window *window, int x, int y)
    int SDL_SetRelativeMouseMode(SDL_bool enabled)
    SDL_bool SDL_GetRelativeMouseMode()
    SDL_Cursor* SDL_CreateCursor(Uint8 *data, Uint8 *mask, int w, int h, int hot_x, int hot_y)
    SDL_Cursor* SDL_CreateColorCursor(SDL_Surface *surface, int hot_x, int hot_y)
    void SDL_SetCursor(SDL_Cursor *cursor)
    SDL_Cursor* SDL_GetCursor()
    void SDL_FreeCursor(SDL_Cursor *cursor)
    int SDL_ShowCursor(int toggle)
    cdef struct _SDL_Joystick:
        pass
    ctypedef _SDL_Joystick SDL_Joystick
    int SDL_NumJoysticks()
    char* SDL_JoystickName(int device_index)
    SDL_Joystick* SDL_JoystickOpen(int device_index)
    int SDL_JoystickOpened(int device_index)
    int SDL_JoystickIndex(SDL_Joystick *joystick)
    int SDL_JoystickNumAxes(SDL_Joystick *joystick)
    int SDL_JoystickNumBalls(SDL_Joystick *joystick)
    int SDL_JoystickNumHats(SDL_Joystick *joystick)
    int SDL_JoystickNumButtons(SDL_Joystick *joystick)
    void SDL_JoystickUpdate()
    int SDL_JoystickEventState(int state)
    Sint16 SDL_JoystickGetAxis(SDL_Joystick *joystick, int axis)
    Uint8 SDL_JoystickGetHat(SDL_Joystick *joystick, int hat)
    int SDL_JoystickGetBall(SDL_Joystick *joystick, int ball, int *dx, int *dy)
    Uint8 SDL_JoystickGetButton(SDL_Joystick *joystick, int button)
    void SDL_JoystickClose(SDL_Joystick *joystick)
    ctypedef Sint64 SDL_TouchID
    ctypedef Sint64 SDL_FingerID
    cdef struct SDL_Finger:
        SDL_FingerID id
        Uint16 x
        Uint16 y
        Uint16 pressure
        Uint16 xdelta
        Uint16 ydelta
        Uint16 last_x
        Uint16 last_y
        Uint16 last_pressure
        SDL_bool down
    cdef struct SDL_Touch:
        pass
    cdef struct SDL_Touch:
        void (*FreeTouch)(SDL_Touch* touch)
        float pressure_max
        float pressure_min
        float x_max
        float x_min
        float y_max
        float y_min
        Uint16 xres
        Uint16 yres
        Uint16 pressureres
        float native_xres
        float native_yres
        float native_pressureres
        float tilt
        float rotation
        SDL_TouchID id
        SDL_Window *focus
        char *name
        Uint8 buttonstate
        SDL_bool relative_mode
        SDL_bool flush_motion
        int num_fingers
        int max_fingers
        SDL_Finger **fingers
        void *driverdata
    SDL_Touch* SDL_GetTouch(SDL_TouchID id)
    SDL_Finger* SDL_GetFinger(SDL_Touch *touch, SDL_FingerID id)
    ctypedef Sint64 SDL_GestureID
    int SDL_RecordGesture(SDL_TouchID touchId)
    int SDL_SaveAllDollarTemplates(SDL_RWops *src)
    int SDL_SaveDollarTemplate(SDL_GestureID gestureId, SDL_RWops *src)
    int SDL_LoadDollarTemplates(SDL_TouchID touchId, SDL_RWops *src)
    cdef enum Enum_temp_random_763289:
        SDL_FIRSTEVENT
        SDL_QUIT
        SDL_WINDOWEVENT
        SDL_SYSWMEVENT
        SDL_KEYDOWN
        SDL_KEYUP
        SDL_TEXTEDITING
        SDL_TEXTINPUT
        SDL_MOUSEMOTION
        SDL_MOUSEBUTTONDOWN
        SDL_MOUSEBUTTONUP
        SDL_MOUSEWHEEL
        SDL_INPUTMOTION
        SDL_INPUTBUTTONDOWN
        SDL_INPUTBUTTONUP
        SDL_INPUTWHEEL
        SDL_INPUTPROXIMITYIN
        SDL_INPUTPROXIMITYOUT
        SDL_JOYAXISMOTION
        SDL_JOYBALLMOTION
        SDL_JOYHATMOTION
        SDL_JOYBUTTONDOWN
        SDL_JOYBUTTONUP
        SDL_FINGERDOWN
        SDL_FINGERUP
        SDL_FINGERMOTION
        SDL_TOUCHBUTTONDOWN
        SDL_TOUCHBUTTONUP
        SDL_DOLLARGESTURE
        SDL_DOLLARRECORD
        SDL_MULTIGESTURE
        SDL_CLIPBOARDUPDATE
        SDL_DROPFILE
        SDL_EVENT_COMPAT1
        SDL_EVENT_COMPAT2
        SDL_EVENT_COMPAT3
        SDL_USEREVENT
        SDL_LASTEVENT
    ctypedef Enum_temp_random_763289 SDL_EventType
    cdef struct SDL_WindowEvent:
        Uint32 type
        Uint32 windowID
        Uint8 event
        Uint8 padding1
        Uint8 padding2
        Uint8 padding3
        int data1
        int data2
    cdef struct SDL_KeyboardEvent:
        Uint32 type
        Uint32 windowID
        Uint8 state
        Uint8 repeat
        Uint8 padding2
        Uint8 padding3
        SDL_Keysym keysym
    cdef struct SDL_TextEditingEvent:
        Uint32 type
        Uint32 windowID
        char text[32]
        int start
        int length
    cdef struct SDL_TextInputEvent:
        Uint32 type
        Uint32 windowID
        char text[32]
    cdef struct SDL_MouseMotionEvent:
        Uint32 type
        Uint32 windowID
        Uint8 state
        Uint8 padding1
        Uint8 padding2
        Uint8 padding3
        int x
        int y
        int xrel
        int yrel
    cdef struct SDL_MouseButtonEvent:
        Uint32 type
        Uint32 windowID
        Uint8 button
        Uint8 state
        Uint8 padding1
        Uint8 padding2
        int x
        int y
    cdef struct SDL_MouseWheelEvent:
        Uint32 type
        Uint32 windowID
        int x
        int y
    cdef struct SDL_JoyAxisEvent:
        Uint32 type
        Uint8 which
        Uint8 axis
        Uint8 padding1
        Uint8 padding2
        int value
    cdef struct SDL_JoyBallEvent:
        Uint32 type
        Uint8 which
        Uint8 ball
        Uint8 padding1
        Uint8 padding2
        int xrel
        int yrel
    cdef struct SDL_JoyHatEvent:
        Uint32 type
        Uint8 which
        Uint8 hat
        Uint8 value
        Uint8 padding1
    cdef struct SDL_JoyButtonEvent:
        Uint32 type
        Uint8 which
        Uint8 button
        Uint8 state
        Uint8 padding1
    cdef struct SDL_TouchFingerEvent:
        Uint32 type
        Uint32 windowID
        SDL_TouchID touchId
        SDL_FingerID fingerId
        Uint8 state
        Uint8 padding1
        Uint8 padding2
        Uint8 padding3
        Uint16 x
        Uint16 y
        Sint16 dx
        Sint16 dy
        Uint16 pressure
    cdef struct SDL_TouchButtonEvent:
        Uint32 type
        Uint32 windowID
        SDL_TouchID touchId
        Uint8 state
        Uint8 button
        Uint8 padding1
        Uint8 padding2
    cdef struct SDL_MultiGestureEvent:
        Uint32 type
        Uint32 windowID
        SDL_TouchID touchId
        float dTheta
        float dDist
        float x
        float y
        Uint16 numFingers
        Uint16 padding
    cdef struct SDL_DollarGestureEvent:
        Uint32 type
        Uint32 windowID
        SDL_TouchID touchId
        SDL_GestureID gestureId
        Uint32 numFingers
        float error
    cdef struct SDL_DropEvent:
        Uint32 type
        char *file
    cdef struct SDL_QuitEvent:
        Uint32 type
    cdef struct SDL_UserEvent:
        Uint32 type
        Uint32 windowID
        int code
        void *data1
        void *data2
    cdef struct SDL_SysWMmsg:
        pass
    cdef struct SDL_SysWMEvent:
        Uint32 type
        SDL_SysWMmsg *msg
    cdef struct SDL_ActiveEvent:
        Uint32 type
        Uint8 gain
        Uint8 state
    cdef struct SDL_ResizeEvent:
        Uint32 type
        int w
        int h
    cdef union SDL_Event:
        Uint32 type
        SDL_WindowEvent window
        SDL_KeyboardEvent key
        SDL_TextEditingEvent edit
        SDL_TextInputEvent text
        SDL_MouseMotionEvent motion
        SDL_MouseButtonEvent button
        SDL_MouseWheelEvent wheel
        SDL_JoyAxisEvent jaxis
        SDL_JoyBallEvent jball
        SDL_JoyHatEvent jhat
        SDL_JoyButtonEvent jbutton
        SDL_QuitEvent quit
        SDL_UserEvent user
        SDL_SysWMEvent syswm
        SDL_TouchFingerEvent tfinger
        SDL_TouchButtonEvent tbutton
        SDL_MultiGestureEvent mgesture
        SDL_DollarGestureEvent dgesture
        SDL_DropEvent drop
        SDL_ActiveEvent active
        SDL_ResizeEvent resize
    void SDL_PumpEvents()
    cdef enum Enum_temp_random_743837:
        SDL_ADDEVENT
        SDL_PEEKEVENT
        SDL_GETEVENT
    ctypedef Enum_temp_random_743837 SDL_eventaction
    int SDL_PeepEvents(SDL_Event *events, int numevents, SDL_eventaction action, Uint32 minType, Uint32 maxType)
    SDL_bool SDL_HasEvent(Uint32 type)
    SDL_bool SDL_HasEvents(Uint32 minType, Uint32 maxType)
    void SDL_FlushEvent(Uint32 type)
    void SDL_FlushEvents(Uint32 minType, Uint32 maxType)
    int SDL_PollEvent(SDL_Event *event)
    int SDL_WaitEvent(SDL_Event *event)
    int SDL_WaitEventTimeout(SDL_Event *event, int timeout)
    int SDL_PushEvent(SDL_Event *event)
    ctypedef int (*SDL_EventFilter)(void* userdata, SDL_Event* event)
    void SDL_SetEventFilter(int (*filter)(), void *userdata)
    SDL_bool SDL_GetEventFilter(SDL_EventFilter *filter, void ** userdata)
    void SDL_AddEventWatch(int (*filter)(), void *userdata)
    void SDL_DelEventWatch(int (*filter)(), void *userdata)
    void SDL_FilterEvents(int (*filter)(), void *userdata)
    Uint8 SDL_EventState(Uint32 type, int state)
    Uint32 SDL_RegisterEvents(int numevents)
    cdef enum Enum_temp_random_242723:
        SDL_HINT_DEFAULT
        SDL_HINT_NORMAL
        SDL_HINT_OVERRIDE
    ctypedef Enum_temp_random_242723 SDL_HintPriority
    SDL_bool SDL_SetHintWithPriority(char *name, char *value, SDL_HintPriority priority)
    SDL_bool SDL_SetHint(char *name, char *value)
    char* SDL_GetHint(char *name)
    void SDL_ClearHints()
    void* SDL_LoadObject(char *sofile)
    void* SDL_LoadFunction(void *handle, char *name)
    void SDL_UnloadObject(void *handle)
    cdef enum Enum_temp_random_393702:
        SDL_LOG_CATEGORY_APPLICATION
        SDL_LOG_CATEGORY_ERROR
        SDL_LOG_CATEGORY_SYSTEM
        SDL_LOG_CATEGORY_AUDIO
        SDL_LOG_CATEGORY_VIDEO
        SDL_LOG_CATEGORY_RENDER
        SDL_LOG_CATEGORY_INPUT
        SDL_LOG_CATEGORY_RESERVED1
        SDL_LOG_CATEGORY_RESERVED2
        SDL_LOG_CATEGORY_RESERVED3
        SDL_LOG_CATEGORY_RESERVED4
        SDL_LOG_CATEGORY_RESERVED5
        SDL_LOG_CATEGORY_RESERVED6
        SDL_LOG_CATEGORY_RESERVED7
        SDL_LOG_CATEGORY_RESERVED8
        SDL_LOG_CATEGORY_RESERVED9
        SDL_LOG_CATEGORY_RESERVED10
        SDL_LOG_CATEGORY_CUSTOM
    cdef enum Enum_temp_random_706993:
        SDL_LOG_PRIORITY_VERBOSE
        SDL_LOG_PRIORITY_DEBUG
        SDL_LOG_PRIORITY_INFO
        SDL_LOG_PRIORITY_WARN
        SDL_LOG_PRIORITY_ERROR
        SDL_LOG_PRIORITY_CRITICAL
        SDL_NUM_LOG_PRIORITIES
    ctypedef Enum_temp_random_706993 SDL_LogPriority
    void SDL_LogSetAllPriority(SDL_LogPriority priority)
    void SDL_LogSetPriority(int category, SDL_LogPriority priority)
    SDL_LogPriority SDL_LogGetPriority(int category)
    void SDL_LogResetPriorities()
    void SDL_Log(char *fmt)
    void SDL_LogVerbose(int category, char *fmt)
    void SDL_LogDebug(int category, char *fmt)
    void SDL_LogInfo(int category, char *fmt)
    void SDL_LogWarn(int category, char *fmt)
    void SDL_LogError(int category, char *fmt)
    void SDL_LogCritical(int category, char *fmt)
    void SDL_LogMessage(int category, SDL_LogPriority priority, char *fmt)
    void SDL_LogMessageV(int category, SDL_LogPriority priority, char *fmt, va_list ap)
    ctypedef void (*SDL_LogOutputFunction)(void* userdata, int category, SDL_LogPriority priority, char* message)
    void SDL_LogGetOutputFunction(SDL_LogOutputFunction *callback, void ** userdata)
    void SDL_LogSetOutputFunction(void (*callback)(), void *userdata)
    cdef enum Enum_temp_random_821262:
        SDL_POWERSTATE_UNKNOWN
        SDL_POWERSTATE_ON_BATTERY
        SDL_POWERSTATE_NO_BATTERY
        SDL_POWERSTATE_CHARGING
        SDL_POWERSTATE_CHARGED
    ctypedef Enum_temp_random_821262 SDL_PowerState
    SDL_PowerState SDL_GetPowerInfo(int *secs, int *pct)
    cdef enum Enum_temp_random_404418:
        SDL_RENDERER_SOFTWARE
        SDL_RENDERER_ACCELERATED
        SDL_RENDERER_PRESENTVSYNC
    ctypedef Enum_temp_random_404418 SDL_RendererFlags
    cdef struct SDL_RendererInfo:
        char *name
        Uint32 flags
        Uint32 num_texture_formats
        Uint32 texture_formats[16]
        int max_texture_width
        int max_texture_height
    cdef enum Enum_temp_random_632023:
        SDL_TEXTUREACCESS_STATIC
        SDL_TEXTUREACCESS_STREAMING
    ctypedef Enum_temp_random_632023 SDL_TextureAccess
    cdef enum Enum_temp_random_121747:
        SDL_TEXTUREMODULATE_NONE
        SDL_TEXTUREMODULATE_COLOR
        SDL_TEXTUREMODULATE_ALPHA
    ctypedef Enum_temp_random_121747 SDL_TextureModulate
    cdef struct SDL_Renderer:
        pass
    cdef struct SDL_Texture:
        pass
    int SDL_GetNumRenderDrivers()
    int SDL_GetRenderDriverInfo(int index, SDL_RendererInfo *info)
    SDL_Renderer* SDL_CreateRenderer(SDL_Window *window, int index, Uint32 flags)
    SDL_Renderer* SDL_CreateSoftwareRenderer(SDL_Surface *surface)
    SDL_Renderer* SDL_GetRenderer(SDL_Window *window)
    int SDL_GetRendererInfo(SDL_Renderer *renderer, SDL_RendererInfo *info)
    SDL_Texture* SDL_CreateTexture(SDL_Renderer *renderer, Uint32 format, int access, int w, int h)
    SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer *renderer, SDL_Surface *surface)
    int SDL_QueryTexture(SDL_Texture *texture, Uint32 *format, int *access, int *w, int *h)
    int SDL_SetTextureColorMod(SDL_Texture *texture, Uint8 r, Uint8 g, Uint8 b)
    int SDL_GetTextureColorMod(SDL_Texture *texture, Uint8 *r, Uint8 *g, Uint8 *b)
    int SDL_SetTextureAlphaMod(SDL_Texture *texture, Uint8 alpha)
    int SDL_GetTextureAlphaMod(SDL_Texture *texture, Uint8 *alpha)
    int SDL_SetTextureBlendMode(SDL_Texture *texture, SDL_BlendMode blendMode)
    int SDL_GetTextureBlendMode(SDL_Texture *texture, SDL_BlendMode *blendMode)
    int SDL_UpdateTexture(SDL_Texture *texture, SDL_Rect *rect, void *pixels, int pitch)
    int SDL_LockTexture(SDL_Texture *texture, SDL_Rect *rect, void ** pixels, int *pitch)
    void SDL_UnlockTexture(SDL_Texture *texture)
    int SDL_RenderSetViewport(SDL_Renderer *renderer, SDL_Rect *rect)
    void SDL_RenderGetViewport(SDL_Renderer *renderer, SDL_Rect *rect)
    int SDL_SetRenderDrawColor(SDL_Renderer *renderer, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
    int SDL_GetRenderDrawColor(SDL_Renderer *renderer, Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a)
    int SDL_SetRenderDrawBlendMode(SDL_Renderer *renderer, SDL_BlendMode blendMode)
    int SDL_GetRenderDrawBlendMode(SDL_Renderer *renderer, SDL_BlendMode *blendMode)
    int SDL_RenderClear(SDL_Renderer *renderer)
    int SDL_RenderDrawPoint(SDL_Renderer *renderer, int x, int y)
    int SDL_RenderDrawPoints(SDL_Renderer *renderer, SDL_Point *points, int count)
    int SDL_RenderDrawLine(SDL_Renderer *renderer, int x1, int y1, int x2, int y2)
    int SDL_RenderDrawLines(SDL_Renderer *renderer, SDL_Point *points, int count)
    int SDL_RenderDrawRect(SDL_Renderer *renderer, SDL_Rect *rect)
    int SDL_RenderDrawRects(SDL_Renderer *renderer, SDL_Rect *rects, int count)
    int SDL_RenderFillRect(SDL_Renderer *renderer, SDL_Rect *rect)
    int SDL_RenderFillRects(SDL_Renderer *renderer, SDL_Rect *rects, int count)
    int SDL_RenderCopy(SDL_Renderer *renderer, SDL_Texture *texture, SDL_Rect *srcrect, SDL_Rect *dstrect)
    int SDL_RenderReadPixels(SDL_Renderer *renderer, SDL_Rect *rect, Uint32 format, void *pixels, int pitch)
    void SDL_RenderPresent(SDL_Renderer *renderer)
    void SDL_DestroyTexture(SDL_Texture *texture)
    void SDL_DestroyRenderer(SDL_Renderer *renderer)
    Uint32 SDL_GetTicks()
    Uint64 SDL_GetPerformanceCounter()
    Uint64 SDL_GetPerformanceFrequency()
    void SDL_Delay(Uint32 ms)
    ctypedef unsigned int (*SDL_TimerCallback)(Uint32 interval, void* param)
    ctypedef int SDL_TimerID
    SDL_TimerID SDL_AddTimer(Uint32 interval, unsigned int (*callback)(), void *param)
    SDL_bool SDL_RemoveTimer(SDL_TimerID t)
    cdef struct SDL_version:
        Uint8 major
        Uint8 minor
        Uint8 patch
    void SDL_GetVersion(SDL_version *ver)
    char* SDL_GetRevision()
    int SDL_GetRevisionNumber()
    cdef struct SDL_VideoInfo:
        Uint32 hw_available
        Uint32 wm_available
        Uint32 UnusedBits1
        Uint32 UnusedBits2
        Uint32 blit_hw
        Uint32 blit_hw_CC
        Uint32 blit_hw_A
        Uint32 blit_sw
        Uint32 blit_sw_CC
        Uint32 blit_sw_A
        Uint32 blit_fill
        Uint32 UnusedBits3
        Uint32 video_mem
        SDL_PixelFormat *vfmt
        int current_w
        int current_h
    cdef struct private_yuvhwfuncs:
        pass
    cdef struct private_yuvhwdata:
        pass
    cdef struct SDL_Overlay:
        Uint32 format
        int w
        int h
        int planes
        Uint16 *pitches
        Uint8 **pixels
        private_yuvhwfuncs *hwfuncs
        private_yuvhwdata *hwdata
        Uint32 hw_overlay
        Uint32 UnusedBits
    cdef enum Enum_temp_random_111784:
        SDL_GRAB_QUERY
        SDL_GRAB_OFF
        SDL_GRAB_ON
    ctypedef Enum_temp_random_111784 SDL_GrabMode
    cdef struct SDL_SysWMinfo:
        pass
    SDL_version* SDL_Linked_Version()
    char* SDL_AudioDriverName(char *namebuf, int maxlen)
    char* SDL_VideoDriverName(char *namebuf, int maxlen)
    SDL_VideoInfo* SDL_GetVideoInfo()
    int SDL_VideoModeOK(int width, int height, int bpp, Uint32 flags)
    SDL_Rect** SDL_ListModes(SDL_PixelFormat *format, Uint32 flags)
    SDL_Surface* SDL_SetVideoMode(int width, int height, int bpp, Uint32 flags)
    SDL_Surface* SDL_GetVideoSurface()
    void SDL_UpdateRects(SDL_Surface *screen, int numrects, SDL_Rect *rects)
    void SDL_UpdateRect(SDL_Surface *screen, Sint32 x, Sint32 y, Uint32 w, Uint32 h)
    int SDL_Flip(SDL_Surface *screen)
    int SDL_SetAlpha(SDL_Surface *surface, Uint32 flag, Uint8 alpha)
    SDL_Surface* SDL_DisplayFormat(SDL_Surface *surface)
    SDL_Surface* SDL_DisplayFormatAlpha(SDL_Surface *surface)
    void SDL_WM_SetCaption(char *title, char *icon)
    void SDL_WM_GetCaption(char ** title, char ** icon)
    void SDL_WM_SetIcon(SDL_Surface *icon, Uint8 *mask)
    int SDL_WM_IconifyWindow()
    int SDL_WM_ToggleFullScreen(SDL_Surface *surface)
    SDL_GrabMode SDL_WM_GrabInput(SDL_GrabMode mode)
    int SDL_SetPalette(SDL_Surface *surface, int flags, SDL_Color *colors, int firstcolor, int ncolors)
    int SDL_SetColors(SDL_Surface *surface, SDL_Color *colors, int firstcolor, int ncolors)
    int SDL_GetWMInfo(SDL_SysWMinfo *info)
    Uint8 SDL_GetAppState()
    void SDL_WarpMouse(Uint16 x, Uint16 y)
    SDL_Overlay* SDL_CreateYUVOverlay(int width, int height, Uint32 format, SDL_Surface *display)
    int SDL_LockYUVOverlay(SDL_Overlay *overlay)
    void SDL_UnlockYUVOverlay(SDL_Overlay *overlay)
    int SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect)
    void SDL_FreeYUVOverlay(SDL_Overlay *overlay)
    void SDL_GL_SwapBuffers()
    int SDL_SetGamma(float red, float green, float blue)
    int SDL_SetGammaRamp(Uint16 *red, Uint16 *green, Uint16 *blue)
    int SDL_GetGammaRamp(Uint16 *red, Uint16 *green, Uint16 *blue)
    int SDL_EnableKeyRepeat(int delay, int interval)
    void SDL_GetKeyRepeat(int *delay, int *interval)
    int SDL_EnableUNICODE(int enable)
    ctypedef SDL_Window *SDL_WindowID
    ctypedef unsigned int (*SDL_OldTimerCallback)(Uint32 interval)
    int SDL_SetTimer(Uint32 interval, unsigned int (*callback)())
    int SDL_putenv(char *variable)
    int SDL_Init(Uint32 flags)
    int SDL_InitSubSystem(Uint32 flags)
    void SDL_QuitSubSystem(Uint32 flags)
    Uint32 SDL_WasInit(Uint32 flags)
    void SDL_Quit()
