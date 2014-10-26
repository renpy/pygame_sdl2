import pygame_sdl2 as pygame
from pygame_sdl2.locals import *

pygame.init()
pygame.display.set_mode((200, 200))

while True:
    ev = pygame.event.wait()

    if ev.type == QUIT:
        break
