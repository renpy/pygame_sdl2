===========
Pygame_sdl2
===========

Pygame_sdl2 is a reimplementation of the Pygame API using SDL2 and
related libraries. The initial goal of this project are to allow
games written using the pygame API to run on SDL2 on desktop and
mobile  platforms. We will then evolve the API to expose SDL2-provided
functionality in a pythonic manner.

License
-------

New code written for pygame_sdl2, including all compiled code, is licensed
under the Zlib license. A number of pure-python modules are taken wholesale
from Pygame, and are licensed under the LGPL2. Please check each module to
determine its licensing status.

See the COPYING.ZLIB and COPYING.LGPL21 files for details - you'll need
to comply with both to distribute software containing pygame_sdl2.

Current Status
--------------

Pygame_sdl2 builds and runs on Windows, Mac OS X, and Linux, with a useful
subset of the pygame API working. The following modules have at least
some implementation:

* pygame_sdl2.color
* pygame_sdl2.display
* pygame_sdl2.draw
* pygame_sdl2.event
* pygame_sdl2.font
* pygame_sdl2.gfxdraw
* pygame_sdl2.image
* pygame_sdl2.joystick
* pygame_sdl2.key
* pygame_sdl2.locals
* pygame_sdl2.mixer (inc. mixer.music)
* pygame_sdl2.mouse
* pygame_sdl2.sprite
* pygame_sdl2.sysfont
* pygame_sdl2.time
* pygame_sdl2.transform
* pygame_sdl2.version

Current omissions include:

* Modules not listed above.

* Blend modes other than the default (OVER) mode are not implemented.

* APIs that expose pygame data as buffers or arrays.

* Support for non-32-bit surface depths. Our thinking is that 8, 16,
  and (to some extent) 24-bit surfaces are legacy formats, and not worth
  duplicating code four or more times to support. This only applies to
  in-memory formats - when an image of lesser color depth is loaded, it
  is converted to a 32-bit image.

* Support for palette functions, which only apply to 8-bit surfaces.

Documentation
-------------

There isn't much pygame_sdl2 documentation at the moment, especially for
end-users. Check out the pygame documentation at:

    http://www.pygame.org/docs/

There is one new api we should mention. Running the code::

    import pygame_sdl
    pygame_sdl2.import_as_pygame()

Will modify sys.modules so that pygame_sdl2 modules are used instead of
their pygame equivalents. For example, after running the code above,
the code::

    import pygame.image
    img = pygame.image.load("logo.png")

will use pygame_sdl2 to load the image, instead of pygame. (This is intended
to allow code to run on pygame_sdl2 or pygame.)

Building
--------

Building pygame_sdl2 requires the ability to build python modules; the
ability to link against the SDL2, SDL2_gfx, SDL2_image, SDL2_mixer,
and SDL2_ttf libraries; and the ability to compile cython code.

To build pygame_sdl2 on Ubuntu, install the build dependencies using the
command::

    sudo apt-get install build-essentials python-dev libsdl2-dev libsdl2-image-dev \
        libsdl2-gfx-dev libsdl2-mixer-dev libsdl2-ttf-dev virtualenvwrapper

Open a new shell to ensure virtualenvwrapper is running, then run::

    mkvirtualenv pygame_sdl2
    pip install cython

Finally, build and install pygame_sdl2 by entering a checkout of this project
and running::

    python setup.py install

Contributing
------------

We're looking for people to contribute to pygame_sdl2 development. For
simple changes, just give us a pull request. Before making a change that
is a lot of work, it might make sense to send us an email to ensure we're
not already working on it.

Credits
-------

Pygame_sdl2 is written by:

* Patrick Dawson <pat@dw.is>
* Tom Rothamel <tom@rothamel.us>

It includes some code from Pygame, and is inspired by the dozens of contributors
to the Pygame, Python, and SDL2 projects.
