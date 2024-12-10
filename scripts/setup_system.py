import logging
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Self


class ColoredFormatter(logging.Formatter):
    """Форматтер для цветного вывода логов."""

    COLORS = {
        logging.DEBUG: '\033[0;37m',  # Gray
        logging.INFO: '\033[0;34m',  # Blue
        logging.WARNING: '\033[1;33m',  # Yellow
        logging.ERROR: '\033[0;31m',  # Red
        logging.CRITICAL: '\033[1;31m',  # Bold Red
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
class SystemSetup:
    sudo_user: str
    home_dir: Path
    logger: logging.Logger = logging.getLogger(__name__)

    @classmethod
    def create(cls) -> Self:
        """Создание экземпляра класса с проверкой требований."""
        if subprocess.getoutput('id -u') != '0':
            logging.error('This script must be run as root')
            logging.warning(
                "Please use 'su -' or 'sudo -i' to switch to the root user",
            )
            sys.exit(1)

        sudo_user = subprocess.getoutput('echo $SUDO_USER')
        if not sudo_user:
            logging.error('Could not determine SUDO_USER')
            sys.exit(1)

        return cls(
            sudo_user=sudo_user,
            home_dir=Path(f'/home/{sudo_user}'),
        )

    def run_as_user(
        self,
        cmd: str,
        check: bool = True,
    ) -> subprocess.CompletedProcess[str]:
        """Запуск команды от имени пользователя."""
        return subprocess.run(
            ['su', '-', self.sudo_user, '-c', cmd],
            check=check,
            capture_output=True,
            text=True,
        )

    def check_system_requirements(self) -> None:
        """Проверка системных требований."""
        if not Path('/run/systemd/system').exists():
            self.logger.error('This script requires systemd to be running')
            sys.exit(1)

        if not Path('/etc/arch-release').exists():
            self.logger.error('This script is designed for Arch Linux')
            sys.exit(1)

    def command_exists(self, cmd: str) -> bool:
        """Проверка наличия команды в системе."""
        return bool(shutil.which(cmd))

    def install_rust(self) -> None:
        """Установка Rust."""
        self.logger.info('Installing Rust...')
        if not self.command_exists('rustc'):
            try:
                self.run_as_user(
                    'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y',
                )
                self.run_as_user('source $HOME/.cargo/env')
                self.logger.info('Rust installed successfully')
            except subprocess.CalledProcessError as e:
                self.logger.error('Failed to install Rust: %s', e)
                sys.exit(1)
        else:
            self.logger.warning('Rust is already installed')

    def install_aur_helper(self, helper: str, install_cmd: str) -> None:
        """Установка AUR helper."""
        self.logger.info('Installing %s...', helper)
        if not self.command_exists(helper):
            try:
                if not self.command_exists('git'):
                    subprocess.run(
                        ['pacman', '-S', '--noconfirm', 'git'],
                        check=True,
                    )

                self.run_as_user(install_cmd)
                self.logger.info('%s installed successfully', helper)
            except subprocess.CalledProcessError as e:
                self.logger.error('Failed to install %s: %s', helper, e)
                sys.exit(1)
        else:
            self.logger.warning('%s is already installed', helper)

    def setup_hyprpanel(self) -> None:
        """Установка и настройка HyprPanel."""
        self.logger.info('Setting up HyprPanel...')

        config_dir = self.home_dir / '.config'
        config_dir.mkdir(exist_ok=True)

        ags_dir = config_dir / 'ags'
        if ags_dir.exists():
            backup_dir = config_dir / 'ags.bkup'
            if backup_dir.exists():
                shutil.rmtree(backup_dir)
            shutil.move(ags_dir, backup_dir)
            self.logger.info(
                'Existing ags configuration backed up to %s', backup_dir
            )

        try:
            self.run_as_user(
                'git clone https://github.com/Jas-SinghFSU/HyprPanel.git '
                f'{ags_dir}',
            )

            custom_options = self.home_dir / '.config/hyprpanel/options.ts'
            if custom_options.exists():
                shutil.copy2(custom_options, ags_dir / 'options.ts')
                self.logger.info('Custom options.ts copied successfully')
            else:
                self.logger.warning(
                    'Custom options.ts not found in %s', custom_options
                )

            self.run_as_user(f'cd {ags_dir} && ./install_fonts.sh')

            if self.command_exists('bun'):
                self.run_as_user('bun install -g sass')
            else:
                self.logger.error('bun is not installed, cannot install sass')

            subprocess.run(
                ['chown', '-R', f'{self.sudo_user}:{self.sudo_user}', ags_dir],
                check=True,
            )

            self.logger.info('HyprPanel setup completed successfully')

        except subprocess.CalledProcessError as e:
            self.logger.error('Failed to setup HyprPanel: %s', e)
            sys.exit(1)

    def install_packages(self) -> None:
        """Установка пакетов из файла."""
        packages_file = Path('packages')
        if not packages_file.exists():
            self.logger.warning('packages file not found')
            return

        try:
            packages = [
                p
                for p in packages_file.read_text().splitlines()
                if p and not p.startswith('#')
            ]

            if not packages:
                self.logger.warning('No packages found in packages file')
                return

            pacman_path = shutil.which('paru')
            if not pacman_path:
                self.logger.error('paru not found')
                sys.exit(1)

            subprocess.run(
                [pacman_path, '-S', '--noconfirm', *packages],
                check=True,
            )
            self.logger.info('All packages installed successfully')
        except subprocess.CalledProcessError as e:
            self.logger.error('Failed to install packages: %s', e)
            sys.exit(1)

    def configure_user_groups(self) -> None:
        """Настройка групп пользователя."""
        self.logger.info('Adding user to groups...')
        groups = [
            'video',
            'audio',
            'input',
            'power',
            'storage',
            'optical',
            'lp',
            'scanner',
            'dbus',
            'adbusers',
            'uucp',
        ]
        try:
            subprocess.run(
                ['usermod', '-a', '-G', ','.join(groups), self.sudo_user],
                check=True,
            )
        except subprocess.CalledProcessError as e:
            self.logger.error('Failed to add user to groups: %s', e)
            sys.exit(1)

    def configure_cursor_theme(self) -> None:
        """Настройка темы курсора."""
        self.logger.info('Configuring cursor theme...')
        theme_content = '[Icon Theme]\nInherits=Bibata-Modern-Ice\n'

        paths = [
            self.home_dir / '.icons/default/index.theme',
            Path('/usr/share/icons/default/index.theme'),
        ]

        for path in paths:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(theme_content)

        subprocess.run(
            [
                'chown',
                '-R',
                f'{self.sudo_user}:{self.sudo_user}',
                self.home_dir / '.icons',
            ],
            check=False,
        )

    def setup_iwd(self) -> None:
        """Настройка IWD."""
        self.logger.info('Configuring IWD...')
        config = Path('/etc/iwd/main.conf')
        config.parent.mkdir(parents=True, exist_ok=True)
        config.write_text(
            '[General]\n'
            'EnableNetworkConfiguration=True\n\n'
            '[Network]\n'
            'RoutePriorityOffset=300\n',
        )

        subprocess.run(
            ['systemctl', 'enable', 'systemd-resolved.service'],
            check=True,
        )

    def setup(self) -> None:
        """Основная функция настройки системы."""
        self.check_system_requirements()

        try:
            # Install base dependencies
            pacman_path = shutil.which('pacman')
            if not pacman_path:
                self.logger.error('pacman not found')
                sys.exit(1)

            subprocess.run(
                [pacman_path, '-Syu', '--noconfirm', 'base-devel'],
                check=True,
            )

            # Install core tools
            self.install_rust()
            self.install_aur_helper(
                'paru',
                'git clone https://aur.archlinux.org/paru.git && '
                'cd paru && makepkg -si --noconfirm',
            )

            # Install and configure everything
            self.install_packages()
            npm_path = shutil.which('npm')
            if npm_path:
                subprocess.run(
                    [npm_path, 'install', '-g', 'repomix'],
                    check=True,
                )

            self.configure_user_groups()
            self.configure_cursor_theme()
            self.setup_iwd()

            # Print summary
            self.logger.info('\n=== Setup Summary ===')
            summary_items = [
                'System updated',
                'Required tools installed',
                'User groups configured',
                'Cursor theme set',
                'IWD configured',
            ]
            for item in summary_items:
                self.logger.info('• %s', item)

        except subprocess.CalledProcessError as e:
            self.logger.error('Setup failed: %s', e)
            sys.exit(1)


def main() -> None:
    """Точка входа в программу."""
    setup_logging()
    setup = SystemSetup.create()
    setup.setup()


if __name__ == '__main__':
    main()
