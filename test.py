from __future__ import division, print_function, absolute_import

import pygame_sdl2 as pygame
from pygame_sdl2.locals import *

pygame.init()
surf = pygame.display.set_mode((400, 400))

surf.fill((255, 0, 0, 255))
pygame.display.update()

pygame.event.set_mousewheel_buttons(False)

controllers = [ ]

for i in range(pygame.controller.get_count()):
    c = pygame.controller.Controller(i)
    print(c.get_name(), c.is_controller())

    if c.is_controller():
        c.init()

while True:
    ev = pygame.event.wait()

    if ev.type == QUIT:
        break

    if ev.type == KEYDOWN and ev.key == K_ESCAPE:
        break

    if ev.type == CONTROLLERAXISMOTION:
        print(pygame.controller.get_string_for_axis(ev.axis))

    if ev.type in (CONTROLLERBUTTONDOWN, CONTROLLERBUTTONUP):
        print(pygame.controller.get_string_for_button(ev.button))

    print(ev)
