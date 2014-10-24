import pygame_sdl2.display
import pygame_sdl2.event
from pygame_sdl2.locals import *

pygame_sdl2.display.init()
pygame_sdl2.event.init()

pygame_sdl2.display.set_mode((200, 200))

while True:
    ev = pygame_sdl2.event.wait()

    if ev.type == QUIT:
        break
