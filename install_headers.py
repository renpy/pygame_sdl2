#!/usr/bin/env python3

import argparse
import pathlib
import shutil

from setuplib import gen


def main():

    ap = argparse.ArgumentParser()
    target = ap.add_argument("target", help="The target directory to install headers to.")
    args = ap.parse_args()

    headers = [
        "src/pygame_sdl2/pygame_sdl2.h",
        gen + "/pygame_sdl2.rwobject_api.h",
        gen + "/pygame_sdl2.surface_api.h",
        gen + "/pygame_sdl2.display_api.h",
        ]



    headers_dir = pathlib.Path(args.target) / "pygame_sdl2"

    headers_dir.mkdir(exist_ok=True)

    for header in headers:
        srcpath = pathlib.Path(header)
        dstpath = headers_dir / srcpath.name

        shutil.copy(srcpath, dstpath)

if __name__ == "__main__":
    main()
