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

atlas = r.load_atlas('rlplayer.json')

clock = pygame.time.Clock()

i = 0
pos = (00,00)
running = True
while running:
    events = pygame.event.get()
    for e in events:
        if e.type == QUIT:
            running = False
        elif e.type == KEYDOWN and e.key == K_ESCAPE:
            running = False

    r.clear((0,0,100))
    pos = pos[0]+1, pos[1]+1
    r.render(atlas["player/base/elf_m"], pos)
    r.render(atlas["player/leg/pants_black"], pos)
    r.render(atlas["player/body/bplate_green"], pos)
    r.render(atlas["player/hair/elf_yellow"], pos)
    r.render(atlas["player/hand1/broadsword"], pos)
    r.render_present()
    clock.tick(60)
    i += 1
