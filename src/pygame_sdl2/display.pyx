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
from pygame_sdl2.locals import SRCALPHA
from pygame_sdl2.error import error

import warnings

# True if init has been called without quit being called.
init_done = False

# The window that is used by the various module globals.
main_window = None

def init():
    SDL_Init(SDL_INIT_VIDEO)

    global init_done
    init_done = True

def quit(): # @ReservedAssignment

    global init_done
    global main_window

    if main_window:
        main_window.destroy()
        main_window = None

    init_done = False

def get_init():
    return init_done


cdef class Window:
    def __init__(self, resolution=(0, 0), flags=0, depth=0):

        self.window = SDL_CreateWindow(
            b"pygame window",
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

    def get_window_flags(self):
        return SDL_GetWindowFlags(self.window)

    def flip(self):
        if self.gl_context != NULL:
            SDL_GL_SwapWindow(self.window)

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


def set_mode(resolution=(0, 0), flags=0, depth=0):
    global main_window

    main_window = Window(resolution, flags, depth)
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



