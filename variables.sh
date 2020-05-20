#!/usr/bin/env bash
# www.jrodal.dev

# Some variables you may want to change
# in particular, make sure that SCREENSHOT_DIR is set to the directory that you wish to store screenshots in.

SCREENSHOT_DIR=$HOME/Pictures/
ACTIONS_PATH=$HOME/.config/dunst/screenshot_actions.sh
ERROR_ICON=$HOME/.local/share/icons/dunst_icons/icons8-high-importance-48.png
CAMERA_ICON=$HOME/.local/share/icons/dunst_icons/icons8-camera-100.png
OCR_ICON=$HOME/.local/share/icons/dunst_icons/icons8-general-ocr-48.png
CAMERA_SHUTTER=/usr/share/sounds/freedesktop/stereo/camera-shutter.oga

############################ Some Functions #################################################

function play_sound() {
    paplay $CAMERA_SHUTTER
}

function send_error() {
	notify-send -u critical -i "$ERROR_ICON" "Screenshot Actions Error" "$1"
}
