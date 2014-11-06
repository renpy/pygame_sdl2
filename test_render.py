import pygame_sdl2; pygame_sdl2.import_as_pygame()
import sys, os
import pygame
import pygame.render
from pygame.locals import *

import random

pygame.init()
pygame.display.set_mode((800, 600))
pygame.display.set_caption("SDL2 render test")
r = pygame.render.Renderer()

tex = r.load_texture(sys.argv[1])
qty = int(sys.argv[2])

clock = pygame.time.Clock()

i = 0
running = True
while running:
    events = pygame.event.get()
    for e in events:
        if e.type == QUIT:
            running = False
        elif e.type == KEYDOWN and e.key == K_ESCAPE:
            running = False

    r.clear((0,0,100))
    for n in range(qty):
        x = random.randint(0, 800)
        y = random.randint(0, 600)
        r.render(tex, (x, y))
    r.render_present()
    clock.tick()
    i += 1
    if i % 60 == 0:
        print "average fps = %d" % clock.get_fps()
