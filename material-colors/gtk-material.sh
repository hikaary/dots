#!/bin/bash

ICON_THEME_DARK='Tela-nord-dark'
ICON_THEME_LIGHT='Tela-nord-light'

gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME_DARK"
