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
from cpython.ref cimport Py_INCREF, Py_DECREF
from libc.string cimport memcpy
from libc.stdio cimport FILE, fopen, fclose, fseek, ftell, fread, SEEK_SET, SEEK_CUR, SEEK_END
from libc.stdlib cimport calloc, free

from pygame_sdl2.compat import file_type, bytes_, unicode_

import sys

# The fsencoding.
fsencoding = sys.getfilesystemencoding() or "utf-8"

cdef extern from "SDL.h" nogil:
    Sint64 SDL_RWtell(SDL_RWops* context)

    Sint64 SDL_RWseek(SDL_RWops* context,
                      Sint64     offset,
                      int        whence)

    size_t SDL_RWread(SDL_RWops* context,
                  void*             ptr,
                  size_t            size,
                  size_t            maxnum)

    size_t SDL_RWwrite(SDL_RWops* context,
                       const void*       ptr,
                       size_t            size,
                       size_t            num)

    int SDL_RWclose(SDL_RWops* context)


cdef extern from "Python.h":
    void PyEval_InitThreads()


cdef set_error(e):
    cdef char *msg
    e = str(e)
    msg = <char *> e
    SDL_SetError("%s", msg)

cdef Sint64 python_size(SDL_RWops *context) with gil:
    f = <object> context.hidden.unknown.data1

    try:
        cur = f.tell()
        f.seek(0, 2)
        rv = f.tell()
        f.seek(cur, 0)
    except:
        return -1

    return rv

cdef Sint64 python_seek(SDL_RWops *context, Sint64 seek, int whence) with gil:
    f = <object> context.hidden.unknown.data1

    try:
        f.seek(seek, whence)
        rv = f.tell()
    except Exception as e:
        set_error(e)
        return -1

    return rv

cdef size_t python_read(SDL_RWops *context, void *ptr, size_t size, size_t maxnum) with gil:
    f = <object> context.hidden.unknown.data1

    try:
        data = f.read(size * maxnum)
    except Exception as e:
        set_error(e)
        return -1

    memcpy(ptr, <void *><char *> data, len(data))
    return len(data)

cdef size_t python_write(SDL_RWops *context, const void *ptr, size_t size, size_t maxnum) with gil:
    f = <object> context.hidden.unknown.data1
    data = (<char *> ptr)[:size * maxnum]

    try:
        f.write(data)
    except Exception as e:
        set_error(e)
        return -1

    return len(data)

cdef int python_close(SDL_RWops *context) with gil:
    f = <object> context.hidden.unknown.data1

    try:
        f.close()
    except Exception as e:
        set_error(e)
        return -1

    Py_DECREF(f)
    SDL_FreeRW(context)
    return 0

cdef struct SubFile:
    SDL_RWops *rw
    Sint64 base
    Sint64 length
    Sint64 tell

cdef Sint64 subfile_size(SDL_RWops *context) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1
    return sf.length

cdef Sint64 subfile_seek(SDL_RWops *context, Sint64 seek, int whence) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1

    if whence == RW_SEEK_SET:
        sf.tell = SDL_RWseek(sf.rw, seek + sf.base, RW_SEEK_SET) - sf.base
    elif whence == RW_SEEK_CUR:
        sf.tell = SDL_RWseek(sf.rw, seek, RW_SEEK_CUR) - sf.base
    elif whence == RW_SEEK_END:
        sf.tell = SDL_RWseek(sf.rw, sf.base + sf.length + seek, RW_SEEK_SET) - sf.base

    return sf.tell

cdef size_t subfile_read(SDL_RWops *context, void *ptr, size_t size, size_t maxnum) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1

    cdef Sint64 left = sf.length - sf.tell
    cdef size_t rv;

    if size * maxnum > left:
        maxnum = left // size

    if maxnum == 0:
        return 0

    rv = SDL_RWread(sf.rw, ptr, size, maxnum)

    if rv > 0:
        sf.tell += size * rv

    return rv

cdef int subfile_close(SDL_RWops *context) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1

    SDL_RWclose(sf.rw)
    free(sf)
    SDL_FreeRW(context)


cdef SDL_RWops *to_rwops(filelike, mode="rb") except NULL:

    cdef FILE *f
    cdef SubFile *sf
    cdef SDL_RWops *rv
    cdef SDL_RWops *rw
    cdef char *cname
    cdef char *cmode

    if not isinstance(mode, bytes_):
        mode = mode.encode("ascii")

    if isinstance(filelike, file_type) and mode == b"rb":
        filelike = filelike.name

    # Try to open as a file.
    if isinstance(filelike, bytes_):
        name = filelike.decode(fsencoding)
    elif isinstance(filelike, unicode_):
        name = filelike
    else:
        name = None

    if name:

        dname = name.encode("utf-8")
        cname = dname
        cmode = mode

        with nogil:
            rv = SDL_RWFromFile(cname, cmode)

        if rv == NULL:
            raise IOError("Could not open {!r}: {}".format(filelike, SDL_GetError()))

        return rv

    if mode == b"rb":
        try:

            # If we have these properties, we're either an APK asset or a Ren'Py-style
            # subfile, so use an optimized path.
            name = filelike.name
            base = filelike.base
            length = filelike.length

            if name is not None:

                if not isinstance(name, unicode_):
                    name = name.decode(fsencoding)

                dname = name.encode("utf-8")
                cname = dname

                with nogil:
                    rw = SDL_RWFromFile(cname, b"rb")

                if not rw:
                    raise IOError("Could not open {!r}.".format(name))

                SDL_RWseek(rw, base, RW_SEEK_SET);

                sf = <SubFile *> calloc(sizeof(SubFile), 1)
                sf.rw = rw
                sf.base = base
                sf.length = length
                sf.tell = 0;

                rv = SDL_AllocRW()
                rv.size = subfile_size
                rv.seek = subfile_seek
                rv.read = subfile_read
                rv.write = NULL
                rv.close = subfile_close
                rv.type = 0
                rv.hidden.unknown.data1 = <void *> sf

                return rv

        except AttributeError:
            pass


    if not (hasattr(filelike, "read") or hasattr(filelike, "write")):
        raise IOError("{!r} is not a filename or file-like object.".format(filelike))

    Py_INCREF(filelike)

    rv = SDL_AllocRW()
    rv.size = python_size
    rv.seek = python_seek
    rv.read = python_read
    rv.write = python_write
    rv.close = python_close
    rv.type = 0
    rv.hidden.unknown.data1 = <void *> filelike

    return rv


cdef api SDL_RWops *RWopsFromPython(filelike) except NULL:
    return to_rwops(filelike)

PyEval_InitThreads()
