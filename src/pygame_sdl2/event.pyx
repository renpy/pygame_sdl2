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

class EventQueue(list):
    def has(self, t):
        for e in self:
            if e.type == t:
                return True
        return False

    def flush(self, t):
        to_remove = []
        for e in self:
            if e.type == t:
                to_remove.append(e)
        for e in to_remove:
            self.remove(e)

event_queue = EventQueue()

# Add events to emulate SDL 1.2
ACTIVEEVENT = SDL_LASTEVENT - 1
VIDEORESIZE = SDL_LASTEVENT - 2
VIDEOEXPOSE = SDL_LASTEVENT - 3

event_names[ACTIVEEVENT] = "ACTIVEEVENT"
event_names[VIDEORESIZE] = "VIDEORESIZE"
event_names[VIDEOEXPOSE] = "VIDEOEXPOSE"

class EventType(object):
    def __init__(self, type, dict=None, **kwargs):
        self._type = type

        if dict:
            self.__dict__.update(dict)

        self.__dict__.update(kwargs)

    def __repr__(self):
        if SDL_USEREVENT < self.type < VIDEOEXPOSE:
            ename = "UserEvent%d" % (self.type - SDL_USEREVENT)
        else:
            try:
                ename = event_names[self.type]
            except KeyError:
                ename = "UNKNOWN"
        return '<Event(%d-%s %s)>' % (self.type, ename, self.__dict__)

    @property
    def dict(self):
        return self.__dict__

    @property
    def type(self):
        return self._type

    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        return not (self == other)

    def __nonzero__(self):
        return self.type != 0

Event = EventType

cdef get_textinput():
    cdef SDL_Event evt
    if SDL_PeepEvents(&evt, 1, SDL_GETEVENT, SDL_TEXTINPUT, SDL_TEXTINPUT) > 0:
        return evt.text.text.decode('utf-8')
    return u''

cdef make_keyboard_event(SDL_KeyboardEvent *e):
    dargs = { 'scancode' : e.keysym.scancode,
              'key' : e.keysym.sym,
              'mod' : e.keysym.mod }
    if e.type == SDL_KEYDOWN:
        # Be careful to only check for a TEXTINPUT event when you know that
        # there will be one associated with this KEYDOWN event.
        if e.keysym.sym < 0x20:
            uchar = unichr(e.keysym.sym)
        elif e.keysym.sym <= 0xFFFF:
            uchar = get_textinput()
        else:
            uchar = u''
        dargs['unicode'] = uchar
    return EventType(e.type, dict=dargs, repeat=e.repeat)

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
    return EventType(e.type, joy=e.which, axis=e.axis, value=e.value/32768.0)

cdef make_joyball_event(SDL_JoyBallEvent *e):
    return EventType(e.type, joy=e.which, ball=e.ball, rel=(e.xrel, e.yrel))

cdef make_joyhat_event(SDL_JoyHatEvent *e):
    return EventType(e.type, joy=e.which, hat=e.hat, value=e.value)

cdef make_joybtn_event(SDL_JoyButtonEvent *e):
    return EventType(e.type, joy=e.which, button=e.button)

cdef make_window_event(SDL_WindowEvent *e):
    # SDL_APPMOUSEFOCUS
    if e.event == SDL_WINDOWEVENT_ENTER:
        return EventType(ACTIVEEVENT, state=1, gain=1)
    elif e.event == SDL_WINDOWEVENT_LEAVE:
        return EventType(ACTIVEEVENT, state=1, gain=0)

    # SDL_APPINPUTFOCUS
    elif e.event == SDL_WINDOWEVENT_FOCUS_GAINED:
        return EventType(ACTIVEEVENT, state=2, gain=1)
    elif e.event == SDL_WINDOWEVENT_FOCUS_LOST:
        return EventType(ACTIVEEVENT, state=2, gain=0)

    # SDL_APPACTIVE
    elif e.event == SDL_WINDOWEVENT_RESTORED:
        return EventType(ACTIVEEVENT, state=4, gain=1)
    elif e.event == SDL_WINDOWEVENT_MINIMIZED:
        return EventType(ACTIVEEVENT, state=4, gain=0)

    elif e.event == SDL_WINDOWEVENT_RESIZED:
        return EventType(VIDEORESIZE, size=(e.data1, e.data2), w=e.data1, h=e.data2)

    elif e.event == SDL_WINDOWEVENT_EXPOSED:
        return EventType(VIDEOEXPOSE)

    return EventType(SDL_WINDOWEVENT, event=e.event, data1=e.data1, data2=e.data2)

