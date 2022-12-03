from __future__ import unicode_literals, print_function

import os
import argparse
import sys
import shutil
import sysconfig

def main():
    venv = os.environ.get("VIRTUAL_ENV", None)
    if not venv:
        print("VIRTUAL_ENV is not set.")
        sys.exit(1)

    dn = None

    for dn in os.listdir(os.path.join(venv, "include")):
        if dn.startswith("python"):
            break

    if not dn:
        print("Could not find python include directory.")
        sys.exit(0)

    target = os.path.join(venv, "include", dn)

    try:
        source = os.readlink(target)
    except:
        print(target, "is not a symlink. Perhaps this script has already been run.")
        sys.exit(1)

    tmp = target + ".tmp"

    if os.path.exists(tmp):
        shutil.rmtree(tmp)

    os.mkdir(tmp)

    for i in os.listdir(source):
        if i == "pygame_sdl2":
            continue

        os.symlink(os.path.join(source, i), os.path.join(tmp, i))

    os.unlink(target)
    os.rename(tmp, target)

if __name__ == "__main__":
    main()
