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
from surface cimport Surface

import gfxdraw
from rect import Rect

def line(Surface surface, color, start_pos, end_pos, width=1):
    gfxdraw.thick_line(surface, start_pos[0], start_pos[1],
                       end_pos[0], end_pos[1], width, color)
    dirty = Rect(start_pos, (width, width))
    dirty.union_ip(Rect(end_pos, (width, width)))
    return dirty.clip(surface.get_rect())

def lines(Surface surface, color, closed, pointlist, width=1):
    n = 0
    dirty = Rect(pointlist[0], (width, width))
    while n < len(pointlist) - 1:
        line(surface, color, pointlist[n], pointlist[n+1], width)
        dirty.union_ip(Rect(pointlist[n+1], (width, width)))
        n += 1
    if closed:
        line(surface, color, pointlist[n], pointlist[0], width)
    return dirty.clip(surface.get_rect())
