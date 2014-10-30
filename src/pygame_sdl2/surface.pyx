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

from pygame_sdl2.error import error
import pygame_sdl2

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
            if SDL_FillRect(self.surface, &sdl_rect, pixel):
                raise error()
        else:
            if SDL_FillRect(self.surface, NULL, pixel):
                raise error()

    def blit(self, Surface source, dest, area=None, special_flags=0):
        cdef SDL_Rect dest_rect
        cdef SDL_Rect area_rect
        cdef SDL_Rect *area_ptr = NULL

        SDL_SetSurfaceBlendMode(source.surface, SDL_BLENDMODE_BLEND)

        to_sdl_rect(dest, &dest_rect, "dest")

        if area is not None:
            to_sdl_rect(area, &area_rect, "area")
            area_ptr = &area_rect

        if SDL_UpperBlit(source.surface, area_ptr, self.surface, &dest_rect):
            raise error()

    def get_size(self):
        return self.surface.w, self.surface.h

    def convert(self, surface=None):
        if not isinstance(surface, Surface):
            surface = pygame_sdl2.display.get_surface()

        if surface is None:
            raise error("No video mode has been set.")

        cdef SDL_PixelFormat *sample_format = (<Surface> surface).surface.format

        cdef Uint32 amask
        cdef Uint32 rmask
        cdef Uint32 gmask
        cdef Uint32 bmask

        cdef Uint32 pixel_format
        cdef SDL_Surface *new_surface

        # If the sample surface has alpha, use it.
        if not sample_format.Amask:
            use_format = sample_format
            new_surface = SDL_ConvertSurface(self.surface, sample_format, 0)

        else:

            rmask = sample_format.Rmask
            gmask = sample_format.Gmask
            bmask = sample_format.Bmask
            amask = 0

            pixel_format = SDL_MasksToPixelFormatEnum(32, rmask, gmask, bmask, amask)
            new_surface = SDL_ConvertSurfaceFormat(self.surface, pixel_format, 0)

        cdef Surface rv = Surface(())
        rv.surface = new_surface

        return rv

    def convert_alpha(self, Surface surface=None):
        if surface is None:
            surface = pygame_sdl2.display.get_surface()

        if surface is None:
            raise error("No video mode has been set.")

        cdef SDL_PixelFormat *sample_format = surface.surface.format

        cdef Uint32 amask = 0xff000000
        cdef Uint32 rmask = 0x00ff0000
        cdef Uint32 gmask = 0x0000ff00
        cdef Uint32 bmask = 0x000000ff

        cdef Uint32 pixel_format
        cdef SDL_Surface *new_surface

        # If the sample surface has alpha, use it.
        if sample_format.Amask:
            use_format = sample_format
            new_surface = SDL_ConvertSurface(self.surface, sample_format, 0)

        else:

            if sample_format.BytesPerPixel == 4:
                rmask = sample_format.Rmask
                gmask = sample_format.Gmask
                bmask = sample_format.Bmask
                amask = 0xffffffff & ~(rmask | gmask | bmask)

            pixel_format = SDL_MasksToPixelFormatEnum(32, rmask, gmask, bmask, amask)
            new_surface = SDL_ConvertSurfaceFormat(self.surface, pixel_format, 0)

        cdef Surface rv = Surface(())
        rv.surface = new_surface

        return rv

    def get_masks(self):
        cdef SDL_PixelFormat *format = self.surface.format
        return (format.Rmask, format.Gmask, format.Bmask, format.Amask)

