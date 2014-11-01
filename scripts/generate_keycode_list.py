#!/usr/bin/env python

from __future__ import print_function
from __future__ import unicode_literals

import argparse

import util

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("keycode_h", default="/usr/include/SDL2/SDL_keycode.h", nargs='?')
    args = ap.parse_args()

    # Just match SDLK_*
    with open(args.keycode_h, "r") as fin, util.open_include("keycode_list.pxi") as fout:
        for l in fin:
            if l.startswith("    SDLK_"):
                kc = l.split()[0]
                fout.write("{} = {}\n".format(kc[3:], kc))

if __name__ == "__main__":
    main()
