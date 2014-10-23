# Copyright 2014 Patrick Dawson
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

def init():
    SDL_Init(SDL_INIT_VIDEO)

def quit():
    pass

cdef class Window:

    cdef SDL_Window *window
    cdef public Surface surface

    def __init__(self, resolution=(0, 0), flags=0, depth=0):
        self.window = SDL_CreateWindow(
            b"pygame window",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            resolution[0], resolution[1], SDL_WINDOW_SHOWN)

        self.surface = Surface(())
        self.surface.surface = SDL_GetWindowSurface(self.window)
        self.surface.owns_surface = False

    def flip(self):
        SDL_UpdateWindowSurface(self.window)

cdef Window main_window = None

def set_mode(resolution=(0, 0), flags=0, depth=0):
    global main_window

    main_window = Window(resolution, flags, depth)
    return main_window.surface

def flip():
    if main_window:
        main_window.flip()

