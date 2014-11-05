import pygame_sdl2; pygame_sdl2.import_as_pygame()
import sys, os
import pygame

if len(sys.argv) < 2:
    print "Usage: %s <filename>" % sys.argv[0]
    sys.exit(0)

print pygame.mixer.get_init()
pygame.mixer.pre_init(frequency=44100)
pygame.init()
print pygame.mixer.get_init()
snd = pygame.mixer.Sound(sys.argv[1])
channel = snd.play()

pygame.time.wait(1000)
channel.set_volume(0.0, 1.0)
channel.fadeout(1000)

pygame.time.wait(1000)
