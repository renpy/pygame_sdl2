# Copyright 2014 Patrick Dawson <pat@dw.is>
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
from display cimport Window, main_window

include "event_names.pxi"

event_queue = []

class EventType:
    def __init__(self, type, dict=None, **kwargs):
        self.type = type

        if dict:
            self.__dict__.update(dict)

        self.__dict__.update(kwargs)

    def __repr__(self):
        return '<Event(%d-%s %s)>' % (self.type, event_names[self.type], self.__dict__)

Event = EventType

cdef make_keyboard_event(SDL_KeyboardEvent *e):
    # TODO: unicode
    return EventType(e.type, scancode=e.keysym.scancode, key=e.keysym.sym, mod=e.keysym.mod)

cdef make_mousemotion_event(SDL_MouseMotionEvent *e):
    buttons = (1 if e.state & SDL_BUTTON_LMASK else 0,
               1 if e.state & SDL_BUTTON_MMASK else 0,
               1 if e.state & SDL_BUTTON_RMASK else 0)
    return EventType(e.type, pos=(e.x, e.y), rel=(e.xrel, e.yrel), buttons=buttons)

cdef make_mousebtn_event(SDL_MouseButtonEvent *e):
    # SDL 1.x maps wheel to buttons 4/5
    btn = e.button
    if btn >= 4:
        btn += 2
    return EventType(e.type, button=btn, pos=(e.x, e.y))

cdef make_mousewheel_event(SDL_MouseWheelEvent *e):
    btn = 0
    if e.y > 0:
        btn = 4
    elif e.y < 0:
        btn = 5
    else:
        return EventType(0) # x axis scrolling produces no event in pygame

    # This is not the mouse position at the time of the event
    cdef int x, y
    SDL_GetMouseState(&x, &y)

    # MOUSEBUTTONUP event should follow immediately after
    event_queue.insert(0, EventType(SDL_MOUSEBUTTONUP, button=btn, pos=(x,y)))
    return EventType(SDL_MOUSEBUTTONDOWN, button=btn, pos=(x,y))

cdef make_mousewheel_event_sdl2(SDL_MouseWheelEvent *e):
    return EventType(e.type, x=e.x, y=e.y)

cdef make_joyaxis_event(SDL_JoyAxisEvent *e):
    return EventType(e.type, joy=e.which, axis=e.axis, value=e.value)

cdef make_joyball_event(SDL_JoyBallEvent *e):
    return EventType(e.type, joy=e.which, ball=e.ball, rel=(e.xrel, e.yrel))

cdef make_joyhat_event(SDL_JoyHatEvent *e):
    return EventType(e.type, joy=e.which, hat=e.hat, value=e.value)

cdef make_joybtn_event(SDL_JoyButtonEvent *e):
    return EventType(e.type, joy=e.which, button=e.button)

cdef make_event(SDL_Event *e):
    if e.type in [SDL_KEYDOWN, SDL_KEYUP]:
        return make_keyboard_event(<SDL_KeyboardEvent*>e)
    elif e.type == SDL_MOUSEMOTION:
        return make_mousemotion_event(<SDL_MouseMotionEvent*>e)
    elif e.type in [SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP]:
        return make_mousebtn_event(<SDL_MouseButtonEvent*>e)
    elif e.type == SDL_MOUSEWHEEL:
        return make_mousewheel_event(<SDL_MouseWheelEvent*>e)
    elif e.type == SDL_JOYAXISMOTION:
        return make_joyaxis_event(<SDL_JoyAxisEvent*>e)
    elif e.type == SDL_JOYBALLMOTION:
        return make_joyball_event(<SDL_JoyBallEvent*>e)
    elif e.type == SDL_JOYHATMOTION:
        return make_joyhat_event(<SDL_JoyHatEvent*>e)
    elif e.type in [SDL_JOYBUTTONDOWN, SDL_JOYBUTTONUP]:
        return make_joybtn_event(<SDL_JoyButtonEvent*>e)

    return EventType(e.type)


def pump():
    get()

def get(t=None):
    # TODO: filtering by type
    evts = []
    while True:
        e = poll()
        if e.type == 0:
            break
        evts.append(e)
    return evts

def poll():
    cdef SDL_Event evt

    if len(event_queue) > 0:
        return event_queue.pop()

    if SDL_PollEvent(&evt) == 1:
        return make_event(&evt)
    else:
        return EventType(0)

def wait():
    cdef SDL_Event evt

    if len(event_queue) > 0:
        return event_queue.pop()

    if SDL_WaitEvent(&evt):
        return make_event(&evt)
    else:
        return EventType(0) # NOEVENT

def peek(t=None):
    if type(t) == int:
        return SDL_HasEvent(t)
    elif type(t) == list:
        for et in t:
            if SDL_HasEvent(et):
                return True
        return False
    else:
        return SDL_HasEvents(SDL_FIRSTEVENT, SDL_LASTEVENT)

def clear(t=None):
    if type(t) == int:
        SDL_FlushEvent(t)
    elif type(t) == list:
        for et in t:
            SDL_FlushEvent(t)
    else:
        SDL_FlushEvents(SDL_FIRSTEVENT, SDL_LASTEVENT)

def event_name(t):
    return event_names[t]

def set_blocked(t=None):
    # TODO: implement
    pass

def set_allowed(t=None):
    # TODO: implement
    pass

def get_blocked(t):
    # TODO: implement
    pass

def set_grab(on):
    SDL_SetWindowGrab(main_window.window, on)

def get_grab(on):
    return SDL_GetWindowGrab(main_window.window)

def post(e):
    event_queue.append(e)

def init():
    SDL_Init(SDL_INIT_EVENTS)
