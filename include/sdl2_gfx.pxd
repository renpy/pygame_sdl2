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


cdef extern from "SDL2_gfxPrimitives.h" nogil:
    int pixelColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Uint32 color)
    int pixelRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int hlineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y, Uint32 color)
    int hlineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int vlineColor(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2, Uint32 color)
    int vlineRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int rectangleColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color)
    int rectangleRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int roundedRectangleColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint32 color)
    int roundedRectangleRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int boxColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color)
    int boxRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int roundedBoxColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint32 color)
    int roundedBoxRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int lineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color)
    int lineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int aalineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color)
    int aalineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int thickLineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 width, Uint32 color)
    int thickLineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 width, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int circleColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint32 color)
    int circleRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int arcColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint32 color)
    int arcRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int aacircleColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint32 color)
    int aacircleRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int filledCircleColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 r, Uint32 color)
    int filledCircleRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int ellipseColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint32 color)
    int ellipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int aaellipseColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint32 color)
    int aaellipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int filledEllipseColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint32 color)
    int filledEllipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int pieColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint32 color)
    int pieRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int filledPieColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint32 color)
    int filledPieRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int trigonColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint32 color)
    int trigonRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int aatrigonColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint32 color)
    int aatrigonRGBA(SDL_Renderer * renderer,  Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int filledTrigonColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint32 color)
    int filledTrigonRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int polygonColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint32 color)
    int polygonRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int aapolygonColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint32 color)
    int aapolygonRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int filledPolygonColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint32 color)
    int filledPolygonRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    int texturedPolygon(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, SDL_Surface * texture,int texture_dx,int texture_dy)

    int bezierColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, int s, Uint32 color)
    int bezierRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, int s, Uint8 r, Uint8 g, Uint8 b, Uint8 a)

    void gfxPrimitivesSetFont(const void *fontdata, Uint32 cw, Uint32 ch)
    void gfxPrimitivesSetFontRotation(Uint32 rotation)
    int characterColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, char c, Uint32 color)
    int characterRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, char c, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
    int stringColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, const char *s, Uint32 color)
    int stringRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, const char *s, Uint8 r, Uint8 g, Uint8 b, Uint8 a)