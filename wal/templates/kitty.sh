#!/bin/bash

source ~/.cache/wal/colors.sh

KITTY_CONFIG=~/.config/kitty/kitty.conf

sed -i "s/^foreground.*/foreground $foreground/" $KITTY_CONFIG
sed -i "s/^background.*/background $background/" $KITTY_CONFIG
sed -i "s/^selection_foreground.*/selection_foreground $color7/" $KITTY_CONFIG
sed -i "s/^selection_background.*/selection_background $color2/" $KITTY_CONFIG
sed -i "s/^cursor.*/cursor $cursor/" $KITTY_CONFIG
sed -i "s/^active_tab_foreground.*/active_tab_foreground $color4/" $KITTY_CONFIG
sed -i "s/^active_tab_background.*/active_tab_background $color0/" $KITTY_CONFIG
sed -i "s/^inactive_tab_foreground.*/inactive_tab_foreground $color8/" $KITTY_CONFIG
sed -i "s/^inactive_tab_background.*/inactive_tab_background $color0/" $KITTY_CONFIG
sed -i "s/^active_border_color.*/active_border_color $color4/" $KITTY_CONFIG
sed -i "s/^inactive_border_color.*/inactive_border_color $color8/" $KITTY_CONFIG

for i in {0..17}; do
	color_var="color$i"
	eval color_val=\$$color_var
	sed -i "s/^color$i.*/color$i $color_val/" $KITTY_CONFIG
done
