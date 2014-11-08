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
from rwobject cimport to_rwops

import sys
from error import error

import pygame_sdl2.mixer_music as music

cdef object preinit_args = None
cdef object output_spec = None

def init(frequency=22050, size=MIX_DEFAULT_FORMAT, channels=2, buffer=4096):
    if get_init() is not None:
        return

    for flag in (MIX_INIT_FLAC, MIX_INIT_MOD, MIX_INIT_MODPLUG,
                 MIX_INIT_MP3, MIX_INIT_OGG, MIX_INIT_FLUIDSYNTH):
        if Mix_Init(flag) != flag:
            sys.stderr.write("{}\n".format(SDL_GetError()))

    if preinit_args:
        frequency, size, channels, buffer = preinit_args

    if Mix_OpenAudio(frequency, size, channels, buffer) != 0:
        raise error()

    global output_spec
    output_spec = get_init()

def pre_init(frequency=22050, size=MIX_DEFAULT_FORMAT, channels=2, buffersize=4096):
    global preinit_args
    preinit_args = (frequency, size, channels, buffersize)

def quit():
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
    Mix_HaltChannel(-1)

def pause():
    Mix_Pause(-1)

def unpause():
    Mix_Resume(-1)

def fadeout(time):
    Mix_FadeOutChannel(-1, time)

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
        if fade_ms != 0:
            cid = Mix_FadeInChannelTimed(-1, self.chunk, loops, fade_ms, maxtime)
        else:
            cid = Mix_PlayChannelTimed(-1, self.chunk, loops, maxtime)

        if cid == -1:
            raise error()
        return Channel(cid)

    def stop(self):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                Mix_HaltChannel(i)
            i += 1

    def pause(self):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                Mix_Pause(i)
            i += 1

    def unpause(self):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                Mix_Resume(i)
            i += 1

    def fadeout(self, time):
        cdef int i = 0
        while i < Mix_AllocateChannels(-1):
            if Mix_GetChunk(i) == self.chunk:
                Mix_FadeOutChannel(i, time)
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


class Channel(object):
    def __init__(self, cid):
        self.cid = cid

    def play(self, Sound sound not None, loops=0, maxtime=-1, fade_ms=0):
        if fade_ms != 0:
            cid = Mix_FadeInChannelTimed(self.cid, sound.chunk, loops, fade_ms, maxtime)
        else:
            cid = Mix_PlayChannelTimed(self.cid, sound.chunk, loops, maxtime)

        if cid == -1:
            raise error()

    def stop(self):
        Mix_HaltChannel(self.cid)

    def pause(self):
        Mix_Pause(self.cid)

    def unpause(self):
        Mix_Resume(self.cid)

    def fadeout(self, time):
        Mix_FadeOutChannel(self.cid, time)

    def set_volume(self, left, right=-1):
        if right == -1:
            right = left
        Mix_SetPanning(self.cid, 255*left, 255*right)

    def get_volume(self):
        cdef int vol = Mix_Volume(self.cid, -1)
        return vol / <double>MIX_MAX_VOLUME

    def queue(self, sound):
        # TODO: Use Mix_ChannelFinished callback.
        raise error("Not implemented.")

    def get_queue(self):
        raise error("Not implemented.")

    def set_endevent(self, type=None):
        # TODO: Use Mix_ChannelFinished callback.
        raise error("Not implemented.")

    def get_endevent(self):
        raise error("Not implemented.")
