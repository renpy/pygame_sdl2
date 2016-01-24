#!/bin/bash

set -ex

SCRIPT="$(dirname $(realpath $0))"
PROJECT=build_nightly-pygame_sdl2
DATE=$(date +%Y.%m.%d)
DATE2=$(date +%Y-%m-%d)
WWW=/home/tom/magnetic/ab/WWW.nightly

rm -Rf "/home/tom/ab/$PROJECT" || true
git clone https://github.com/renpy/pygame_sdl2 "/home/tom/ab/$PROJECT"

cd "/home/tom/ab/$PROJECT"

git clone https://github.com/renpy/pygame_sdl2_windeps
"$SCRIPT/build_all.sh" $PROJECT a$DATE

cp $WWW/current/*-$DATE2-*-rapt.zip dist/android.zip || true
cp $WWW/current/*-$DATE2-*-renios.zip dist/ios.zip || true

D="$WWW/pygame_sdl2/nightly-$DATE2"

rm -Rf $D
mkdir -p $D
cp -a dist/* $D

rm "$WWW/pygame_sdl2/current" || true
ln -s "nightly-$DATE2" "$WWW/pygame_sdl2/current"

# Upload everything to the server.
rsync -av /home/tom/magnetic/ab/WWW.nightly/pygame_sdl2/ tom@erika.onegeek.org:/home/tom/WWW.nightly/pygame_sdl2 --delete

# Delete old nightlies.
find /home/tom/magnetic/ab/WWW.nightly/pygame_sdl2/ -ctime +30 -delete
