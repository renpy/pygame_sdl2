#!/usr/bin/env python3

import argparse
import pathlib
import shutil
import sysconfig

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

    targets = [
        pathlib.Path(args.target) / "include" / "pygame_sdl2",
        pathlib.Path(args.target) / "include" / ("python" + sysconfig.get_config_var("py_version_short")) / "pygame_sdl2",
    ]

    for target in targets:

        target.mkdir(exist_ok=True, parents=True)

        for header in headers:
            srcpath = pathlib.Path(header)
            dstpath = target / srcpath.name

            shutil.copy(srcpath, dstpath)

if __name__ == "__main__":
    main()
