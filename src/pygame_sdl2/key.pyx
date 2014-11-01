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
from error import error

include "scancode_dict.pxi"

cdef class KeyboardState:
    cdef object data
    def __init__(self, data):
        self.data = data

    def __repr__(self):
        return str(self.data)

    def __getitem__(self, key):
        return self.data[scancodes[key]]


def init():
    pass

def quit():
    pass

def get_focused():
    return SDL_GetKeyboardFocus() != NULL

def get_pressed():
    cdef int numkeys
    cdef const Uint8 *state = SDL_GetKeyboardState(&numkeys)
    # Take a snapshot of the current state, insetad of using pointer directly.
    ret = [0] * numkeys
    for n in range(numkeys):
        if state[n]:
            ret[n] = 1
    return KeyboardState(tuple(ret))

def get_mods():
    return SDL_GetModState()

def set_mods(state):
    SDL_SetModState(state)

def set_repeat(delay=0, interval=0):
    # Not possible with SDL2.
    pass

def get_repeat():
    # Not possible with SDL2.
    return (0,0)

def name(key):
    return SDL_GetKeyName(key)
