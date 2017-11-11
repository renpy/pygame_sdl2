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

from __future__ import division, absolute_import, print_function

# The version of pygame_sdl2. This should also be updated in version.py
VERSION="2.1.0"

from setuplib import android, ios, windows, cython, pymodule, setup, parse_cflags, parse_libs, find_unnecessary_gen, gen
import setuplib

import os
import platform
import shutil
import sys


def setup_env(name):
    # If PYGAME_SDL2_CC or PYGAME_SDL2_LD are in the environment, and CC or LD are not, use them.

    renpy_name = "PYGAME_SDL2_" + name
    if (renpy_name in os.environ) and (name not in os.environ):
        os.environ[name] = os.environ[renpy_name]


setup_env("CC")
setup_env("LD")
setup_env("CXX")

temporary_package_data = [ ]

if android or ios:
    sdl_libs = [ 'SDL2' ]

else:

    setuplib.package_data.extend([
        "DejaVuSans.ttf",
        "DejaVuSans.txt",
        ])

    try:
        parse_cflags([ "sh", "-c", "sdl2-config --cflags" ])
        sdl_libs = parse_libs([ "sh", "-c", "sdl2-config --libs" ])
    except:

        if not windows:
            raise

        windeps = os.path.join(os.path.dirname(__file__), "pygame_sdl2_windeps")

        if not os.path.isdir(windeps):
            raise

        sdl_libs = [ 'SDL2' ]
        setuplib.include_dirs.append(os.path.join(windeps, "include"))

        if sys.version_info[0] < 3:
            setuplib.include_dirs.append(os.path.join(windeps, "include27"))

        if platform.architecture()[0] == "32bit":
            libdir = os.path.join(windeps, "lib/x86")
        else:
            libdir = os.path.join(windeps, "lib/x64")

        setuplib.library_dirs.append(libdir)

        for i in os.listdir(libdir):
            if i.lower().endswith(".dll"):
                shutil.copy(
                    os.path.join(libdir, i),
                    os.path.join(os.path.dirname(__file__), "src", "pygame_sdl2", i),
                    )

                temporary_package_data.append(i)

        setuplib.package_data.extend(temporary_package_data)

if android:
    png = "png16"
else:
    png = "png"

pymodule("pygame_sdl2.__init__")
pymodule("pygame_sdl2.compat")
pymodule("pygame_sdl2.threads.__init__")
pymodule("pygame_sdl2.threads.Py25Queue")
pymodule("pygame_sdl2.sprite")
pymodule("pygame_sdl2.sysfont")
pymodule("pygame_sdl2.time")
pymodule("pygame_sdl2.version")

cython("pygame_sdl2.error", libs=sdl_libs)
cython("pygame_sdl2.color", libs=sdl_libs)
cython("pygame_sdl2.controller", libs=sdl_libs)
cython("pygame_sdl2.rect", libs=sdl_libs)
cython("pygame_sdl2.rwobject", libs=sdl_libs)
cython("pygame_sdl2.surface", source=[ "src/alphablit.c" ], libs=sdl_libs)
cython("pygame_sdl2.display", libs=sdl_libs)
cython("pygame_sdl2.event", libs=sdl_libs)
cython("pygame_sdl2.locals", libs=sdl_libs)
cython("pygame_sdl2.key", libs=sdl_libs)
cython("pygame_sdl2.mouse", libs=sdl_libs)
cython("pygame_sdl2.joystick", libs=sdl_libs)
cython("pygame_sdl2.power", libs=sdl_libs)
cython("pygame_sdl2.pygame_time", libs=sdl_libs)
cython("pygame_sdl2.image", source=[ "src/write_jpeg.c", "src/write_png.c" ], libs=[ 'SDL2_image', "jpeg", png ] + sdl_libs)
cython("pygame_sdl2.transform", source=[ "src/SDL2_rotozoom.c" ], libs=sdl_libs)
cython("pygame_sdl2.gfxdraw", source=[ "src/SDL_gfxPrimitives.c" ], libs=sdl_libs)
cython("pygame_sdl2.draw", libs=sdl_libs)
cython("pygame_sdl2.font", libs=['SDL2_ttf'] + sdl_libs)
cython("pygame_sdl2.mixer", libs=['SDL2_mixer'] + sdl_libs)
cython("pygame_sdl2.mixer_music", libs=['SDL2_mixer'] + sdl_libs)
cython("pygame_sdl2.scrap", libs=sdl_libs)
cython("pygame_sdl2.render", libs=['SDL2_image'] + sdl_libs)

headers = [
    "src/pygame_sdl2/pygame_sdl2.h",
    gen + "/pygame_sdl2.rwobject_api.h",
    gen + "/pygame_sdl2.surface_api.h",
    gen + "/pygame_sdl2.display_api.h",
    ]

if __name__ == "__main__":
    setup(
        "pygame_sdl2",
        VERSION,
        headers=headers,
        url="https://github.com/renpy/pygame_sdl2",
        maintainer="Tom Rothamel",
        maintainer_email="tom@rothamel.us",
        )

    find_unnecessary_gen()

    for i in temporary_package_data:
        os.unlink(os.path.join(os.path.dirname(__file__), "src", "pygame_sdl2", i))
