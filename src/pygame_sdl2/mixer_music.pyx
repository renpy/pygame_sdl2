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

from error import error

cdef Mix_Music *current_music = NULL
cdef str queued_music = None

def load(fn):
    if not isinstance(fn, str):
        raise ValueError("load can only accept a filename.")

    global current_music

    # Free any previously loaded music.
    if current_music != NULL:
        Mix_FreeMusic(current_music)

    current_music = Mix_LoadMUS(fn)
    if current_music == NULL:
        raise error()

def play(loops=0, double start=0.0):
    Mix_FadeInMusicPos(current_music, loops, 0, start)

def rewind():
    Mix_RewindMusic()

def stop():
    Mix_HaltMusic()

def pause():
    Mix_PauseMusic()

def unpause():
    Mix_ResumeMusic()

def fadeout(time):
    Mix_FadeOutMusic(time)

def set_volume(double value):
    Mix_VolumeMusic(<int>(MIX_MAX_VOLUME * value))

def get_volume():
    return Mix_VolumeMusic(-1) / <double>MIX_MAX_VOLUME

def get_busy():
    return Mix_PlayingMusic()

def set_pos(double pos):
    Mix_SetMusicPosition(pos)

def get_pos():
    # TODO: Use a Mix_SetPostMix callback to track position.
    raise error("Not implemented.")

def queue(str fn):
    global queued_music
    queued_music = fn

def set_endevent(type=None):
    raise error("Not implemented.")

def get_endevent():
    raise error("Not implemented.")
