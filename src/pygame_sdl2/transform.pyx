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
from sdl2_gfx cimport *
from surface cimport *
from error import error

cdef Surface render_copy(Surface surf_in, double degrees, SDL_RendererFlip rflip):
    w, h = surf_in.surface.w, surf_in.surface.h
    if degrees != 0.0:
        raise error("Don't use this function for rotation.")

    cdef Surface surf_out = Surface((w, h))
    cdef SDL_Renderer *render = NULL
    cdef SDL_Texture *texture_in = NULL

    render = SDL_CreateSoftwareRenderer(surf_out.surface)
    if render == NULL:
        raise error()

    texture_in = SDL_CreateTextureFromSurface(render, surf_in.surface)
    if texture_in == NULL:
        SDL_DestroyRenderer(render)
        raise error()

    if SDL_RenderCopyEx(render, texture_in, NULL, NULL, degrees, NULL, rflip) != 0:
        SDL_DestroyTexture(texture_in)
        SDL_DestroyRenderer(render)
        raise error()

    SDL_DestroyTexture(texture_in)
    SDL_DestroyRenderer(render)
    return surf_out

def flip(Surface surface, xbool, ybool):
    cdef SDL_RendererFlip rflip = SDL_FLIP_HORIZONTAL if xbool else SDL_FLIP_NONE
    if ybool:
        rflip = <SDL_RendererFlip>(rflip | SDL_FLIP_VERTICAL)
    return render_copy(surface, 0.0, rflip)

def scale(Surface surface, size, Surface DestSurface=None):
    w, h = size
    cdef Surface surf_out
    if DestSurface == None:
        surf_out = Surface(size)
    else:
        surf_out = DestSurface

    cdef SDL_Rect dstrect
    dstrect.x = 0
    dstrect.y = 0
    dstrect.w = w
    dstrect.h = h
    if SDL_UpperBlitScaled(surface.surface, NULL, surf_out.surface, &dstrect) != 0:
        raise error()
    return surf_out

def rotate(Surface surface, angle):
    # rotateSurface90Degrees always returns NULL without setting an error??
    # cdef SDL_Surface *rsurf
    # if angle % 90 == 0:
    #     rsurf = rotateSurface90Degrees(surface.surface, angle / 90)
    #     if rsurf == NULL:
    #        raise error()
    return rotozoom(surface, angle, 1.0, SMOOTHING_OFF)

def rotozoom(Surface surface, angle, scale, smooth=1):
    cdef SDL_Surface *rsurf = NULL
    cdef Surface rv

    rsurf = rotozoomSurface(surface.surface, angle, scale, smooth)
    if rsurf == NULL:
        raise error()
    rv = Surface(())
    rv.surface = rsurf
    rv.owns_surface = True
    return rv

cdef uint32_t get_at(SDL_Surface *surf, int x, int y):
    if x < 0:
        x = 0
    elif x >= surf.w:
        x = surf.w - 1
    if y < 0:
        y = 0
    elif y >= surf.h:
        y = surf.h - 1

    cdef uint32_t *p = <uint32_t*>surf.pixels
    p += y * (surf.pitch / sizeof(uint32_t))
    p += x
    return p[0]

cdef void set_at(SDL_Surface *surf, int x, int y, uint32_t color):
    cdef uint32_t *p = <uint32_t*>surf.pixels
    p += y * (surf.pitch / sizeof(uint32_t))
    p += x
    p[0] = color

def scale2x(Surface surface, Surface DestSurface=None):
    cdef int x, y

    cdef uint32_t a, b, c, d, e, f, g, h, i
    cdef uint32_t e0, e1, e2, e3

    cdef Surface surf_out = DestSurface
    if surf_out == None:
        surf_out = Surface((surface.get_width()*2, surface.get_height()*2))

    if surface.get_bytesize() != 4:
        raise error("Surface has unsupported bytesize.")

    surface.lock()
    surf_out.lock()

    for x in range(surface.get_width()):
        for y in range(surface.get_height()):
            # Get the surrounding 9 pixels.
            a = get_at(surface.surface, x - 1, y - 1)
            b = get_at(surface.surface, x, y - 1)
            c = get_at(surface.surface, x + 1, y - 1)

            d = get_at(surface.surface, x - 1, y)
            e = get_at(surface.surface, x, y)
            f = get_at(surface.surface, x + 1, y)

            g = get_at(surface.surface, x - 1, y + 1)
            h = get_at(surface.surface, x, y + 1)
            i = get_at(surface.surface, x + 1, y + 1)

            # Expand the center pixel.
            if b != h and d != f:
                e0 = d if d == b else e
                e1 = f if b == f else e
                e2 = d if d == h else e
                e3 = f if h == f else e
            else:
                e0 = e1 = e2 = e3 = e

            set_at(surf_out.surface, x*2, y*2, e0)
            set_at(surf_out.surface, (x*2)+1, y*2, e1)
            set_at(surf_out.surface, x*2, (y*2)+1, e2)
            set_at(surf_out.surface, (x*2)+1, (y*2)+1, e3)

    surf_out.unlock()
    surface.unlock()

    return surf_out

def smoothscale(Surface surface, size, Surface DestSurface=None):
    cdef double scale_x = size[0] / <double>surface.surface.w
    cdef double scale_y = size[1] / <double>surface.surface.h

    cdef SDL_Surface *rsurf = NULL
    cdef Surface rv
    rsurf = rotozoomSurfaceXY(surface.surface, 0.0, scale_x, scale_y, SMOOTHING_ON)
    if rsurf == NULL:
        raise error()
    rv = Surface(())
    rv.surface = rsurf
    rv.owns_surface = True

    # This is inefficient.
    if DestSurface:
        DestSurface.blit(rv, (0,0))

    return rv
