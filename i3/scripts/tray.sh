#!/bin/bash

pkill -f optimus-manager-qt

# Set this to the correct display
# xrandr --output <eDP-1-1> --primary

optimus-manager-qt &