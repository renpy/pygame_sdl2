#!/usr/bin/env python

import os
import json

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def main():
    with open(os.path.join(ROOT, "include", "enums.json")) as f:
        enums = json.load(f)

    with open(os.path.join(ROOT, "include", "glattr.pxi"), "w") as f:
        for name in enums["SDL_GLattr"]:
            f.write("{} = {}\n".format(name[4:], name))

if __name__ == "__main__":
    main()

