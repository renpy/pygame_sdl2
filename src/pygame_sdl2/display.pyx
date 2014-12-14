# Copyright 2014 Patrick Dawson <pat@dw.is>
# Copyright 2014 Tom Rothamel <tom@rothamel.us>
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

from sdl2 cimport *
from surface cimport *
from rect cimport to_sdl_rect

from libc.stdlib cimport calloc, free
from pygame_sdl2.locals import SRCALPHA, GL_SWAP_CONTROL
from pygame_sdl2.error import error
import pygame_sdl2

import warnings
import os

# True if we are on ios.
ios = ("PYGAME_IOS" in os.environ)

# This inits SDL proper, and should be called by the other init methods.

main_done = False

def sdl_main_init():
    global main_done

    if main_done:
        return

    SDL_SetMainReady()

    if SDL_Init(0):
        raise error()

    main_done = True

# True if init has been called without quit being called.
init_done = False

@pygame_sdl2.register_init
def init():

    if init_done:
        return

    sdl_main_init()

    if SDL_InitSubSystem(SDL_INIT_VIDEO):
        raise error()

    pygame_sdl2.event.init()

    global init_done
    init_done = True



@pygame_sdl2.register_quit
def quit(): # @ReservedAssignment

    global init_done
    global main_window

    if main_window:
        main_window.destroy()
        main_window = None

    init_done = False

def get_init():
    return init_done


# The window that is used by the various module globals.
main_window = None

