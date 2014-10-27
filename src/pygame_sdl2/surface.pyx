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
from color cimport map_color
from rect cimport to_sdl_rect

cdef class Surface:

    def __cinit__(self):
        self.surface = NULL
        self.owns_surface = False

    def __dealloc__(self):
        if self.surface and self.owns_surface:
            SDL_FreeSurface(self.surface)

    def __init__(self, size, flags=0, depth=32, masks=None):
        try:
            w, h = size
            assert isinstance(w, int)
            assert isinstance(h, int)
            assert w >= 0
            assert h >= 0
        except:

            # We pass the empty tuple to create an empty surface, that we can
            # add an SDL surface to.
            if size == ():
                return

        self.surface = SDL_CreateRGBSurface(0, w, h, depth, 0, 0, 0, 0)
        self.owns_surface = True

    def fill(self, color, rect=None):

        cdef SDL_Rect sdl_rect
        cdef Uint32 pixel = map_color(self.surface, color)

        if rect is not None:
            to_sdl_rect(rect, &sdl_rect)
            SDL_FillRect(self.surface, &sdl_rect, pixel)
        else:
            SDL_FillRect(self.surface, NULL, pixel)

