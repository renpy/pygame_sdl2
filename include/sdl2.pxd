from libc.stdint cimport *

cdef extern from "SDL.h" nogil:
    ctypedef int8_t Sint8
    ctypedef uint8_t Uint8
    ctypedef int16_t Sint16
    ctypedef uint16_t Uint16
    ctypedef int32_t Sint32
    ctypedef uint32_t Uint32
    ctypedef int64_t Sint64
    ctypedef uint64_t Uint64

include "event_enum.pxi"

cdef extern from "SDL.h" nogil:

    enum:
        SDL_INIT_TIMER
        SDL_INIT_AUDIO
        SDL_INIT_VIDEO
        SDL_INIT_JOYSTICK
        SDL_INIT_HAPTIC
        SDL_INIT_GAMECONTROLLER
        SDL_INIT_EVENTS
        SDL_INIT_NOPARACHUTE
        SDL_INIT_EVERYTHING

    int SDL_Init(Uint32 flags)
    int SDL_InitSubSystem(Uint32 flags)
    void SDL_QuitSubSystem(Uint32 flags)
    Uint32 SDL_WasInit(Uint32 flags)
    void SDL_Quit()

    cdef struct SDL_Rect:
        int x
        int y
        int w
        int h

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
        int refcount

    SDL_Surface* SDL_CreateRGBSurface(Uint32 flags, int width, int height, int depth, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)
    SDL_Surface* SDL_CreateRGBSurfaceFrom(void *pixels, int width, int height, int depth, int pitch, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)
    void SDL_FreeSurface(SDL_Surface *surface)

    enum:
        SDL_WINDOWPOS_CENTERED
        SDL_WINDOWPOS_UNDEFINED

    enum:
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
        SDL_WINDOW_FULLSCREEN_DESKTOP
        SDL_WINDOW_FOREIGN
        SDL_WINDOW_ALLOW_HIGHDPI

    cdef struct SDL_Window:
        pass

    SDL_Window* SDL_CreateWindow(char *title, int x, int y, int w, int h, Uint32 flags)
    SDL_Surface* SDL_GetWindowSurface(SDL_Window *window)
    int SDL_UpdateWindowSurface(SDL_Window *window)

include "event_enum.pxi"

cdef extern from "SDL.h" nogil:


    cdef enum SDL_Scancode:
        SDL_NUM_SCANCODES

    ctypedef Sint32 SDL_Keycode

    cdef struct SDL_Keysym:
        SDL_Scancode scancode
        SDL_Keycode sym
        Uint16 mod
        Uint32 unicode

    ctypedef Sint64 SDL_TouchID
    ctypedef Sint64 SDL_FingerID
    ctypedef Sint64 SDL_GestureID

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

    int SDL_WaitEventTimeout(SDL_Event *event, int timeout)
    int SDL_WaitEvent(SDL_Event *event)