cdef class Window:
    def __init__(self, title, resolution=(0, 0), flags=0, depth=0):

        if not isinstance(title, bytes):
            title = title.encode("utf-8")

        self.create_flags = flags

        self.window = SDL_CreateWindow(
            title,
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            resolution[0], resolution[1], flags)

        if not self.window:
            raise error()

        cdef int w, h
        SDL_GetWindowSize(self.window, &w, &h)

        if flags & SDL_WINDOW_OPENGL:

            self.gl_context = SDL_GL_CreateContext(self.window)

            if self.gl_context == NULL:
                self.destroy()
                raise error()

            if not ios:
                if SDL_GL_SetSwapInterval(default_swap_control) and SDL_GL_SetSwapInterval(-default_swap_control):
                    raise error()

            # For now, make this the size of the window so get_size() works.
            # TODO: Make this a bit less wasteful of memory, even if it means
            # we lie about the actual size of the pixel array.
            self.surface = Surface((w, h), SRCALPHA, 32)

        else:

            self.surface = Surface(())
            self.surface.surface = SDL_GetWindowSurface(self.window)
            self.surface.owns_surface = False

        self.surface.get_window_flags = self.get_window_flags

    def destroy(self):
        """
        This should be called before the window is deleted.
        """

        if self.gl_context != NULL:
            SDL_GL_DeleteContext(self.gl_context)

        if self.surface:
            # Break the cycle that prevents refcounting from collecting this
            # object.
            self.surface.get_window_flags = None

            # Necessary to collect the GL surface, doesn't hurt the window surface.
            self.surface = None

        SDL_DestroyWindow(self.window)

    def resize(self, size):
        """
        Resizes the window to `size`, which must be a width, height tuple.
        """

        cdef int cur_width = 0
        cdef int cur_height = 0

        width, height = size

        SDL_GetWindowSize(self.window, &cur_width, &cur_height)

        if (cur_width != width) or (cur_height != height):
            SDL_SetWindowSize(self.window, width, height)

        if self.gl_context:

            # Re-create the surface to reflect the new size.
            # TODO: Make this a bit less wasteful of memory, even if it means
            # we lie about the actual size of the pixel array.
            self.surface = Surface((width, height), SRCALPHA, 32)

        else:
            self.surface.get_window_flags = None

            self.surface = Surface(())
            self.surface.surface = SDL_GetWindowSurface(self.window)
            self.surface.owns_surface = False

    def get_window_flags(self):
        return SDL_GetWindowFlags(self.window)

    def flip(self):
        if self.gl_context != NULL:
            SDL_GL_SwapWindow(self.window)
        else:
            SDL_UpdateWindowSurface(self.window)

    def get_surface(self):

        return self.surface

    def update(self, rectangles=None):

        cdef SDL_Rect *rects
        cdef int count = 0

        if rectangles is None:
            self.flip()
            return

        if not isinstance(rectangles, list):
            rectangles = [ rectangles ]

        rects = <SDL_Rect *> calloc(len(rectangles), sizeof(SDL_Rect))
        if rects == NULL:
            raise MemoryError("Couldn't allocate rectangles.")

        try:

            for i in rectangles:
                if i is None:
                    continue

                to_sdl_rect(i, &rects[count])
                count += 1

            SDL_UpdateWindowSurfaceRects(self.window, rects, count)

        finally:
            free(rects)

    def get_wm_info(self):
        return { }

    def get_active(self):
        if SDL_GetWindowFlags(self.window) & (SDL_WINDOW_HIDDEN | SDL_WINDOW_MINIMIZED):
            return False
        else:
            return True

    def iconify(self):
        SDL_MinimizeWindow(self.window)
        return True

    def toggle_fullscreen(self):
        if SDL_GetWindowFlags(self.window) & (SDL_WINDOW_FULLSCREEN):
            if SDL_SetWindowFullscreen(self.window, 0):
                raise error()
        else:
            if SDL_SetWindowFullscreen(self.window, SDL_WINDOW_FULLSCREEN):
                raise error()

        return True

    def set_gamma(self, red, green=None, blue=None):
        if green is None:
            green = red
        if blue is None:
            blue = red

        cdef Uint16 red_gamma[256]
        cdef Uint16 green_gamma[256]
        cdef Uint16 blue_gamma[256]

        SDL_CalculateGammaRamp(red, red_gamma)
        SDL_CalculateGammaRamp(green, green_gamma)
        SDL_CalculateGammaRamp(blue, blue_gamma)

        if SDL_SetWindowGammaRamp(self.window, red_gamma, green_gamma, blue_gamma):
            return False

        return True

    def set_gamma_ramp(self, red, green, blue):

        cdef Uint16 red_gamma[256]
        cdef Uint16 green_gamma[256]
        cdef Uint16 blue_gamma[256]

        for i in range(256):
            red_gamma[i] = red[i]
            green_gamma[i] = green[i]
            blue_gamma[i] = blue[i]

        if SDL_SetWindowGammaRamp(self.window, red_gamma, green_gamma, blue_gamma):
            return False

        return True

    def set_icon(self, Surface surface):
        SDL_SetWindowIcon(self.window, surface.surface)

    def set_caption(self, title):

        if not isinstance(title, bytes):
            title = title.encode("utf-8")

        SDL_SetWindowTitle(self.window, title)


# The icon that's used for new windows.
default_icon = None

# The title that's used for new windows.
default_title = "pygame window"

# The default gl_swap_control
default_swap_control = 1

def set_mode(resolution=(0, 0), flags=0, depth=0):
    global main_window

    # If we're on android, we have to close the splash window before opening
    # our window.
    try:
        import androidembed
        androidembed.close_window()
    except ImportError:
        pass

    if main_window:

        if flags == main_window.create_flags:
            main_window.resize(resolution)
            return main_window.surface

        else:
            main_window.destroy()

    main_window = Window(default_title, resolution, flags, depth)

    if default_icon is not None:
        main_window.set_icon(default_icon)

    return main_window.surface

def get_surface():
    if main_window is None:
        return None

    return main_window.get_surface()

def flip():
    if main_window:
        main_window.flip()

def update(rectangles=None):
    if main_window:
        main_window.update(rectangles)

def get_driver():
    cdef const char *driver = SDL_GetCurrentVideoDriver()

    if driver == NULL:
        raise error()

    return driver

