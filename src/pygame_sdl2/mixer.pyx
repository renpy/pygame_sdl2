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
from sdl2_mixer cimport *
from pygame_sdl2.rwobject cimport to_rwops
from libc.string cimport memset

import sys
import threading
from pygame_sdl2.error import error

import pygame_sdl2.mixer_music as music
import pygame_sdl2

cdef object preinit_args = None
cdef object output_spec = None

cdef dict channel_events = {}
cdef dict channel_queued = {}
cdef dict current_sounds = {}

# The lock protects channel_queued and current_sounds.
_lock = threading.Lock()

def _play_current(int channel):
    """
    Caled by channel_callback to play the next sound. This has to be called
    from a different thread, as the channel callback isn't allowed to call
    MIX functions.
    """

    cdef Sound next_sound

    with _lock:
        next_sound = channel_queued[channel]
        current_sounds[channel] = next_sound
        channel_queued[channel] = None

    if next_sound:
        with nogil:
            Mix_PlayChannelTimed(channel, next_sound.chunk, 0, -1)


cdef void channel_callback(int channel) with gil:

    cdef int etype = 0
    cdef SDL_Event e

    etype = channel_events.get(channel, 0)
    if etype != 0:
        memset(&e, 0, sizeof(SDL_Event))
        e.type = etype
        SDL_PushEvent(&e)

    with _lock:
        next_sound = channel_queued.get(channel)
        if next_sound:
            threading.Thread(target=_play_current, args=(channel,)).start()

# A list of errors that occured during mixer initialization.
errors = [ ]

@pygame_sdl2.register_init
def init(frequency=22050, size=MIX_DEFAULT_FORMAT, channels=2, buffer=4096):
    if get_init() is not None:
        return

    for flag in (MIX_INIT_FLAC, MIX_INIT_MP3, MIX_INIT_OGG):

        if Mix_Init(flag) != flag:
            errors.append("{}\n".format(SDL_GetError()))

    if preinit_args:
        frequency, size, channels, buffer = preinit_args

    if Mix_OpenAudio(frequency, size, channels, buffer) != 0:
        raise error()

    global output_spec
    output_spec = get_init()

    Mix_ChannelFinished(channel_callback)

def pre_init(frequency=22050, size=MIX_DEFAULT_FORMAT, channels=2, buffersize=4096):
    global preinit_args
    preinit_args = (frequency, size, channels, buffersize)

@pygame_sdl2.register_quit
def quit(): # @ReservedAssignment
    Mix_CloseAudio()
    Mix_Quit()

def get_init():
    cdef int frequency
    cdef Uint16 format
    cdef int channels

    if Mix_QuerySpec(&frequency, &format, &channels) == 0:
        return None
    else:
        return frequency, format, channels

def stop():
    with nogil:
        Mix_HaltChannel(-1)

def pause():
    with nogil:
        Mix_Pause(-1)

def unpause():
    with nogil:
        Mix_Resume(-1)

def fadeout(time):
    cdef int ms = time
    with nogil:
        Mix_FadeOutChannel(-1, ms)

def set_num_channels(count):
    Mix_AllocateChannels(count)

def get_num_channels():
    return Mix_AllocateChannels(-1)

def set_reserved(count):
    Mix_ReserveChannels(count)

def find_channel(force=False):
    cdef int chan
    chan = Mix_GroupAvailable(-1)
    if chan == -1:
        if not force:
            return None
        chan = Mix_GroupOldest(-1)
        if chan == -1:
            raise error()
    return Channel(chan)

def get_busy():
    return Mix_GroupNewer(-1) != -1


cdef class Sound:
    cdef Mix_Chunk *chunk

    def __cinit__(self):
        self.chunk = NULL

    def __dealloc__(self):
        if self.chunk:
            Mix_FreeChunk(self.chunk)

    def __init__(self, fi):
        self.chunk = Mix_LoadWAV_RW(to_rwops(fi), 1)
        if self.chunk == NULL:
            raise error()

    def play(self, loops=0, maxtime=-1, fade_ms=0):
        cdef int cid
        cdef int _loops = loops
        cdef int _maxtime = maxtime
        cdef int _fade_ms = fade_ms

        with nogil:
            if _fade_ms != 0:
                cid = Mix_FadeInChannelTimed(-1, self.chunk, _loops, _fade_ms, _maxtime)
            else:
                cid = Mix_PlayChannelTimed(-1, self.chunk, _loops, _maxtime)

        if cid == -1:
            raise error()
        return Channel(cid)

    def stop(self):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                with nogil:
                    Mix_HaltChannel(i)
            i += 1

    def pause(self):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                with nogil:
                    Mix_Pause(i)
            i += 1

    def unpause(self):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                with nogil:
                    Mix_Resume(i)
            i += 1

    def fadeout(self, time):
        cdef int i = 0
        cdef int ms = time
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                with nogil:
                    Mix_FadeOutChannel(i, ms)
            i += 1

    def set_volume(self, value):
        Mix_VolumeChunk(self.chunk, MIX_MAX_VOLUME * value)

    def get_volume(self):
        return Mix_VolumeChunk(self.chunk, -1)

    def get_num_channels(self):
        cdef int i = 0
        cdef int n = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                n += 1
            i += 1
        return n

    def get_length(self):
        # TODO: Adjust for actual format, rather than assuming 16-bit.
        return <double>self.chunk.alen / output_spec[0] / 2 / output_spec[2]

    def get_raw(self):
        # return self.chunk.abuf
        raise error("Not implemented.")


cdef class Channel(object):
    cdef int cid

    def __init__(self, cid):
        self.cid = cid

    def play(self, Sound sound not None, loops=0, maxtime=-1, fade_ms=0):
        cdef int _loops = loops
        cdef int _maxtime = maxtime
        cdef int _fade_ms = fade_ms

        with nogil:
            if _fade_ms != 0:
                cid = Mix_FadeInChannelTimed(self.cid, sound.chunk, _loops, _fade_ms, _maxtime)
            else:
                cid = Mix_PlayChannelTimed(self.cid, sound.chunk, _loops, _maxtime)

        if cid == -1:
            raise error()

        with _lock:
            current_sounds[self.cid] = sound

    def stop(self):
        with nogil:
            Mix_HaltChannel(self.cid)

    def pause(self):
        with nogil:
            Mix_Pause(self.cid)

    def unpause(self):
        with nogil:
            Mix_Resume(self.cid)

    def fadeout(self, time):
        cdef int ms = time
        with nogil:
            Mix_FadeOutChannel(self.cid, ms)

    def set_volume(self, volume):
        Mix_Volume(self.cid, int(MIX_MAX_VOLUME * volume))

    def get_volume(self):
        cdef int vol = Mix_Volume(self.cid, -1)
        return vol / <double>MIX_MAX_VOLUME

    def get_busy(self):
        return Mix_Playing(self.cid) != 0

    def get_sound(self):
        with _lock:
            return current_sounds.get(self.cid)

    def queue(self, Sound sound):
        if self.get_busy():
            with _lock:
                channel_queued[self.cid] = sound
        else:
            self.play(sound)

    def get_queue(self):
        with _lock:
            return channel_queued.get(self.cid)

    def set_endevent(self, type=None):
        channel_events[self.cid] = type or 0

    def get_endevent(self):
        return channel_events.get(self.cid, 0)
