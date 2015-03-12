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

import sys

# The fsencoding.
fsencoding = sys.getfilesystemencoding() or "utf-8"


cdef set_error(e):
    cdef char *msg
    e = str(e)
    msg = <char *> e
    SDL_SetError(e)

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
    FILE *f
    Sint64 base
    Sint64 length

cdef Sint64 subfile_size(SDL_RWops *context) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1
    return sf.length

cdef Sint64 subfile_seek(SDL_RWops *context, Sint64 seek, int whence) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1

    if whence == RW_SEEK_SET:
        fseek(sf.f, seek + sf.base, SEEK_SET)
    elif whence == RW_SEEK_CUR:
        fseek(sf.f, seek, SEEK_CUR)
    elif whence == RW_SEEK_END:
        fseek(sf.f, sf.base + sf.base + sf.length, SEEK_END)

    return ftell(sf.f)

cdef size_t subfile_read(SDL_RWops *context, void *ptr, size_t size, size_t maxnum) nogil:
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1

    cdef Sint64 tell = ftell(sf.f) - sf.base
    cdef Sint64 left = sf.length - tell

    if size * maxnum > left:
        maxnum = left / size

    if maxnum == 0:
        return 0

    return fread(ptr, size, maxnum, sf.f)

cdef int subfile_close(SDL_RWops *context):
    cdef SubFile *sf = <SubFile *> context.hidden.unknown.data1

    fclose(sf.f)
    free(sf)
    SDL_FreeRW(context)


cdef SDL_RWops *to_rwops(filelike, mode="rb") except NULL:

    cdef SDL_RWops *rv

    if isinstance(filelike, file) and mode == "rb":
        filelike = filelike.name

    # Try to open as a file.
    if isinstance(filelike, str):
        name = filelike
    elif isinstance(filelike, unicode):
        name = filelike.encode(fsencoding)
    else:
        name = None

    if name:
        rv = SDL_RWFromFile(name, mode)

        if rv == NULL:
            raise IOError("Could not open {!r}: {}".format(filelike, SDL_GetError()))

        return rv

    cdef FILE *f
    cdef SubFile *sf

    if mode == "rb":
        try:

            # If we have these properties, we're either an APK asset or a Ren'Py-style
            # subfile, so use an optimized path.
            name = filelike.name
            base = filelike.base
            length = filelike.length

            if name is not None:

                f = fopen(name, "rb")
                if not f:
                    raise IOError("Could not open {}.".format(name))

                fseek(f, base, SEEK_SET)

                sf = <SubFile *> calloc(sizeof(SubFile), 1)
                sf.f = f
                sf.base = base
                sf.length = length

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

cdef api SDL_RWops *RWopsFromPython(filelike):
    return to_rwops(filelike)
