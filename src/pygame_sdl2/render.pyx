# Copyright 2014 Patrick Dawson <pat@dw.is>
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
from sdl2_image cimport *
from display cimport *
from surface cimport *
from rwobject cimport to_rwops
from rect cimport to_sdl_rect

from rect import Rect
from error import error
from color import Color

cdef class Renderer:
    cdef SDL_Renderer *renderer

    def __cinit__(self):
        self.renderer = NULL

    def __dealloc__(self):
        if self.renderer:
            SDL_DestroyRenderer(self.renderer)

    def __init__(self, Window window=None):
        if window is None:
            window = main_window
        cdef uint32_t flags = SDL_RENDERER_ACCELERATED
        self.renderer = SDL_CreateRenderer(window.window, -1, flags)
        if self.renderer == NULL:
            raise error()

    def load_texture(self, fi):
        cdef SDL_Texture *tex
        tex = IMG_LoadTexture_RW(self.renderer, to_rwops(fi), 1)
        if tex == NULL:
            raise error()
        cdef Texture t = Texture()
        t.set(tex)
        return TextureInstance(t)

    def clear(self, color):
        if not isinstance(color, Color):
            color = Color(color)
        SDL_SetRenderDrawColor(self.renderer, color.r, color.g, color.b, color.a)
        SDL_RenderClear(self.renderer)

    def render(self, TextureInstance tex not None, dest, area=None):
        cdef SDL_Rect dest_rect
        cdef SDL_Rect area_rect
        cdef SDL_Rect *area_ptr = NULL

        to_sdl_rect(dest, &dest_rect, "dest")
        dest_rect.w = tex.texture.w
        dest_rect.h = tex.texture.h

        if area is not None:
            to_sdl_rect(area, &area_rect, "area")
            area_ptr = &area_rect

        SDL_RenderCopyEx(self.renderer, tex.texture.texture, area_ptr, &dest_rect, 0.0, NULL, SDL_FLIP_NONE)

    def render_present(self):
        SDL_RenderPresent(self.renderer)


cdef class Texture:
    """ This is just for garbage-collecting SDL_Texture pointers. Users should
        never see it. """

    cdef SDL_Texture *texture
    cdef int w, h

    def __cinit__(self):
        self.texture = NULL

    def __dealloc__(self):
        if self.texture:
            SDL_DestroyTexture(self.texture)

    cdef set(self, SDL_Texture *tex):
        cdef Uint32 format
        cdef int access, w, h

        self.texture = tex

        if SDL_QueryTexture(self.texture, &format, &access, &w, &h) != 0:
            raise error()

        self.w = w
        self.h = h


cdef class TextureInstance:
    """ Can be cropped, rotated, etc. """

    cdef Texture texture

    def __init__(self, tex):
        if isinstance(tex, Texture):
            self.texture = tex
        elif isinstance(tex, TextureInstance):
            self.texture = tex.texture
        else:
            raise ValueError()
