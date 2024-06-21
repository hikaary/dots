"""Flash plugin for pyprland
Exposes a "flash" command: pypr flash to apply a flash effect to the current window
- listens to openwindow and activewindowv2 Hyprland events to apply flash effect
- uses flash_opacity, flash_duration, flash_on_open, and flash_on_focus configuration items
"""

import asyncio

from pyprland.plugins.interface import Plugin


class Extension(Plugin):
    """Flash effect plugin for Hyprland."""

    last_focus = ""

    async def run_flash(self, args=""):
        """Apply flash effect to the current or specified window."""
        addr = args or await self.get_active_window_address()
        await self._apply_flash(addr)

    async def event_activewindowv2(self, addr: str) -> None:
        """Apply flash effect when window becomes active."""
        if self.last_focus == addr:
            return
        self.last_focus = addr
        win_addr = "0x" + addr
        await self._apply_flash(win_addr)

    async def get_active_window_address(self):
        """Get the address of the currently active window."""
        active_window = await self.hyprctl_json("activewindow")
        return active_window["address"] if active_window else ""

    async def set_window_alpha(self, addr: str, alpha: float) -> None:
        """Set the alpha of the specified window."""
        await self.hyprctl(f"address:{addr} alpha {alpha}", "setprop")

    async def set_window_size_and_position(
        self, addr: str, size: list, position: list
    ) -> None:
        """Set the size and position of the specified window."""
        size_str = f"{size[0]},{size[1]}"
        position_str = f"{position[0]},{position[1]}"
        await self.hyprctl(f"movewindowpixel {position_str} {addr}")
        await self.hyprctl(f"resizewindowpixel {size_str} {addr}")

    async def _apply_flash(self, addr: str) -> None:
        """Apply the flash effect to the specified window."""
        self.log.info(self.config)
        clients = await self.hyprctl_json("clients")
        target_client = next((c for c in clients if c["address"] == addr), None)

        if not target_client:
            return

        original_alpha = target_client.get("alpha", 1.0)
        flash_opacity = self.config.get("flash_opacity", 0.5)
        duration = self.config.get("duration", 0.1)

        steps = 10
        step_duration = duration / steps
        for step in range(steps):
            alpha = original_alpha + (flash_opacity - original_alpha) * (step / steps)
            await self.set_window_alpha(addr, alpha)
            await asyncio.sleep(step_duration)

        for step in range(steps):
            alpha = flash_opacity + (original_alpha - flash_opacity) * (step / steps)
            await self.set_window_alpha(addr, alpha)
            await asyncio.sleep(step_duration)

        self.log.info(f"Applied flash effect to window {addr}")
