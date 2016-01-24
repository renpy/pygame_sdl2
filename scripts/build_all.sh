#!/bin/bash

set -xe

SCRIPT="$(dirname $(realpath $0))"
PROJECT="${1:-pygame_sdl2}"
SUFFIX="$2"

if test -n "$SUFFIX"; then
    EGG_INFO="egg_info --tag-build $SUFFIX"
else
    EGG_INFO=
fi

# Clean out the old buil.d
cd "/home/tom/ab/$PROJECT"

rm -Rf dist || true
mkdir dist

python setup.py build
python3 setup.py build

python setup.py $EGG_INFO sdist

"$SCRIPT/run_win.py" /t/ab/pygame_sdl2/scripts/build_win.sh "$PROJECT" "$SUFFIX"
