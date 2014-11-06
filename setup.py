#!/usr/bin/env python

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

from setuplib import cython, pymodule, setup, parse_cflags, parse_libs, find_unnecessary_gen
import os

parse_cflags("sdl2-config --cflags")
sdl_libs = parse_libs("sdl2-config --libs")

pymodule("pygame_sdl2.__init__")
pymodule("pygame_sdl2.compat")
pymodule("pygame_sdl2.threads.__init__")
pymodule("pygame_sdl2.threads.Py25Queue")
pymodule("pygame_sdl2.sprite")
pymodule("pygame_sdl2.sysfont")
pymodule("pygame_sdl2.version")

cython("pygame_sdl2.error", libs=sdl_libs)
cython("pygame_sdl2.color", libs=sdl_libs)
cython("pygame_sdl2.rect", libs=sdl_libs)
cython("pygame_sdl2.rwobject", libs=sdl_libs)
cython("pygame_sdl2.surface", libs=sdl_libs)
cython("pygame_sdl2.display", libs=sdl_libs)
cython("pygame_sdl2.event", libs=sdl_libs)
cython("pygame_sdl2.locals", libs=sdl_libs)
cython("pygame_sdl2.key", libs=sdl_libs)
cython("pygame_sdl2.mouse", libs=sdl_libs)
cython("pygame_sdl2.joystick", libs=sdl_libs)
cython("pygame_sdl2.time", libs=sdl_libs)
cython("pygame_sdl2.image", libs=sdl_libs + ['SDL2_image'])
cython("pygame_sdl2.transform", libs=sdl_libs + ['SDL2_gfx'])
cython("pygame_sdl2.gfxdraw", libs=sdl_libs + ['SDL2_gfx'])
cython("pygame_sdl2.draw", libs=sdl_libs)
cython("pygame_sdl2.font", libs=sdl_libs + ['SDL2_ttf'])
cython("pygame_sdl2.mixer", libs=sdl_libs + ['SDL2_mixer'])
cython("pygame_sdl2.render", libs=sdl_libs + ['SDL2_image'])

if "PYGAME_SDL2_INSTALL_HEADERS" in os.environ:
    headers = [
        "gen/pygame_sdl2.rwobject_api.h",
        "gen/pygame_sdl2.surface_api.h",
        ]
else:
    headers = [ ]

setup("pygame_sdl2", "0.1", headers=headers)

find_unnecessary_gen()
