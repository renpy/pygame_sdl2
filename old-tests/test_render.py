import sys, os
import pygame_sdl2
import pygame_sdl2.render
from pygame_sdl2.locals import *

import random

SCREEN_WIDTH = 768
SCREEN_HEIGHT = 640
SPRITE_SCALE = 2

import pprint
pp = pprint.PrettyPrinter(indent=2)

def main():
    pygame_sdl2.init()
    pp.pprint(pygame_sdl2.render.get_drivers())
    pygame_sdl2.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT), OPENGL)
    pygame_sdl2.display.set_caption("SDL2 render test")
    r = pygame_sdl2.render.Renderer(vsync=False)
    pp.pprint(r.info())

    bg = r.load_texture('paper.jpg')

    # A sprite sheet generated from RLTiles.
    atlas = r.load_atlas('rlplayer.json')

    tile_size = 32 * SPRITE_SCALE

    parts = {}

    for k in atlas.keys():
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
            s = pygame_sdl2.render.Sprite(sprite_parts)
            s.pos = (x,y)
            s.scale = SPRITE_SCALE
            sprites.append(s)

            x += tile_size
        y += tile_size
        x = 0

    clock = pygame_sdl2.time.Clock()

    sprites[0].color = (255,0,0)
    sprites[1].color = (100,100,255)

    con = pygame_sdl2.render.Container((-64,-64,32*10,32*10))
    for s in sprites:
        con.add(s)

    running = True
    while running:
        sprites[0].rotation += 1
        if sprites[0].alpha > 0:
            sprites[0].alpha -= 1

        sprites[1].rotation -=1

        sprites[2].scale += 0.01
        if sprites[2].collides(sprites[4]):
            print "COLLISION"

        con.pos = con.pos[0] + 1, con.pos[1] + 1

        events = pygame_sdl2.event.get()
        for e in events:
            if e.type == QUIT:
                running = False
            elif e.type == KEYDOWN and e.key == K_ESCAPE:
                running = False

        r.clear((0,0,0))
        bg.render()
        con.render()
        r.render_present()
        clock.tick()

    print clock.get_fps()

if __name__ == '__main__':
    main()
