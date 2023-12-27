import re
import subprocess

from libqtile import bar
from libqtile.command.base import expose_command
from libqtile.widget import base

from ..variables import toggle_vpn


class Picture(base._TextBox):
    def __init__(self, scale=1, images=None, systemd=None, **config):
        base._TextBox.__init__(self, '0', **config)
        self.update_interval = 0.1
        self.scale = scale
        self.surfaces = {}
        self.images = images
        self.img_name = None
        self.systemd = systemd
        self.status = None

    def _configure(self, qtile, parent_bar):
        if self.theme_path:
            self.length_type = bar.STATIC
            self.length = 0
        base._TextBox._configure(self, qtile, parent_bar)

    def timer_setup(self):
        self.timeout_add(self.update_interval, self.update)
        if self.theme_path:
            self.setup_images()

    def update(self):
        self._update_drawer()
        self.bar.draw()
        self.timeout_add(self.update_interval, self.update)

    def _check_status(self):
        if self.systemd:
            self.status = subprocess.call(
                ['systemctl', 'is-active', '--quiet', f'{self.systemd}']
            )

    def _set_image(self):
        if not self.status:
            self.img_name = re.search(r'[^,]+-on\b', ','.join(self.images))[0]
        else:
            self.img_name = re.search(r'[^,]+-off\b', ','.join(self.images))[0]

    def _update_drawer(self):
        self._check_status()
        self._set_image()
        if self.theme_path:
            self.drawer.clear(self.background or self.bar.background)
            self.drawer.ctx.translate(
                0, (self.bar.height - self.current_image.height) // 2
            )
            self.drawer.ctx.set_source(self.surfaces[self.img_name])
            self.drawer.ctx.paint()

    def setup_images(self):
        from libqtile import images

        d_images = images.Loader(self.theme_path)(*self.images)
        for name, img in d_images.items():
            self.current_image = img
            new_height = (self.bar.height - 1) * self.scale
            img.resize(height=new_height)
            if img.width > self.length:
                self.length = img.width + self.actual_padding * 2
            self.surfaces[name] = img.pattern

    def draw(self):
        if self.theme_path:
            self.drawer.draw(
                offsetx=self.offset, offsety=self.offsety, width=self.length
            )
        else:
            base._TextBox.draw(self)


class XrayProxy(Picture):
    def __init__(self, scale=1, images=None, systemd=None, **config):
        Picture.__init__(self, scale, images, systemd, **config)
        self.add_callbacks(
            {
                'Button1': self.action1,
                'Button3': self.action3,
            }
        )

    @expose_command()
    def action1(self):
        toggle_vpn()

    @expose_command()
    def action3(self):
        toggle_vpn()
