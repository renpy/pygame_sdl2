#!/usr/bin/env python

from __future__ import print_function
from __future__ import unicode_literals

import argparse
import re

import util

# An up-to-date rgb.txt is available from freedesktop.org:
# http://cgit.freedesktop.org/xorg/app/rgb

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("rgb_txt", default="/usr/share/X11/rgb.txt", nargs='?')
    args = ap.parse_args()

    colors = {}
    with open(args.rgb_txt, "r") as fin:
        for l in fin:
            m = re.match(r'\s*(\d+)\s+(\d+)\s+(\d+)\s+(.+)', l)
            if m:
                r, g, b, name = m.groups()
                name = "".join(name.split()).lower()
                colors[name] = (int(r), int(g), int(b))

    with util.open_include("color_dict.pxi") as fout:
        fout.write("cdef object colors = {\n")
        for k in sorted(colors.keys()):
            fout.write("    '{}' : {},\n".format(k, colors[k]))
        fout.write("}\n")

if __name__ == "__main__":
    main()
