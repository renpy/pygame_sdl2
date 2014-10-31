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

from libc.string cimport memmove
from sdl2 cimport *

from color cimport map_color, get_color
from rect cimport to_sdl_rect

from pygame_sdl2.error import error
import pygame_sdl2


cdef void move_pixels(Uint8 *src, Uint8 *dst, int h, int span, int srcpitch, int dstpitch):
    if src < dst:
        src += (h - 1) * srcpitch;
        dst += (h - 1) * dstpitch;
        srcpitch = -srcpitch;
        dstpitch = -dstpitch;

    while h:
        h -= 1
        memmove(dst, src, span);
        src += srcpitch;
        dst += dstpitch;



cdef class Surface:

    def __cinit__(self):
        self.surface = NULL
        self.owns_surface = False

    def __dealloc__(self):
        if self.surface and self.owns_surface:
            SDL_FreeSurface(self.surface)

    def __init__(self, size, flags=0, depth=32, masks=None):

        self.locklist = None
        self.parent = None
        self.root = self

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

    def copy(self):
        if self.surface.format.Amask:
            return self.convert_alpha(self)
        else:
            return self.convert(self)

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

    def get_size(self):
        return self.surface.w, self.surface.h

    def get_masks(self):
        cdef SDL_PixelFormat *format = self.surface.format
        return (format.Rmask, format.Gmask, format.Bmask, format.Amask)

    def scroll(self, int dx=0, int dy=0):
        cdef int srcx, destx, move_width
        cdef int srcy, desty, move_height

        cdef int width = self.surface.w
        cdef int height = self.surface.h

        cdef int per_pixel = self.surface.format.BytesPerPixel

        if dx >= 0:
            srcx = 0
            destx = dx
            move_width = width - dx
        else:
            srcx = -dx
            destx = 0
            move_width = width + dx

        if dy >= 0:
            srcy = 0
            desty = dy
            move_height = height - dy
        else:
            srcy = -dy
            desty = 0
            move_height = height + dy

        cdef Uint8 *srcptr = <Uint8 *> self.surface.pixels
        cdef Uint8 *destptr = <Uint8 *> self.surface.pixels

        srcptr += srcy * self.surface.pitch + srcx * per_pixel
        destptr += desty * self.surface.pitch + destx * per_pixel

        self.lock()

        move_pixels(
            srcptr,
            destptr,
            move_height,
            move_width * per_pixel,
            self.surface.pitch,
            self.surface.pitch)

        self.unlock()

    def set_colorkey(self, color, flags=0):
        if color is None:
            if SDL_SetColorKey(self.surface, SDL_FALSE, 0):
                raise error()
        else:
            if SDL_SetColorKey(self.surface, SDL_TRUE, map_color(self.surface, color)):
                raise error()

    def get_colorkey(self):
        cdef Uint32 key

        if SDL_GetColorKey(self.surface, &key):
            return None

        return get_color(key, self.surface)

    def set_alpha(self, value, flags=0):
        if value is None:
            value = 255

        if SDL_SetSurfaceAlphaMod(self.surface, value):
            raise error()

    def get_alpha(self):
        cdef Uint8 rv

        if SDL_GetSurfaceAlphaMod(self.surface, &rv):
            raise error()

        return rv

    def lock(self, lock=None):
        cdef Surface root = self.root

        if lock is None:
            lock = self

        if root.locklist is None:
            root.locklist = [ ]

        root.locklist.append(lock)

        SDL_LockSurface(root.surface)

    def unlock(self, lock=None):
        cdef Surface root = self.root

        if lock is None:
            lock = self

        if root.locklist is None:
            root.locklist = [ ]

        root.locklist.remove(lock)

        SDL_UnlockSurface(root.surface)

    def mustlock(self):
        return SDL_MUSTLOCK(self.root.surface)

    def get_locked(self):
        if self.locklist:
            return True

    def get_locks(self):
        cdef Surface root = self.root

        if root.locklist is None:
            root.locklist = [ ]

        return root.locklist


