#!/usr/bin/env python

from __future__ import print_function
from __future__ import unicode_literals

import argparse
import re

import util

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("events_h", default="/usr/include/SDL2/SDL_events.h", nargs='?')
    args = ap.parse_args()

    lines = [ ]

    # Find the SDL_EventType enum.
    with open(args.events_h, "r") as f:
        for l in f:
            if l.startswith("typedef enum"):
                lines = [ ]
                continue
            if l.startswith("} SDL_EventType;"):
                break

            lines.append(l)

    # A list of SDL_-prefixed event names.
    sdl_events = [ ]

    # Parse the SDL_<name> event names.
    for l in lines:
        m = re.match(r'\s*(SDL_\w+)', l)
        if m:
            sdl_events.append(m.group(1))

    # A pygame event name corresponding to each of the events in SDL_EVENTS.
    events = [ ]

    for sdl_name in sdl_events:
        name = sdl_name[4:]

        if name == "FIRSTEVENT":
            name = "NOEVENT"

        events.append(name)

    with util.open_include("event_enum.pxi") as f:
        f.write("""\
cdef extern from "SDL.h":
    enum SDL_EventType:
""")

        for sdl_name in sdl_events:
            f.write("        {}\n".format(sdl_name))

    # Write a list of events to be included by .locals.pyx
    with util.open_include("event_list.pxi") as f:
        for sdl_name, name in zip(sdl_events, events):
            f.write("{} = {}\n".format(name, sdl_name))


    # Write a dict of event names to be included by .event.pyx
    with util.open_include("event_names.pxi") as f:

        f.write("event_names = {\n")

        for sdl_name, name in zip(sdl_events, events):
            f.write("    {} : {!r},\n".format(sdl_name, name))

        f.write("}\n")

if __name__ == "__main__":
    main()
