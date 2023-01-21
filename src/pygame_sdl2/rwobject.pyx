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
from cpython.buffer cimport PyObject_CheckBuffer, PyObject_GetBuffer, PyBuffer_Release, PyBUF_CONTIG, PyBUF_CONTIG_RO
from libc.string cimport memcpy
from libc.stdio cimport FILE, fopen, fclose, fseek, ftell, fread, SEEK_SET, SEEK_CUR, SEEK_END
from libc.stdlib cimport calloc, free
from libc.stdint cimport uintptr_t

from pygame_sdl2.compat import file_type, bytes_, unicode_

import sys
import io

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

    SDL_RWops* SDL_RWFromFile(const char *file,
                              const char *mode)

cdef extern from "python_threads.h":
    void init_python_threads()


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
    if context != NULL:
        if context.hidden.unknown.data1 != NULL:
            f = <object> context.hidden.unknown.data1

            try:
                f.close()
            except Exception as e:
                set_error(e)
                return -1

            Py_DECREF(f)

            context.hidden.unknown.data1 = NULL
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
    cdef size_t rv

    if size * maxnum > left:
        maxnum = left // size

    if maxnum == 0:
        return 0

    rv = SDL_RWread(sf.rw, ptr, size, maxnum)

    if rv > 0:
        sf.tell += size * rv

    return rv

cdef int subfile_close(SDL_RWops *context) nogil:
    cdef SubFile *sf

    if context != NULL:
        sf = <SubFile *> context.hidden.unknown.data1
        if sf.rw != NULL:
            SDL_RWclose(sf.rw)
        if sf != NULL:
            free(sf)
            context.hidden.unknown.data1 = NULL
        SDL_FreeRW(context)

    return 0

cdef struct BufFile:
    Py_buffer view
    Uint8 *base
    Uint8 *here
    Uint8 *stop

cdef Sint64 buffile_size(SDL_RWops *context) nogil:
    cdef BufFile *bf = <BufFile *> context.hidden.unknown.data1

    return bf.stop - bf.base

cdef Sint64 buffile_seek(SDL_RWops *context, Sint64 offset, int whence) nogil:
    cdef BufFile *bf = <BufFile *> context.hidden.unknown.data1

    cdef Uint8 *newpos

    if whence == RW_SEEK_SET:
        newpos = bf.base + offset
    elif whence == RW_SEEK_CUR:
        newpos = bf.here + offset
    elif whence == RW_SEEK_END:
        newpos = bf.stop + offset
    else:
        with gil:
            set_error("Unknown value for 'whence'")
        return -1
    if newpos < bf.base:
        newpos = bf.base
    if newpos > bf.stop:
        newpos = bf.stop
    bf.here = newpos

    return bf.here - bf.base

