#!/usr/bin/env python

from __future__ import print_function
from __future__ import unicode_literals

import os
import argparse
import json

import util

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("keycode_h", default="/usr/include/SDL2/SDL_keycode.h", nargs='?')
    args = ap.parse_args()

    os.chdir(ROOT)
    kclist = []

    # Just match SDLK_*
    with open(args.keycode_h, "r") as fin, util.open_include("keycode_list.pxi") as fout:
        for l in fin:
            if l.startswith("    SDLK_"):
                kc = l.split()[0]
                kclist.append(kc)
                fout.write("{} = {}\n".format(kc[3:], kc))

    with open("include/enums.json") as f:
        jenums = json.load(f)

    sclist = jenums["SDL_Scancode"]

    with util.open_include("scancode_dict.pxi") as fout:
        fout.write("cdef object scancodes = {\n")
        for kc in kclist:
            sc = kc.replace('SDLK_', 'SDL_SCANCODE_').upper()
            if sc in sclist:
                fout.write("    {} : {},\n".format(kc, sc))
        fout.write("}\n")

if __name__ == "__main__":
    main()
