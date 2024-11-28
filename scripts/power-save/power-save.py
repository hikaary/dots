import logging
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Self, Sequence


class ColoredFormatter(logging.Formatter):
    """Форматтер для цветного вывода логов."""

    COLORS = {
        logging.DEBUG: '\033[0;37m',  # Gray
        logging.INFO: '\033[0;32m',  # Green
        logging.WARNING: '\033[1;33m',  # Yellow
        logging.ERROR: '\033[0;31m',  # Red
    }
    RESET = '\033[0m'

    def format(self, record: logging.LogRecord) -> str:
        color = self.COLORS.get(record.levelno, self.RESET)
        record.levelname = f'{color}[{record.levelname}]{self.RESET}'
        return super().format(record)


def setup_logging() -> None:
    """Настройка логгера с цветным выводом."""
    handler = logging.StreamHandler()
    handler.setFormatter(
        ColoredFormatter('%(levelname)s %(message)s'),
    )

    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)


@dataclass
class PowerManager:
    packages: Sequence[str] = (
        'acpi',  # ACPI утилиты
        'acpi_call',  # Дополнительные ACPI функции
        'powertop',  # Анализ энергопотребления
        'thermald',  # Термальный контроль
        'cpupower',  # Управление CPU
    )
    logger: logging.Logger = logging.getLogger(__name__)
    config_root: Path = Path.home() / '.config/scripts/power-save'

    @classmethod
    def create(cls) -> Self:
        """Создание экземпляра с подготовкой директорий."""
        config_root = Path.home() / '.config/scripts/power-save'
        config_root.mkdir(parents=True, exist_ok=True)
        return cls(config_root=config_root)

    def _apply_config(
        self,
        config_name: str,
        system_path: Path,
    ) -> None:
        """Применение конфига из локальной директории в систему."""
        config_path = self.config_root / 'configs' / config_name
        if not config_path.exists():
            self.logger.error(f'Config not found: {config_path}')
            return

        system_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(config_path, system_path)
        self.logger.info('Applied config: %s -> %s', config_name, system_path)

    def install_packages(self) -> None:
        """Установка необходимых пакетов."""
        self.logger.info('Installing required packages...')

        pacman_path = shutil.which('pacman')
        if not pacman_path:
            self.logger.error('pacman not found')
            sys.exit(1)

        try:
            subprocess.run(
                [pacman_path, '-Sy', '--needed', '--noconfirm', *self.packages],
                check=True,
            )
        except subprocess.CalledProcessError as e:
            self.logger.error('Failed to install packages: %s', e)
            sys.exit(1)

        # Устанавливаем auto-cpufreq через AUR
        paru_path = shutil.which('paru')
        if not paru_path:
            self.logger.error('paru not found')
            sys.exit(1)

        try:
            subprocess.run(
                [paru_path, '-S', '--noconfirm', 'auto-cpufreq'],
                check=True,
            )
        except subprocess.CalledProcessError as e:
            self.logger.error('Failed to install auto-cpufreq: %s', e)
            sys.exit(1)

    def configure_system(self) -> None:
        """Настройка параметров системы."""
        self.logger.info('Configuring system parameters...')

        configs = {
            'sysctl.conf': '/etc/sysctl.d/99-sysctl-performance.conf',
            'cpupower.conf': '/etc/default/cpupower',
            'ioschedulers.rules': '/etc/udev/rules.d/60-ioschedulers.rules',
            'power-mode-switch.service': '/etc/systemd/system/power-mode-switch.service',
            'power-mode-switch': '/usr/local/bin/power-mode-switch',
        }

        for config_name, system_path in configs.items():
            self._apply_config(config_name, Path(system_path))

        power_switch_path = Path('/usr/local/bin/power-mode-switch')
        if power_switch_path.exists():
            power_switch_path.chmod(0o755)

    def enable_services(self) -> None:
        """Активация служб."""
        self.logger.info('Enabling services...')

        services = ['cpupower', 'thermald', 'auto-cpufreq', 'power-mode-switch']

        subprocess.run(['modprobe', 'acpi_cpufreq'], check=False)
        subprocess.run(['modprobe', 'cpufreq_ondemand'], check=False)

        for service in services:
            try:
                subprocess.run(
                    ['systemctl', 'enable', f'{service}.service'],
                    check=True,
                )
                subprocess.run(
                    ['systemctl', 'start', f'{service}.service'],
                    check=True,
                )
                self.logger.info('✓ %s.service active', service)
            except subprocess.CalledProcessError as e:
                self.logger.warning('⚠ %s.service failed: %s', service, e)

    def setup(self) -> None:
        """Основная функция настройки."""
        if subprocess.getoutput('id -u') != '0':
            self.logger.error('This script must be run as root')
            sys.exit(1)

        try:
            self.install_packages()
            self.configure_system()
            self.enable_services()

            subprocess.run(['systemctl', 'daemon-reload'], check=True)

            self.logger.info('Power optimization completed successfully!')
            self.logger.warning(
                'Please reboot your system to apply all changes.',
            )
        except Exception as e:
            self.logger.error('Setup failed: %s', e)
            sys.exit(1)


def main() -> None:
    """Точка входа в программу."""
    setup_logging()
    power_manager = PowerManager.create()
    power_manager.setup()


if __name__ == '__main__':
    main()