cdef make_event(SDL_Event *e):
    if e.type in (SDL_KEYDOWN, SDL_KEYUP):
        return make_keyboard_event(<SDL_KeyboardEvent*>e)
    elif e.type == SDL_MOUSEMOTION:
        return make_mousemotion_event(<SDL_MouseMotionEvent*>e)
    elif e.type in (SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP):
        return make_mousebtn_event(<SDL_MouseButtonEvent*>e)
    elif e.type == SDL_MOUSEWHEEL:
        return make_mousewheel_event(<SDL_MouseWheelEvent*>e)
    elif e.type == SDL_JOYAXISMOTION:
        return make_joyaxis_event(<SDL_JoyAxisEvent*>e)
    elif e.type == SDL_JOYBALLMOTION:
        return make_joyball_event(<SDL_JoyBallEvent*>e)
    elif e.type == SDL_JOYHATMOTION:
        return make_joyhat_event(<SDL_JoyHatEvent*>e)
    elif e.type in (SDL_JOYBUTTONDOWN, SDL_JOYBUTTONUP):
        return make_joybtn_event(<SDL_JoyButtonEvent*>e)
    elif e.type == SDL_WINDOWEVENT:
        return make_window_event(<SDL_WindowEvent*>e)
    elif e.type >= SDL_USEREVENT:
        # Can't do anything useful with data1 and data2 here.
        return EventType(e.type, code=e.user.code)

    return EventType(e.type)


def pump():
    SDL_PumpEvents()

cdef get_bytype(Uint32 tmin, Uint32 tmax):
    evts = []
    for e in event_queue:
        if tmin <= e.type <= tmax:
            evts.append(e)
    for e in evts:
        event_queue.remove(e)

    cdef SDL_Event evt
    while SDL_PeepEvents(&evt, 1, SDL_GETEVENT, tmin, tmax) > 0:
        evts.append(make_event(&evt))
    return evts

def get(t=None):
    SDL_PumpEvents()
    if t == None:
        return get_bytype(SDL_FIRSTEVENT, SDL_LASTEVENT)
    elif type(t) == int:
        return get_bytype(t, t)
    else:
        evts = []
        for et in t:
            evts += get_bytype(et, et)
        return evts

def poll():
    cdef SDL_Event evt

    if len(event_queue) > 0:
        return event_queue.pop(0)

    if SDL_PollEvent(&evt) == 1:
        return make_event(&evt)
    else:
        return EventType(0)

def wait():
    cdef SDL_Event evt

    if len(event_queue) > 0:
        return event_queue.pop(0)

    if SDL_WaitEvent(&evt):
        return make_event(&evt)
    else:
        return EventType(0) # NOEVENT

def peek(t=None):
    if t == None:
        return len(event_queue) > 0 or SDL_HasEvents(SDL_FIRSTEVENT, SDL_LASTEVENT)
    elif type(t) == int:
        return event_queue.has(t) or SDL_HasEvent(t)
    else:
        for et in t:
            if event_queue.has(et) or SDL_HasEvent(et):
                return True
        return False

def clear(t=None):
    if t == None:
        SDL_FlushEvents(SDL_FIRSTEVENT, SDL_LASTEVENT)
        del event_queue[:]
    elif type(t) == int:
        event_queue.flush(t)
        SDL_FlushEvent(t)
    else:
        for et in t:
            event_queue.flush(et)
            SDL_FlushEvent(et)

def event_name(t):
    try:
        return event_names[t]
    except KeyError:
        return "UNKNOWN"

def set_blocked(t=None):
    if t == None:
        for et in event_names.keys():
            SDL_EventState(et, SDL_ENABLE)
    elif type(t) == int:
        SDL_EventState(t, SDL_IGNORE)
    else:
        for et in t:
            SDL_EventState(et, SDL_IGNORE)

def set_allowed(t=None):
    if t == None:
        for et in event_names.keys():
            SDL_EventState(et, SDL_IGNORE)
    elif type(t) == int:
        SDL_EventState(t, SDL_ENABLE)
    else:
        for et in t:
            SDL_EventState(et, SDL_ENABLE)

def get_blocked(t):
    return SDL_EventState(t, SDL_QUERY) == SDL_IGNORE

def set_grab(on):
    SDL_SetWindowGrab(main_window.window, on)

def get_grab():
    return SDL_GetWindowGrab(main_window.window)

def post(e):
    # TODO: display.quit() should clear the block list?? Based on unit test.
    if not get_blocked(e.type):
        event_queue.append(e)

def init():
    SDL_Init(SDL_INIT_EVENTS)
