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
#
# pygame.mixer.music.load(sys.argv[1])
# pygame.mixer.music.play()
# pygame.mixer.music.fadeout(2000)

snd = pygame.mixer.Sound(sys.argv[1])
print snd.get_length()
channel = snd.play()
channel.queue(snd)

channel.set_volume(.1)
print channel.get_volume()

pygame.time.wait(3000)
# channel.set_volume(0.0, 1.0)
# channel.fadeout(1000)
# pygame.time.wait(1000)
