#!/usr/bin/env bash
outputDir="$HOME/Videos/Screencasts"

checkRecording() {
	if pgrep -f "gpu-screen-recorder" >/dev/null; then
		return 0
	fi
	return 1
}

startRecording() {
	outputFile="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
	outputPath="$outputDir/$outputFile"
	mkdir -p "$outputDir"

	gpu-screen-recorder \
		-w portal \
		-f 60 \
		-k h264 \
		-a "$(pactl get-default-sink).monitor" \
		-o "$outputPath"

	if ! checkRecording; then
		notify-send "Recording Failed" "Could not start recording" \
			-i video-x-generic \
			-a "Screen Recorder" \
			-u critical
		exit 1
	fi

	notify-send "Recording started" "Recording your screen..." \
		-i video-x-generic \
		-a "Screen Recorder" \
		-t 5000 \
		-u normal
}

stopRecording() {
	pkill -SIGINT -f gpu-screen-recorder
	sleep 2
	recentFile=$(ls -t "$outputDir"/recording_*.mp4 2>/dev/null | head -n 1)

	if [ -f "$recentFile" ]; then
		notify-send "Recording stopped" "Your recording has been saved." \
			-i video-x-generic \
			-a "Screen Recorder" \
			-t 10000 \
			-u normal \
			--action="Open folder=xdg-open $outputDir" \
			--action="Play video=xdg-open $recentFile"
	else
		notify-send "Recording stopped" "No recording file was created" \
			-i video-x-generic \
			-a "Screen Recorder" \
			-t 5000 \
			-u critical
	fi
}

if checkRecording; then
	stopRecording
else
	startRecording
fi
