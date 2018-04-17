===========
Pygame_sdl2
===========

Pygame_sdl2 is a reimplementation of the Pygame API using SDL2 and
related libraries. The initial goal of this project are to allow
games written using the pygame API to run on SDL2 on desktop and
mobile  platforms. We will then evolve the API to expose SDL2-provided
functionality in a pythonic manner.

Downloads
---------

Nightly builds are available from:

https://nightly.renpy.org/current/

An official release will be coming to pypi shortly.

License
-------

New code written for pygame_sdl2 is licensed under the Zlib license. Some
code - including compiled code - is taken wholesale from Pygame, and is
licensed under the LGPL2. Please check each module to
determine its licensing status.

See the COPYING.ZLIB and COPYING.LGPL21 files for details - you'll need
to comply with both to distribute software containing pygame_sdl2.

Current Status
--------------

Pygame_sdl2 builds and runs on Windows, Mac OS X, and Linux, with a useful
subset of the pygame API working. While not as well documented, it has also
run on Android, iOS, and inside the Chrome browser. The following modules
have at least some implementation:

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
* pygame_sdl2.mixer (including mixer.music)
* pygame_sdl2.mouse
* pygame_sdl2.scrap
* pygame_sdl2.sprite
* pygame_sdl2.surface
* pygame_sdl2.sysfont
* pygame_sdl2.time
* pygame_sdl2.transform
* pygame_sdl2.version

Experimental new modules include:

* pygame_sdl2.render
* pygame_sdl2.controller

Current omissions include:

* Modules not listed above.

* APIs that expose pygame data as buffers or arrays.

* Support for non-32-bit surface depths. Our thinking is that 8, 16,
  and (to some extent) 24-bit surfaces are legacy formats, and not worth
  duplicating code four or more times to support. This only applies to
  in-memory formats - when an image of lesser color depth is loaded, it
  is converted to a 32-bit image.

* Support for palette functions, which only apply to 8-bit surfaces.


Documentation
-------------

The latest documentation can be found at:

    http://pygame-sdl2.readthedocs.org/

An Android packaging example can be found at:

    https://github.com/renpytom/rapt-pygame-example

Building
--------

Building pygame_sdl2 requires the ability to build python modules; the
ability to link against the SDL2, SDL2_gfx, SDL2_image, SDL2_mixer,
and SDL2_ttf libraries; and the ability to compile cython code.

To build pygame_sdl2, install the build dependencies:

**Ubuntu**::

    sudo apt-get install build-essential python-dev libsdl2-dev \
        libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev \
        libjpeg-dev libpng12-dev virtualenvwrapper

**Mac OS X** (with `brew <http://brew.sh>`_)::

    brew install sdl2 sdl2_gfx sdl2_image sdl2_mixer sdl2_ttf
    sudo pip install virtualenvwrapper

Open a new shell to ensure virtualenvwrapper is running, then run::

    mkvirtualenv pygame_sdl2
    pip install cython

Change into a clone of this project, and run the following command to modify
the virtualenv so pygame_sdl2 header files can be installed in it::

    python fix_virtualenv.py

Finally, build and install pygame_sdl2 by running::

    python setup.py install


Windows
^^^^^^^

To build on windows, change into the pygame_sdl2 checkout, clone
renpy/pygame_sdl2_windeps using a command like::

    git clone https://github.com/renpy/pygame_sdl2_windeps

and then build and install using::

    python setup.py install

This assumes you have installed a version of Visual Studio that is
appropriate for the version of Python you are using.

If you also want to install the python headers in a standard fashion
to make an IDE's autocomplete work then you should try creating a
python wheel. First grab the wheel package::

    pip install wheel

Then use this command to build your wheel::

    python setup.py sdist bdist_wheel

Finally, you will need to install your wheel from the dist
sub-directory with pip. What it is called will depend on your version
of python, the current version of the library and your platform.
For example, here is a command to install a python 3.6 wheel,
on 32bit windows::

    pip install dist\pygame_sdl2-2.1.0-cp36-cp36m-win32.whl

You will also need to delete any currently installed version of
pygame_sdl2 from your Lib/site-packages directory to re-install
this way.

C Headers
^^^^^^^^^

A small number of C headers can be installed using the command::

    python setup.py install_headers

These headers export functions statically, and must be initialized by
including "pygame_sdl2/pygame_sdl2.h" and calling
the (C-language) import_pygame_sdl2() function from each C file in which a
function will be called. The following functions are exposed:

* PySurface_AsSurface - Returns the SDL_Surface underlying a pygame_sdl2.Surface.
* PySurface_New - Wraps an SDL_Surface in a new pygame_sdl2.Surface.

Pygame incompatibility
----------------------

Pygame_sdl2 is designed as a complete replacement for pygame.

If you try to use both the `pygame_sdl2` and `pygame` libraries in the same program
you may encounter errors; such as library import failures in frozen programs.


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

It includes some code from Pygame, and is inspired by the hundreds of
contributors to the Pygame, Python, and SDL2 projects.
