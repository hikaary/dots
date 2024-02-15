from libqtile.config import Screen

from .variables import Variables
from .widgets import init_bar

screens = []
wallpaper = Variables.qconf + 'images/arch.png'

screens = [
    Screen(
        top=init_bar(),
        wallpaper=wallpaper,
        wallpaper_mode='fill',
    )
]

match Variables.monitors:
    case 2:
        screens = [
            Screen(
                wallpaper=wallpaper,
                wallpaper_mode='fill',
            ),
            Screen(
                top=init_bar(),
                wallpaper=wallpaper,
                wallpaper_mode='fill',
            ),
        ]
    case 3:
        screens = [
            Screen(
                wallpaper=wallpaper,
                wallpaper_mode='fill',
            ),
            Screen(
                wallpaper=wallpaper,
                wallpaper_mode='fill',
            ),
            Screen(
                top=init_bar(),
                wallpaper=wallpaper,
                wallpaper_mode='fill',
            ),
        ]
