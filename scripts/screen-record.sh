#!/bin/bash

pid_file="/tmp/screenrecord.pid"

if [ -f "$pid_file" ]; then
  pid=$(cat $pid_file)
  rm "$pid_file"
  kill -SIGINT "$pid"
  notify-send "Запись экрана" "Запись остановлена" -a "Screen Recorder"
else
  wf-recorder -f ~/media/screen_$(date +%Y%m%d_%H%M%S).mp4 -c libx264 -r 60 --audio-output &
  echo $! >"$pid_file"
  notify-send "Запись экрана" "Запись начата" -a "Screen Recorder"
fi