class Info(object):

    def __init__(self):
        cdef SDL_DisplayMode dm
        cdef SDL_PixelFormat *format

        if SDL_GetDesktopDisplayMode(0, &dm):
            raise error()

        format = SDL_AllocFormat(dm.format)
        if format == NULL:
            raise error()

        self.bitsize = format.BitsPerPixel
        self.bytesize = format.BytesPerPixel

        self.masks = (
            format.Rmask,
            format.Gmask,
            format.Bmask,
            format.Amask,
            )

        self.shifts = (
            format.Rshift,
            format.Gshift,
            format.Bshift,
            format.Ashift,
            )

        self.losses = (
            format.Rloss,
            format.Gloss,
            format.Bloss,
            format.Aloss,
            )

        SDL_FreeFormat(format)

        if main_window:
            self.current_w, self.current_h = main_window.surface.get_size()
        else:

            self.current_w = dm.w
            self.current_h = dm.h

        # The rest of these are just guesses.
        self.hw = False
        self.wm = True
        self.video_mem = 256 * 1024 * 1024

        self.blit_hw = False
        self.blit_hw_CC = False
        self.blit_hw_A = False

        self.blit_sw = False
        self.blit_sw_CC = False
        self.blit_sw_A = False

    def __repr__(self):
        return "<Info({!r})>".format(self.__dict__)


def get_wm_info():
    if main_window:
        return main_window.get_wm_info()

    return {}

def list_modes(depth=0, flags=SDL_WINDOW_FULLSCREEN):
    warnings.warn("pygame_sdl2.display.list_modes is not implemented.")
    return [ ]

def mode_ok(size, flags=0, depth=0):
    warnings.warn("pygame_sdl2.display.mode_ok is not implemented.")
    return True

def gl_reset_attributes():
    SDL_GL_ResetAttributes()

def gl_set_attribute(flag, value):

    if flag == GL_SWAP_CONTROL:
        if ios:
            return

        # Try value. If value is -1, this may fail if late tearing is not
        # supported, so we try 1 (vsync) instead.
        if main_window:
            if SDL_GL_SetSwapInterval(value) and SDL_GL_SetSwapInterval(-value):
                raise error()

        default_swap_control = value
        return

    if SDL_GL_SetAttribute(flag, value):
        raise error()

def gl_get_attribute(flag):
    cdef int rv

    if flag == GL_SWAP_CONTROL:
        return SDL_GL_GetSwapInterval()

    if SDL_GL_GetAttribute(flag, &rv):
        raise error()

    return rv

def gl_load_library(path):
    if path is None:
        if SDL_GL_LoadLibrary(NULL):
            raise error()
    else:
        if SDL_GL_LoadLibrary(path):
            raise error()

def gl_unload_library():
    SDL_GL_UnloadLibrary()

def get_active():
    if main_window:
        return main_window.get_active()
    return False

def iconify():
    if main_window:
        return main_window.iconify()

    return False

def toggle_fullscreen():
    if main_window:
        return main_window.toggle_fullscreen()

    return True

def set_gamma(red, green=None, blue=None):
    if main_window:
        return main_window.set_gamma(red, green, blue)
    return False

def set_gamma_ramp(red, green, blue):
    if main_window:
        return main_window.set_gamma_ramp(red, green, blue)
    return False

def set_icon(surface):
    global default_icon

    default_icon = surface.copy()

    if main_window is not None:
        main_window.set_icon(default_icon)

def set_caption(title, icontitle = None):
    global default_title

    default_title = title

    if main_window:
        main_window.set_caption(default_title)

def get_caption():
    return default_title


cdef api SDL_Window *PyWindow_AsWindow(window):
    """
    Returns a pointer to the SDL_Window corresponding to `window`. If `window`
    is None, a pointer to the main window is returned. NULL is returned if
    there is no main window.
    """

    if window is None:
        window = main_window

    if window is None:
        return NULL

    return (<Window> window).window
