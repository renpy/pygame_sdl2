try:
    import pygame_sdl2
    pygame_sdl2.import_as_pygame()
except:
    pass

import pygame

A = 255


def bottom_pattern(s):
    s.subsurface((0, 0, 150, 50)).fill((255, 255, 0, A))
    s.subsurface((0, 100, 150, 50)).fill((255, 255, 0, A))

def top_pattern(s):
    s.subsurface((15, 15, 120, 120)).fill((255, 0, 255, A))
    s.subsurface((30, 30, 90, 90)).fill((0, 255, 255, A))

def case(src_alpha, dst_alpha, colorkey, alpha):

    if src_alpha:
        src = pygame.Surface((150, 150), pygame.SRCALPHA)
    else:
        src = pygame.Surface((150, 150), 0)

    if dst_alpha:
        dst = pygame.Surface((150, 150), pygame.SRCALPHA)
    else:
        dst = pygame.Surface((150, 150), 0)


    top_pattern(src)
    bottom_pattern(dst)

    if colorkey:
        src.set_colorkey((255, 0, 255, A))

    if alpha:
        src.set_alpha(128)

    dst.blit(src, (0, 0))


    return dst



PATTERN = [ (False, False), (False, True), (True, False), (True, True) ]


def draw():
    screen = pygame.display.get_surface()

    f = pygame.font.Font(None, 18)

    screen.fill((128, 128, 128, 255))

    for xi, (src_alpha, dst_alpha) in enumerate(PATTERN):
        for yi, (colorkey, alpha) in enumerate(PATTERN):
            surf = case(src_alpha, dst_alpha, colorkey, alpha)
            screen.blit(surf, (xi * 250 + 50, yi * 250 + 50))

            s = "src={}, dst={}".format(
                "RGBA" if src_alpha else "RGB",
                "RGBA" if dst_alpha else "RGB",
                )

            surf = f.render(s, True, (255, 255, 255, 255))
            screen.blit(surf, (xi * 250 + 50, yi * 250 + 30))

            s = ""

            if colorkey:
                s += "colorkey "
            if alpha:
                s += "alpha "

            surf = f.render(s, True, (255, 255, 255, 255))
            screen.blit(surf, (xi * 250 + 50, yi * 250 + 200))

    pygame.display.flip()


def main():

    global A

    pygame.init()
    screen = pygame.display.set_mode((1000, 1000))

    draw()

    while True:
        ev = pygame.event.wait()

        if ev.type == pygame.KEYDOWN:
            if A == 255:
                A = 128
            else:
                A = 255

            draw()

        if ev.type == pygame.QUIT:
            break

if __name__ == "__main__":
    main()
