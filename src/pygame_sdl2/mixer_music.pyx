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

from pygame_sdl2.error import error

cdef Mix_Music *current_music = NULL
cdef object queued_music = None
cdef int endevent = 0

cdef void music_finished():
    global queued_music
    if queued_music:
        load(queued_music)
        play()
        queued_music = None

    cdef SDL_Event e
    if endevent != 0:
        memset(&e, 0, sizeof(SDL_Event))
        e.type = endevent
        SDL_PushEvent(&e)


def load(fi):
    global current_music

    # Free any previously loaded music.
    if current_music != NULL:
        Mix_FreeMusic(current_music)

    current_music = Mix_LoadMUS_RW(to_rwops(fi), 1)
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

def queue(fi):
    Mix_HookMusicFinished(music_finished)
    if get_busy():
        global queued_music
        queued_music = fi
    else:
        load(fi)
        play()

def set_endevent(type=None):
    Mix_HookMusicFinished(music_finished)
    global endevent
    endevent = type or 0

def get_endevent():
    return endevent
