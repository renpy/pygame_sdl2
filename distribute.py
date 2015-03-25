#!/usr/bin/env python

import argparse
import os
import glob
import tarfile

# A list of globs matching files to be included in the tarball.
GLOBS = [
    "COPYING.*",
    "fix_virtualenv.py",
    "include/*.pxi",
    "include/*.pxd",
    "scripts/*.py",
    "README.rst",
    "sdl2.c",
    "setuplib.py",
    "setup.py",
    "src/*.h",
    "src/*.c",
    "src/pygame_sdl2/*.h",
    "src/pygame_sdl2/*.py",
    "src/pygame_sdl2/*.pyx",
    "src/pygame_sdl2/*.pxd",
    "src/pygame_sdl2/threads/*.py",
    ]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("version")
    ap.add_argument("--dest", default='dist')
    args = ap.parse_args()

    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    files = set()

    for pattern in GLOBS:
        for fn in glob.glob(pattern):
            files.add(fn)

    files = list(files)
    files.sort()

    dest = os.path.join(args.dest, "pygame_sdl2-" + args.version + ".tar.bz2")

    tf = tarfile.open(dest, "w:bz2")

    for i in files:
        tf.add(i, arcname="pygame-sdl2-" + args.version + "/" + i)

    tf.close()

if __name__ == "__main__":
    main()
