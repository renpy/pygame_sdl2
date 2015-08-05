from __future__ import division, print_function, absolute_import

import pygame_sdl2 as pygame
from pygame_sdl2.locals import *

pygame.init()
surf = pygame.display.set_mode((400, 400))

surf.fill((255, 0, 0, 255))
pygame.display.update()

pygame.event.set_mousewheel_buttons(False)

while True:
    ev = pygame.event.wait()

    if ev.type == QUIT:
        break

    if ev.type == KEYDOWN and ev.key == K_ESCAPE:
        break

    print(ev)
