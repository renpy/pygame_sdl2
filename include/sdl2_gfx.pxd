from sdl2 cimport *

cdef extern from "SDL2_rotozoom.h" nogil:
    cdef enum:
        SMOOTHING_OFF
        SMOOTHING_ON

    SDL_Surface *rotozoomSurface(SDL_Surface * src, double angle, double zoom, int smooth)
    SDL_Surface *rotozoomSurfaceXY(SDL_Surface * src, double angle, double zoomx, double zoomy, int smooth)
    void rotozoomSurfaceSize(int width, int height, double angle, double zoom, int *dstwidth, int *dstheight)
    void rotozoomSurfaceSizeXY(int width, int height, double angle, double zoomx, double zoomy, int *dstwidth, int *dstheight)

    SDL_Surface *zoomSurface(SDL_Surface * src, double zoomx, double zoomy, int smooth)
    void zoomSurfaceSize(int width, int height, double zoomx, double zoomy, int *dstwidth, int *dstheight)

    SDL_Surface *shrinkSurface(SDL_Surface * src, int factorx, int factory)
    SDL_Surface* rotateSurface90Degrees(SDL_Surface* src, int numClockwiseTurns)
