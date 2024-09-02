import os
from urllib.request import urlopen

config.load_autoconfig()

if not os.path.exists(config.configdir / 'theme.py'):
    theme = (
        'https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py'
    )
    with urlopen(theme) as themehtml:
        with open(config.configdir / 'theme.py', 'a') as file:
            file.writelines(themehtml.read().decode('utf-8'))

if os.path.exists(config.configdir / 'theme.py'):
    import theme

    theme.setup(c, 'mocha', True)
# Настройка прокси
c.content.proxy = 'http://127.0.0.1:1081'
c.qt.args = ['enable-features=UseOzonePlatform', 'ozone-platform-hint=auto']

# Хоткеи для сессий
config.bind('<Ctrl-Shift-s>', 'session-save')
config.bind('<Ctrl-Shift-o>', 'session-load')

# Быстрые команды для сохранения и загрузки нескольких сессий
config.bind(',s1', 'session-save session1')
config.bind(',s2', 'session-save session2')
config.bind(',s3', 'session-save session3')
config.bind(',l1', 'session-load session1')
config.bind(',l2', 'session-load session2')
config.bind(',l3', 'session-load session3')

# Функция для "закрепления" вкладки (перемещение в начало)
config.bind('<Ctrl-Shift-p>', 'tab-give')

# Быстрый перевод выделенного текста в визуальном режиме
config.bind(
    'T',
    'open -t https://translate.google.com/?sl=auto&tl=ru&text={primary}',
    mode='v',
)

# Перевод всей страницы
config.bind(
    'zp', 'open -t https://translate.google.com/translate?sl=auto&tl=ru&u={url}'
)

# Настройки отображения вкладок
c.tabs.show = 'always'
c.tabs.position = 'top'
c.tabs.new_position.unrelated = 'next'

# Настройка стартовой страницы
c.url.default_page = 'https://www.google.com/'
c.url.start_pages = ['https://www.google.com/']

# Настройка поисковых систем (Google по умолчанию)
c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?q={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
}

# Включение JavaScript и блокировки рекламы
c.content.javascript.enabled = True
c.content.blocking.enabled = True

# Настройка шрифтов
c.fonts.default_family = '"Product Sans"'
c.fonts.default_size = '13pt'

# Предпочтительная цветовая схема
c.colors.webpage.preferred_color_scheme = 'dark'

# Дополнительные настройки для улучшения работы с клавиатурой
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('H', 'back')
config.bind('L', 'forward')
