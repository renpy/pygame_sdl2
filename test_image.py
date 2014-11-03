import pygame_sdl2; pygame_sdl2.import_as_pygame()
import sys, os
import pygame

if len(sys.argv) < 2:
    print "Usage: %s <filename>" % sys.argv[0]
    sys.exit(0)

pygame.init()

fn = sys.argv[1]
img = pygame.image.load(fn)
fn = os.path.split(fn)[1]
fn = os.path.splitext(fn)[0]

print pygame.image.get_extended()

pygame.image.save(img, fn + "_new.png")

w, h = img.get_size()

img_flip = pygame.transform.flip(img, False, True)
pygame.image.save(img_flip, fn + "_flip.png")

img_90 = pygame.transform.rotate(img, 90)
pygame.image.save(img_90, fn + "_90.png")

img_45 = pygame.transform.rotate(img, 45)
pygame.image.save(img_45, fn + "_45.png")

img_scale = pygame.transform.scale(img, (w*2, h*2))
pygame.image.save(img_scale, fn + "_scale.bmp")

img_smoothscale = pygame.transform.smoothscale(img, (w*2, h*2))
pygame.image.save(img_smoothscale, fn + "_smoothscale.png")

img_scale2x = pygame.transform.scale2x(img)
pygame.image.save(img_scale2x, fn + "_scale2x.png")