cdef size_t buffile_read(SDL_RWops *context, void *ptr, size_t size, size_t maxnum) nogil:
    cdef BufFile *bf = <BufFile *> context.hidden.unknown.data1
    cdef size_t total_bytes = 0
    cdef size_t mem_available = 0

    total_bytes = maxnum * size
    if (maxnum == 0) or (size == 0) or ((total_bytes // maxnum) != size):
        return 0

    mem_available = bf.stop - bf.here
    if total_bytes > mem_available:
        total_bytes = mem_available

    SDL_memcpy(ptr, bf.here, total_bytes)
    bf.here += total_bytes

    return (total_bytes // size)

cdef size_t buffile_write(SDL_RWops *context, const void *ptr, size_t size, size_t num) nogil:
    cdef BufFile *bf = <BufFile *> context.hidden.unknown.data1

    if bf.view.readonly != 0:
        return 0

    if (bf.here + (num * size)) > bf.stop:
        num = (bf.stop - bf.here) // size
    SDL_memcpy(bf.here, ptr, num * size)
    bf.here += num * size

    return num

cdef int buffile_close(SDL_RWops *context) with gil:
    cdef BufFile *bf

    if context != NULL:
        bf = <BufFile *> context.hidden.unknown.data1
        if bf != NULL:
            PyBuffer_Release(&bf.view)
            free(bf)
            bf = NULL
        SDL_FreeRW(context)

    return 0

cdef SDL_RWops *to_rwops(filelike, mode="rb") except NULL:

    cdef FILE *f
    cdef SubFile *sf
    cdef SDL_RWops *rv
    cdef SDL_RWops *rw
    cdef char *cname
    cdef char *cmode

    if not isinstance(mode, bytes_):
        mode = mode.encode("ascii")

    name = filelike

    if isinstance(filelike, RWops):
        rv = (<RWopsImpl>filelike._holder).get_rwops()
        if rv == NULL:
            raise ValueError("Passed in RWops object is closed")
        (<RWopsImpl>filelike._holder).clear_rwops()
        return rv

    if isinstance(filelike, (file_type, io.IOBase)) and mode == "rb":
        name = getattr(filelike, "name", None)

    # Try to open as a file.
    if isinstance(name, bytes_):
        name = name.decode(fsencoding)
    elif isinstance(name, unicode_):
        pass
    else:
        name = None

    if (mode == b"rb") and (name is not None):

        dname = name.encode("utf-8")
        cname = dname
        cmode = mode

        with nogil:
            rv = SDL_RWFromFile(cname, cmode)

        if rv == NULL:
            raise IOError("Could not open {!r}: {}".format(name, SDL_GetError()))

        try:

            # If we have these properties, we're either an APK asset or a Ren'Py-style
            # subfile, so use an optimized path.
            base = filelike.base
            length = filelike.length

            rw = rv

            SDL_RWseek(rw, base, RW_SEEK_SET);

            sf = <SubFile *> calloc(sizeof(SubFile), 1)
            sf.rw = rw
            sf.base = base
            sf.length = length
            sf.tell = 0;

            SDL_RWseek(rw, base, RW_SEEK_SET)

            sf = <SubFile *> calloc(sizeof(SubFile), 1)
            sf.rw = rw
            sf.base = base
            sf.length = length
            sf.tell = 0

            rv = SDL_AllocRW()
            rv.size = subfile_size
            rv.seek = subfile_seek
            rv.read = subfile_read
            rv.write = NULL
            rv.close = subfile_close
            rv.type = 0
            rv.hidden.unknown.data1 = <void *> sf

            try:
                filelike.close()
            except:
                pass

            return rv

        except AttributeError:
            pass

        try:
            filelike.close()
        except:
            pass

        return rv

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

cdef class RWopsImpl(object):
    cdef SDL_RWops *ops
    cdef int closed

    def check_closed(self):
        """
        Internal: raise a ValueError if this RWops object is closed
        """
        if self.closed != 0:
            raise ValueError("I/O operation on closed RWops.")

    def get_closed(self):
        return self.closed != 0

    cdef SDL_RWops *get_rwops(self):
        return self.ops

    cdef set_rwops(self, SDL_RWops * ops):
        """
        Internal: Set the rwops object.
        """
        self.ops = ops
        self.closed = 0

    cdef clear_rwops(self):
        """
        Internal: Clear the rwops object.
        """
        self.ops = NULL
        self.closed = 1

    def close(self):
        # Allow close to be called multiple times without raising an exception.
        if self.closed != 0:
            return
        self.closed = 1
        ops = self.ops
        self.ops = NULL
        SDL_RWclose(ops)

    def seek(self, offset, whence):
        whence_rw = RW_SEEK_SET
        whence_mapping = {
            io.SEEK_SET : RW_SEEK_SET,
            io.SEEK_CUR : RW_SEEK_CUR,
            io.SEEK_END : RW_SEEK_END,
        }
        if whence in whence_mapping:
            whence_rw = whence_mapping[whence]
        rv = SDL_RWseek(self.ops, offset, whence_rw)
        if rv < 0:
            raise IOError("Could not seek: {}".format(SDL_GetError()))
        return rv

    def readinto(self, b):
        cdef Py_buffer view
        rv = 0
        
        if not PyObject_CheckBuffer(b):
            raise ValueError("Passed in object does not support buffer protocol")
        try:
            PyObject_GetBuffer(b, &view, PyBUF_CONTIG)
            rv = SDL_RWread(self.ops, view.buf, 1, view.len)
        finally:
            PyBuffer_Release(&view)
        if rv < 0:
            raise IOError("Could not read: {}".format(SDL_GetError()))
        return rv

    def write(self, b):
        cdef Py_buffer view
        rv = 0

        if not PyObject_CheckBuffer(b):
            raise ValueError("Passed in object does not support buffer protocol")
        try:
            PyObject_GetBuffer(b, &view, PyBUF_CONTIG_RO)
            rv = SDL_RWwrite(self.ops, view.buf, 1, view.len)
        finally:
            PyBuffer_Release(&view)
        if rv < 0:
            raise IOError("Could not write: {}".format(SDL_GetError()))
        return rv

    def get_sdl_rwops_pointer(self):
        import ctypes
        return ctypes.c_void_p(<uintptr_t> self.ops)

class RWops(io.RawIOBase):
    def __init__(self, name=None):
        io.RawIOBase.__init__(self)
        self._holder = RWopsImpl()
        self.name = name

    # Implemented class: io.IOBase

    def close(self):
        self._holder.close()

    @property
    def closed(self):
        return self._holder.get_closed()

    def fileno(self):
        raise OSError()

    # inherited flush is used

    # inherited isatty is used

    def readable(self):
        return True

    # inherited readline is used

    # inherited readlines is used

    def seek(self, offset, whence=0):
        self._holder.check_closed()
        return self._holder.seek(offset, whence)


    def seekable(self):
        return True

    # inherited tell is used

    def truncate(self, size=None):
        raise OSError()

    def writable(self):
        return True

    # inherited writelines is used

    # inherited __del__ is used

    # Implemented class: io.RawIOBase

    # inherited read is used

    # inherited readall is used

    def readinto(self, b):
        self._holder.check_closed()
        return self._holder.readinto(b)

    def write(self, b):
        self._holder.check_closed()
        return self._holder.write(b)

    def get_sdl_rwops_pointer(self):
        return self._holder.get_sdl_rwops_pointer()

def RWops_from_file(name, mode="rb"):
    cdef SDL_RWops *rw
    cdef char *cname
    cdef char *cmode

    if not isinstance(mode, bytes_):
        mode = mode.encode("ascii")

    # Try to open as a file.
    if isinstance(name, bytes_):
        name = name.decode(fsencoding)
    elif isinstance(name, unicode_):
        pass
    else:
        name = None

    if name is not None:

        dname = name.encode("utf-8")
        cname = dname
        cmode = mode

        with nogil:
            rw = SDL_RWFromFile(cname, cmode)

        if rw == NULL:
            raise IOError("Could not open {!r}: {}".format(name, SDL_GetError()))

        rv = RWops(name)
        (<RWopsImpl>rv._holder).set_rwops(rw)

        return rv

    return ValueError("Invalid value passed in for name")

def RWops_from_file_like_object(filelike):
    cdef SDL_RWops *rw

    rw = to_rwops(filelike)

    rv = RWops()
    (<RWopsImpl>rv._holder).set_rwops(rw)

    return rv

def RWops_is_file_like_object(rw_in_object):
    cdef Py_buffer view
    cdef SDL_RWops *rw_in
    cdef SDL_RWops *rw

    if not isinstance(rw_in_object, RWops):
        return False
    rw_in = (<RWopsImpl>rw_in_object._holder).get_rwops()
    if rw_in == NULL:
        return False
    return rw_in.read == python_read

def RWops_from_buffer(b, mode="rb"):
    cdef Py_buffer view
    cdef SDL_RWops *rw

    if not PyObject_CheckBuffer(b):
        raise ValueError("Passed in object does not support buffer protocol")
    PyObject_GetBuffer(b, &view, PyBUF_CONTIG_RO if ("r" in mode) else PyBUF_CONTIG)

    bf = <BufFile *> calloc(sizeof(BufFile), 1)
    bf.view = view
    bf.base = <Uint8 *>view.buf
    bf.here = bf.base
    bf.stop = bf.base + view.len

    rw = SDL_AllocRW()
    rw.size = buffile_size
    rw.seek = buffile_seek
    rw.read = buffile_read
    rw.write = buffile_write
    rw.close = buffile_close
    rw.type = 0
    rw.hidden.unknown.data1 = <void *> bf

    rv = RWops()
    (<RWopsImpl>rv._holder).set_rwops(rw)

    return rv

def RWops_is_buffer(rw_in_object):
    cdef Py_buffer view
    cdef SDL_RWops *rw_in
    cdef SDL_RWops *rw

    if not isinstance(rw_in_object, RWops):
        return False
    rw_in = (<RWopsImpl>rw_in_object._holder).get_rwops()
    if rw_in == NULL:
        return False
    return rw_in.read == buffile_read

def RWops_create_subfile(rw_in_object, base, length):
    cdef Py_buffer view
    cdef SDL_RWops *rw_in
    cdef SDL_RWops *rw

    if not isinstance(rw_in_object, RWops):
        raise ValueError("Passed in object should be RWops")
    rw_in = (<RWopsImpl>rw_in_object._holder).get_rwops()
    if rw_in == NULL:
        raise ValueError("Passed in RWops object is closed")
    (<RWopsImpl>rw_in_object._holder).clear_rwops()

    SDL_RWseek(rw_in, base, RW_SEEK_SET)

    sf = <SubFile *> calloc(sizeof(SubFile), 1)
    sf.rw = rw_in
    sf.base = base
    sf.length = length
    sf.tell = 0

    rw = SDL_AllocRW()
    rw.size = subfile_size
    rw.seek = subfile_seek
    rw.read = subfile_read
    rw.write = NULL
    rw.close = subfile_close
    rw.type = 0
    rw.hidden.unknown.data1 = <void *> sf

    rv = RWops()
    (<RWopsImpl>rv._holder).set_rwops(rw)

    return rv

def RWops_is_subfile(rw_in_object):
    cdef Py_buffer view
    cdef SDL_RWops *rw_in
    cdef SDL_RWops *rw

    if not isinstance(rw_in_object, RWops):
        return False
    rw_in = (<RWopsImpl>rw_in_object._holder).get_rwops()
    if rw_in == NULL:
        return False
    return rw_in.read == subfile_read

def RWops_unwrap_subfile(rw_in_object):
    cdef Py_buffer view
    cdef SDL_RWops *rw_in
    cdef SDL_RWops *rw
    cdef SubFile *sf

    if not isinstance(rw_in_object, RWops):
        raise ValueError("Passed in object should be RWops")
    rw_in = (<RWopsImpl>rw_in_object._holder).get_rwops()
    if rw_in == NULL:
        raise ValueError("Passed in RWops object is closed")
    if rw_in.read != subfile_read:
        raise ValueError("Passed in RWops object is not SubFile")
    (<RWopsImpl>rw_in_object._holder).clear_rwops()
    sf = <SubFile *>rw_in_object.hidden.unknown.data1
    rw = sf.rw
    sf.rw = NULL
    SDL_RWclose(rw_in)

    SDL_RWseek(rw, 0, RW_SEEK_SET)

    rv = RWops()
    (<RWopsImpl>rv._holder).set_rwops(rw)

    return rv

init_python_threads()
