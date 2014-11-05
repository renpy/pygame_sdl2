# Copyright 2014 Tom Rothamel <tom@rothamel.us>
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

from error import *

from surface import Surface
from rect import Rect

import display
import draw
import event
import font
import image
import joystick
import key
import locals # @ReservedAssignment
import mixer
import mouse
import time
import transform
import version

import sprite
import sysfont

import locals as constants
from locals import *

def init():
    event.init()
    display.init()
    time.init()
    image.init()
    font.init()
    joystick.init()
    mixer.init()

def quit():
    display.quit()

def import_as_pygame():
    """
    Imports pygame_sdl2 as pygame, so that running the 'import pygame.whatever'
    statement will import pygame_sdl2.whatever instead.
    """

    import sys, os, warnings

    if "PYGAME_SDL2_USE_PYGAME" in os.environ:
        return

    if "pygame" in sys.modules:
        warnings.warn("Pygame has already been imported, import_as_pygame may not work.", stacklevel=2)

    for name, mod in list(sys.modules.items()):
        name = name.split('.')
        if name[0] != 'pygame_sdl2':
            continue

        name[0] = 'pygame'
        name = ".".join(name)

        sys.modules[name] = mod

    sys.modules['pygame.constants'] = constants

def get_sdl_byteorder():
    return BYTEORDER

def get_sdl_version():
    return SDL_VERSION_TUPLE

# We have new-style buffers, but not the pygame.newbuffer module.
HAVE_NEWBUF = False
