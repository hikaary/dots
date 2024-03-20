#!/bin/bash

# Загрузка цветов, сгенерированных Pywal
source ~/.cache/wal/colors.sh

# Путь к файлу конфигурации Zellij
ZELLIJ_CONFIG=~/.config/zellij/layout.kdl

# Обновление цветов в конфигурации Zellij
sed -i "s|fg=black,bg=blue|fg=black,bg=$color4|" $ZELLIJ_CONFIG
sed -i "s|fg=blue,bg=#181825|fg=$color4,bg=$background|" $ZELLIJ_CONFIG
sed -i "s|fg=#181825,bg=#b1bbfa|fg=$background,bg=$color7|" $ZELLIJ_CONFIG
sed -i "s|bg=#181825|bg=$background|" $ZELLIJ_CONFIG
sed -i "s|fg=#181825,bg=#4C4C59|fg=$background,bg=$color8|" $ZELLIJ_CONFIG
sed -i "s|fg=#000000,bg=#4C4C59|fg=black,bg=$color8|" $ZELLIJ_CONFIG
sed -i "s|fg=#4C4C59,bg=#181825|fg=$color8,bg=$background|" $ZELLIJ_CONFIG
sed -i "s|fg=#6C7086,bg=#181825|fg=$color2,bg=$background|" $ZELLIJ_CONFIG
sed -i "s|fg=#181825,bg=#ffffff|fg=$background,bg=$foreground|" $ZELLIJ_CONFIG
sed -i "s|fg=#9399B2,bg=#181825|fg=$color14,bg=$background|" $ZELLIJ_CONFIG
sed -i "s|fg=#6C7086,bg=#b1bbfa|fg=$color2,bg=$color7|" $ZELLIJ_CONFIG
