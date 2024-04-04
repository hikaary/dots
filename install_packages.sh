#!/bin/bash

echo "Установка yay..."

sudo pacman -S --noconfirm go
# Установка yay
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

echo "Установка пакетов из pacman_packages.txt..."

sudo pacman -S --noconfirm - < pacman_packages.txt

echo "Установка пакетов из yay_packages.txt..."

yay -S --noconfirm - < yay_packages.txt
