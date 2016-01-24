PROJECT="${1:-pygame_sdl2}"
SUFFIX="$2"

set -ex

if test -n "$SUFFIX"; then
    EGG_INFO="egg_info --tag-build $SUFFIX"
else
    EGG_INFO=
fi

cd "/t/ab/$PROJECT"

/c/python27/python.exe setup.py $EGG_INFO bdist_wheel
/c/64python27/python.exe setup.py $EGG_INFO bdist_wheel

/c/python35/python.exe setup.py $EGG_INFO bdist_wheel
/c/64python35/python.exe setup.py $EGG_INFO bdist_wheel
