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
from sdl2_ttf cimport *
from pygame_sdl2.surface cimport *
from pygame_sdl2.color cimport *
from pygame_sdl2.rwobject cimport to_rwops

from pygame_sdl2.sysfont import SysFont, match_font, get_fonts
from pygame_sdl2.error import error
import pygame_sdl2

@pygame_sdl2.register_init
def init():
    TTF_Init()

@pygame_sdl2.register_quit
def quit(): # @ReservedAssignment
    TTF_Quit()

def get_init():
    return TTF_WasInit() != 0

def get_default_font():
    import os

    default = os.path.join(os.path.dirname(__file__), "DejaVuSans.ttf")

    if os.path.exists(default):
        return default

    return match_font("sans")

cdef class Font:
    cdef TTF_Font *font
    cdef int style

    def __cinit__(self):
        self.font = NULL
        self.style = TTF_STYLE_NORMAL

    def __dealloc__(self):
        if self.font:
            TTF_CloseFont(self.font)

    def __init__(self, fi, size):
        if fi is None:
            fi = get_default_font()
        self.font = TTF_OpenFontRW(to_rwops(fi), 1, size)
        if self.font == NULL:
            raise error()

    def render(self, text, antialias, color, background=None):
        cdef SDL_Surface *surf
        cdef SDL_Color fg

        if not text:
            w, h = self.size(" ")
            return Surface((0, h))

        to_sdl_color(color, &fg)

        TTF_SetFontStyle(self.font, self.style)
        if antialias:
            surf = TTF_RenderUTF8_Blended(self.font, text.encode('utf-8'), fg)
        else:
            surf = TTF_RenderUTF8_Solid(self.font, text.encode('utf-8'), fg)

        if surf == NULL:
            raise error()

        cdef Surface rv = Surface(())
        rv.take_surface(surf)

        if rv.surface.format.BitsPerPixel != 32:
            rv = rv.convert()

        if background is not None:
            bgsurf = rv.copy()
            bgsurf.fill(background)
            bgsurf.blit(rv, (0,0))
            return bgsurf
        return rv

    def size(self, text):
        cdef int w, h
        if TTF_SizeUTF8(self.font, text.encode('utf-8'), &w, &h) != 0:
            raise error()
        return w, h

    cdef set_style(self, flag, on):
        if on:
            self.style |= flag
        else:
            self.style &= ~flag

    def set_underline(self, on):
        self.set_style(TTF_STYLE_UNDERLINE, on)

    def get_underline(self):
        return self.style & TTF_STYLE_UNDERLINE

    def set_bold(self, on):
        self.set_style(TTF_STYLE_BOLD, on)

    def get_bold(self):
        return self.style & TTF_STYLE_BOLD

    def set_italic(self, on):
        self.set_style(TTF_STYLE_ITALIC, on)

    def get_italic(self):
        return self.style & TTF_STYLE_ITALIC

    def get_linesize(self):
        return TTF_FontLineSkip(self.font)

    def get_height(self):
        return TTF_FontHeight(self.font)

    def get_ascent(self):
        return TTF_FontAscent(self.font)

    def get_descent(self):
        return TTF_FontDescent(self.font)

    def metrics(self, text not None):
        cdef int minx, maxx, miny, maxy, advance
        cdef uint16_t chnum
        rv = []

        for ch in text:
            chnum = ord(ch)

            if TTF_GlyphMetrics(self.font, chnum, &minx, &maxx, &miny, &maxy, &advance) == 0:
                rv.append((minx, maxx, miny, maxy, advance))
            else:
                rv.append(None)

        return rv
