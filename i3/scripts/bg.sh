#!/bin/bash

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs
# --vo=vdpau --hwdec=vdpau \
_screen() {
#     xwinwrap -g "$1" -ov -ni -s -nf -b -un -argb -- gifview --no-interactive --geometry "$1" -w %WID $2 -a &
    xwinwrap -ov -ni -g "$1" -- mpv --fullscreen \
        --no-stop-screensaver \
        --loop-file --no-audio --no-osc --no-osd-bar \
        -wid %WID --no-input-default-bindings "$2" &
    PIDs+=($!)
}

# Loops through bg.pid and kills all running processes of xwinwrap
while read p; do
    [[ $(ps -p "$p" -o comm=) == "xwinwrap" ]] && kill -9 "$p";
done < $PIDFILE

sleep 0.5

# Select a random background from provided directory
BG=$(ls $1 | sort -R | head -1)

# Loops through each display and runs screen on each of them
for i in $( xrandr -q | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+')
do
    # Call screen with screen dims and offset with passed in file
    _screen "$i" "$1/$BG"
done

printf "%s\n" "${PIDs[@]}" > $PIDFILE


ls |sort -R |tail -$N |while read file; do
    # Something involving $file, or you can leave
    # off the while to just get the filenames
done
