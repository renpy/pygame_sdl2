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
from libc.stdlib cimport malloc, free
from pygame_sdl2.surface cimport Surface
from pygame_sdl2.color cimport map_color

from pygame_sdl2.error import error
from pygame_sdl2.rect import Rect

cdef class DrawArgs:
    cdef SDL_Renderer *renderer
    cdef uint32_t color

    def __cinit__(self):
        self.renderer = NULL
        self.color = 0

    def __dealloc__(self):
        if self.renderer:
            SDL_DestroyRenderer(self.renderer)

    def __init__(self, Surface surf, c):
        if surf is None:
            raise error("Surface is None.")

        if c is not None:
            self.color = map_color(surf.surface, c)

        self.renderer = SDL_CreateSoftwareRenderer(surf.surface)
        if self.renderer == NULL:
            raise error()

def pixel(Surface surface, x, y, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    pixelColor(da.renderer, x, y, da.color)
    del da

def hline(Surface surface, x1, x2, y, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    hlineColor(da.renderer, x1, x2, y, da.color)
    del da

def vline(Surface surface, x, y1, y2, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    vlineColor(da.renderer, x, y1, y2, da.color)
    del da

def rectangle(Surface surface, rect, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    if not isinstance(rect, Rect):
        rect = Rect(rect)
    rectangleColor(da.renderer, rect.x, rect.y, rect.x + rect.w, rect.y + rect.h, da.color)
    del da

def rounded_rectangle(Surface surface, rect, rad, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    if not isinstance(rect, Rect):
        rect = Rect(rect)
    roundedRectangleColor(da.renderer, rect.x, rect.y, rect.x + rect.w, rect.y + rect.h, rad, da.color)
    del da

def box(Surface surface, rect, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    if not isinstance(rect, Rect):
        rect = Rect(rect)
    boxColor(da.renderer, rect.x, rect.y, rect.x + rect.w, rect.y + rect.h, da.color)
    del da

def rounded_box(Surface surface, rect, rad, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    if not isinstance(rect, Rect):
        rect = Rect(rect)
    roundedBoxColor(da.renderer, rect.x, rect.y, rect.x + rect.w, rect.y + rect.h, rad, da.color)
    del da

def line(Surface surface, x1, y1, x2, y2, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    lineColor(da.renderer, x1, y1, x2, y2, da.color)
    del da

def aaline(Surface surface, x1, y1, x2, y2, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    aalineColor(da.renderer, x1, y1, x2, y2, da.color)
    del da

def thick_line(Surface surface, x1, y1, x2, y2, width, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    thickLineColor(da.renderer, x1, y1, x2, y2, width, da.color)
    del da

def circle(Surface surface, x, y, r, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    circleColor(da.renderer, x, y, r, da.color)
    del da

def arc(Surface surface, x, y, r, start, end, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    arcColor(da.renderer, x, y, r, start, end, da.color)
    del da

def aacircle(Surface surface, x, y, r, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    aacircleColor(da.renderer, x, y, r, da.color)
    del da

def filled_circle(Surface surface, x, y, r, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    filledCircleColor(da.renderer, x, y, r, da.color)
    del da

def ellipse(Surface surface, x, y, rx, ry, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    ellipseColor(da.renderer, x, y, rx, ry, da.color)
    del da

def aaellipse(Surface surface, x, y, rx, ry, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    aaellipseColor(da.renderer, x, y, rx, ry, da.color)
    del da

def filled_ellipse(Surface surface, x, y, rx, ry, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    filledEllipseColor(da.renderer, x, y, rx, ry, da.color)
    del da

def pie(Surface surface, x, y, r, start, end, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    pieColor(da.renderer, x, y, r, start, end, da.color)
    del da

def filled_pie(Surface surface, x, y, r, start, end, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    filledPieColor(da.renderer, x, y, r, start, end, da.color)
    del da

def trigon(Surface surface, x1, y1, x2, y2, x3, y3, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    trigonColor(da.renderer, x1, y1, x2, y2, x3, y3, da.color)
    del da

def aatrigon(Surface surface, x1, y1, x2, y2, x3, y3, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    aatrigonColor(da.renderer, x1, y1, x2, y2, x3, y3, da.color)
    del da

def filled_trigon(Surface surface, x1, y1, x2, y2, x3, y3, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    filledTrigonColor(da.renderer, x1, y1, x2, y2, x3, y3, da.color)
    del da

def polygon(Surface surface, points, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    cdef Sint16 *vx
    cdef Sint16 *vy
    cdef size_t num_points = len(points)
    vx = <Sint16*>malloc(num_points * sizeof(Sint16))
    vy = <Sint16*>malloc(num_points * sizeof(Sint16))
    for n, pt in zip(range(num_points), points):
        vx[n], vy[n] = points[n]
    polygonColor(da.renderer, vx, vy, num_points, da.color)
    free(vx)
    free(vy)
    del da

def aapolygon(Surface surface, points, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    cdef Sint16 *vx
    cdef Sint16 *vy
    cdef size_t num_points = len(points)
    vx = <Sint16*>malloc(num_points * sizeof(Sint16))
    vy = <Sint16*>malloc(num_points * sizeof(Sint16))
    for n, pt in zip(range(num_points), points):
        vx[n], vy[n] = points[n]
    aapolygonColor(da.renderer, vx, vy, num_points, da.color)
    free(vx)
    free(vy)
    del da

def filled_polygon(Surface surface, points, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    cdef Sint16 *vx
    cdef Sint16 *vy
    cdef size_t num_points = len(points)
    vx = <Sint16*>malloc(num_points * sizeof(Sint16))
    vy = <Sint16*>malloc(num_points * sizeof(Sint16))
    for n, pt in zip(range(num_points), points):
        vx[n], vy[n] = points[n]
    filledPolygonColor(da.renderer, vx, vy, num_points, da.color)
    free(vx)
    free(vy)
    del da

def textured_polygon(Surface surface, points, Surface texture not None, tx, ty):
    cdef DrawArgs da = DrawArgs(surface, None)
    cdef Sint16 *vx
    cdef Sint16 *vy
    cdef size_t num_points = len(points)
    vx = <Sint16*>malloc(num_points * sizeof(Sint16))
    vy = <Sint16*>malloc(num_points * sizeof(Sint16))
    for n, pt in zip(range(num_points), points):
        vx[n], vy[n] = points[n]
    texturedPolygon(da.renderer, vx, vy, num_points, texture.surface, tx, ty)
    free(vx)
    free(vy)
    del da

def bezier(Surface surface, points, steps, color):
    cdef DrawArgs da = DrawArgs(surface, color)
    cdef Sint16 *vx
    cdef Sint16 *vy
    cdef size_t num_points = len(points)
    vx = <Sint16*>malloc(num_points * sizeof(Sint16))
    vy = <Sint16*>malloc(num_points * sizeof(Sint16))
    for n, pt in zip(range(num_points), points):
        vx[n], vy[n] = points[n]
    bezierColor(da.renderer, vx, vy, num_points, steps, da.color)
    free(vx)
    free(vy)
    del da
