#!/usr/bin/env python

import socket
import sys

HOST = "lucy12"
SECRET = "I didn't really want to write this code, but ssh on windows sucked so bad."

def main():

    s = socket.socket()
    s.connect((HOST, 22222))

    f = s.makefile("wb+")

    f.write(SECRET + "\n")

    # Run everything with mingw.
    f.write("c:/mingw/msys/1.0/bin/sh.exe\n")

    for i in sys.argv[1:]:
        f.write(i + "\n")

    f.write("\n")

    f.flush()

    code = 255

    for l in f:
        if l[0] == "R":
            code = int(l[2:])
        else:
            sys.stdout.write(l[2:])

    sys.exit(code)

if __name__ == "__main__":
    main()
