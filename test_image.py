# coding=utf-8

from __future__ import unicode_literals, print_function

import pygame_sdl2; pygame_sdl2.import_as_pygame()
import sys, os
import pygame

if len(sys.argv) < 2:
    print("Usage: %s <filename>" % sys.argv[0])
    sys.exit(0)

pygame.init()

fn = sys.argv[1]
img = pygame.image.load(fn)
fn = os.path.split(fn)[1]
fn = os.path.splitext(fn)[0]

print(pygame.image.get_extended())

pygame.image.save(img, fn + "_new.png")

w, h = img.get_size()

img_flip = pygame.transform.flip(img, False, True)
pygame.image.save(img_flip, fn + "_flip.png")

img_90 = pygame.transform.rotate(img, 90)
pygame.image.save(img_90, fn + "_90.png")

img_45 = pygame.transform.rotate(img, 45)
pygame.image.save(img_45, fn + "_45.png")

img_scale = pygame.transform.scale(img, (w*2, h*2))
pygame.image.save(img_scale, fn + "_scale.png")

img_smoothscale = pygame.transform.smoothscale(img, (w*2, h*2))
pygame.image.save(img_smoothscale, fn + "_smoothscale.png")

img_scale2x = pygame.transform.scale2x(img)
pygame.image.save(img_scale2x, fn + "_scale2x.png")

f = pygame.font.Font('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 32)
f.set_italic(True)
assert f.get_italic()
assert not f.get_bold()
surf = f.render(u"Grüßchen, SDL_ttf!", True, (0,0,0))
pygame.image.save(surf, "sdl_ttf.png")

ja_font = pygame.font.Font('/usr/share/fonts/truetype/droid/DroidSansJapanese.ttf', 32)
surf = ja_font.render(u"日本語", True, (0,0,0), (255,255,255))
pygame.image.save(surf, "sdl_ttf2.png")

import pygame.gfxdraw

img_draw = img.copy()
pygame.gfxdraw.pixel(img_draw, 0, 0, (255,0,0))
pygame.gfxdraw.rectangle(img_draw, (20, 20, 20, 20), (0,255,0))
pygame.gfxdraw.box(img_draw, (20, 0, 20, 20), (255,0,255))
pygame.gfxdraw.polygon(img_draw, [(0,0), (100,100), (100,150), (0,150), (20,20)], pygame.Color("blue"))
pygame.draw.line(img_draw, (0,255,255), (20, 20), (30, 100), 4)
pygame.draw.lines(img_draw, (255,0,0), False, [(10, 10), (100, 10), (50, 50)], 3)
pygame.image.save(img_draw, fn + "_draw.png")
