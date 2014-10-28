import sys, os
sys.path += ['src']
import pygame_sdl2 as pygame
#import pygame

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

img_flip = pygame.transform.flip(img, False, True)
pygame.image.save(img_flip, fn + "_flip.png")

img_90 = pygame.transform.rotate(img, 90)
pygame.image.save(img_90, fn + "_90.png")

img_45 = pygame.transform.rotate(img, 45)
pygame.image.save(img_45, fn + "_45.png")

img_scale = pygame.transform.scale(img, (200, 200))
pygame.image.save(img_scale, fn + "_scale.bmp")
