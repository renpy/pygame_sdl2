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
from surface cimport *
from error import error

cdef Surface render_copy(Surface surf_in, double degrees, SDL_RendererFlip rflip):
    w, h = surf_in.surface.w, surf_in.surface.h
    if degrees != 0.0:
        # TODO: Calculate new rotated surface size.
        if degrees / 90 % 2 == 1.0:
            # This doesn't work as intended. Why?
            w, h = h, w

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
    return render_copy(surface, angle, SDL_FLIP_NONE)

def rotozoom(Surface surface, angle, scale):
    # TODO: Requires SDL_gfx.
    pass

def scale2x(Surface surface, Surface DestSurface=None):
    # TODO: Implement scale2x from scratch, because the original code is GPL and
    # pygame’s is LGPL. http://scale2x.sourceforge.net/algorithm.html
    return scale(surface, (surface.surface.w*2, surface.surface.h*2), DestSurface)

def smoothscale(Surface surface, size, Surface DestSurface=None):
    # Maybe just use SDL_HINT_RENDER_SCALE_QUALITY = 1
    return scale(surface, size, DestSurface)
