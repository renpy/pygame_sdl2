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
import json

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
            self.renderer = SDL_GetRenderer(window.window)
            if self.renderer == NULL:
                raise error()

    def load_texture(self, fi):
        cdef SDL_Texture *tex
        cdef Texture t = Texture()

        if isinstance(fi, Surface):
            tex = SDL_CreateTextureFromSurface(self.renderer, (<Surface>fi).surface)
        else:
            tex = IMG_LoadTexture_RW(self.renderer, to_rwops(fi), 1)
        if tex == NULL:
            raise error()
        t.set(tex)
        return TextureInstance(t)

    def load_atlas(self, fn):
        """ Loads a file in the popular JSON (Hash) format exported by
            TexturePacker and other software. """
        jdata = json.load(open(fn,"r"))
        image = jdata["meta"]["image"]
        cdef TextureInstance ti = self.load_texture(image)
        return TextureAtlas(ti, jdata)

    def clear(self, color):
        if not isinstance(color, Color):
            color = Color(color)
        SDL_SetRenderDrawColor(self.renderer, color.r, color.g, color.b, color.a)
        SDL_RenderClear(self.renderer)

    def render(self, TextureInstance ti not None, dest):
        cdef SDL_Rect dest_rect
        cdef SDL_Rect area_rect
        cdef SDL_Rect *area_ptr = NULL

        to_sdl_rect(dest, &dest_rect, "dest")
        dest_rect.x += ti.trimmed_rect.x
        dest_rect.y += ti.trimmed_rect.y
        dest_rect.w = ti.trimmed_rect.w
        dest_rect.h = ti.trimmed_rect.h

        SDL_RenderCopy(self.renderer, ti.texture.texture, &ti.source_rect, &dest_rect)

    def render_present(self):
        SDL_RenderPresent(self.renderer)

    def info(self):
        cdef SDL_RendererInfo rinfo
        if SDL_GetRendererInfo(self.renderer, &rinfo) != 0:
            raise error()

        # Ignore texture_formats for now.
        return {
            "name" : rinfo.name,
            "accelerated" : rinfo.flags & SDL_RENDERER_ACCELERATED != 0,
            "vsync" : rinfo.flags & SDL_RENDERER_PRESENTVSYNC != 0,
            "rtt" : rinfo.flags & SDL_RENDERER_TARGETTEXTURE != 0,
            "max_texture_width" : rinfo.max_texture_width,
            "max_texture_height" : rinfo.max_texture_height,
        }


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
    cdef SDL_Rect source_rect
    cdef SDL_Rect trimmed_rect
    cdef int source_w
    cdef int source_h

    def __init__(self, tex):
        if isinstance(tex, Texture):
            self.texture = tex
        elif isinstance(tex, TextureInstance):
            self.texture = (<TextureInstance>tex).texture
        else:
            raise ValueError()

cdef class TextureAtlas:
    cdef object frames

    def __init__(self, TextureInstance ti, jdata):
        self.frames = {}

        cdef TextureInstance itex
        for itm in jdata["frames"].iteritems():
            iname, idict = itm
            itex = TextureInstance(ti)
            f = idict["frame"]
            to_sdl_rect((f['x'], f['y'], f['w'], f['h']), &itex.source_rect, "frame")
            f = idict["spriteSourceSize"]
            to_sdl_rect((f['x'], f['y'], f['w'], f['h']), &itex.trimmed_rect, "spriteSourceSize")
            if idict["rotated"]:
                raise error("Rotation not supported yet.")
            itex.source_w = idict["sourceSize"]["w"]
            itex.source_h = idict["sourceSize"]["h"]

            self.frames[iname] = itex

    def __getitem__(self, key):
        return self.frames[key]
