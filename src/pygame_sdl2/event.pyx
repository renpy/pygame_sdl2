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

include "event_names.pxi"

class EventType:
    def __init__(self, type, dict=None, **kwargs):
        self.type = type

        if dict:
            self.__dict__.update(dict)

        self.__dict__.update(kwargs)

Event = EventType

cdef make_event(SDL_Event *e):
    return EventType(e.type)

def wait():
    cdef SDL_Event evt

    if SDL_WaitEvent(&evt):
        return make_event(&evt)
    else:
        return EventType(0) # NOEVENT

def init():
    SDL_Init(SDL_INIT_EVENTS)
