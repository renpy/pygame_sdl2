import pygame_sdl2; pygame_sdl2.import_as_pygame()
import sys, os
import pygame
import pygame.render
from pygame.locals import *

import random

SCREEN_WIDTH = 768
SCREEN_HEIGHT = 640
SPRITE_SCALE = 2

class CharSprite(object):
    def __init__(self, parts, pos=(0,0)):
        self.parts = parts
        self.pos = pos

    def draw(self, screen):
        for p in self.parts:
            screen.render(p, self.pos)


def main():
    pygame.init()
    pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("SDL2 render test")
    r = pygame.render.Renderer(vsync=False)
    print r.info()

    # A sprite sheet generated from RLTiles.
    atlas = r.load_atlas('rlplayer.json')

    tile_size = 32 * SPRITE_SCALE

    parts = {}

    for k in atlas.keys():
        atlas[k].scale = SPRITE_SCALE

        cat = k.split("/")[1]
        try:
            parts[cat].append(atlas[k])
        except KeyError:
            parts[cat] = [atlas[k]]

    sprites = []
    x = 0
    y = 0
    while y < SCREEN_HEIGHT:
        while x < SCREEN_WIDTH:
            sprite_parts = []
            for ptype in ["base", "leg", "boot", "body", "hair", "hand1"]:
                sprite_parts.append(random.choice(parts[ptype]))
            sprites.append(CharSprite(sprite_parts, (x,y)))

            x += tile_size
        y += tile_size
        x = 0

    clock = pygame.time.Clock()

    running = True
    while running:
        events = pygame.event.get()
        for e in events:
            if e.type == QUIT:
                running = False
            elif e.type == KEYDOWN and e.key == K_ESCAPE:
                running = False

        r.clear((0,0,100))
        for s in sprites:
            s.draw(r)
        r.render_present()
        clock.tick()

    print clock.get_fps()

if __name__ == '__main__':
    main()
