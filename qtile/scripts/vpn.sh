#!/bin/bash
arg=$1
command="sudo systemctl ${arg} sing-box"
eval ${command}
