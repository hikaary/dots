#!/bin/sh

kanshi & 

sudo modprobe uinput &
sudo kbct  remap --config /home/hikary/.config/kbct.yaml & 