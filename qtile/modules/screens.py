from libqtile.config import Screen

from .variables import Variables
from .widgets import init_bar

screens = []

if Variables.monitors < 3:
    screens = [
        Screen(
            top=init_bar(),
            wallpaper=Variables.qconf + 'images/wallpaper.jpg',
            wallpaper_mode='fill',
        ),
    ]
else:
    screens = [
        Screen(
            wallpaper=Variables.qconf + 'images/wallpaper.jpg',
            wallpaper_mode='fill',
        ),
        Screen(
            top=init_bar(),
            wallpaper=Variables.qconf + 'images/wallpaper.jpg',
            wallpaper_mode='fill',
        ),
        Screen(
            wallpaper=Variables.qconf + 'images/wallpaper.jpg',
            wallpaper_mode='fill',
        ),
    ]
