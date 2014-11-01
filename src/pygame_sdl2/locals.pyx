from sdl2 cimport *
cimport sdl2

include "event_list.pxi"
include "keycode_list.pxi"

from rect import Rect
from color import Color

# SRCALPHA is no longer a flag.
SRCALPHA = 0

RLEACCEL = SDL_RLEACCEL
