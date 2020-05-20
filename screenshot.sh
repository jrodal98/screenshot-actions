#!/usr/bin/env bash
# www.jrodal.dev

source $HOME/.config/dunst/variables.sh

case "$1" in
	"scrot")
		case "$2" in
			fullToFile )
                # takes screenshot of full display and moves to SCREENSHOT_DIR
				scrot -e "mv \$f $SCREENSHOT_DIR; $ACTIONS_PATH $SCREENSHOT_DIR/\$f"
				;;
			fullToClip )
                # takes screenshot of full display and saves it to clipboard
				scrot -e "xclip -selection clipboard -t image/png -i \$f; rm \$f; $ACTIONS_PATH clipboard"
				;;
			selectToFile )
                # takes a screenshot using selection tools and moves in to SCREENSHOT_DIR
				scrot -se "mv \$f $SCREENSHOT_DIR; $ACTIONS_PATH $SCREENSHOT_DIR/\$f"
				;;
			selectToClip )
                # takes a screenshot using selection tools and saves it to clipboard
				scrot -se "xclip -selection clipboard -t image/png -i \$f; rm \$f; $ACTIONS_PATH clipboard"
				;;
			windowToFile )
                # takes a screenshot of active window and moves it to SCREENSHOT_DIR
				scrot -ue "mv \$f $SCREENSHOT_DIR; $ACTIONS_PATH $SCREENSHOT_DIR/\$f"
				;;
			windowToClip )
                # takes a screenshot of active window and saves it to clipboard
				scrot -ue "xclip -selection clipboard -t image/png -i \$f; rm \$f; $ACTIONS_PATH clipboard"
				;;
			*)
				send_error "$2 is not a supported action for $1"
				;;
		esac
		;;
	"maim")
		case "$2" in
            fullToFile )
                FILENAME=$SCREENSHOT_DIR/$(date +%s).png
                maim $FILENAME
                $ACTIONS_PATH $FILENAME
                ;;
			fullToClip )
				maim | xclip -selection clipboard -t image/png
                $ACTIONS_PATH clipboard
				;;
            selectToFile )
                FILENAME=$SCREENSHOT_DIR/$(date +%s).png
                maim -s $FILENAME
                $ACTIONS_PATH $FILENAME
                ;;
			selectToClip )
				maim -s | xclip -selection clipboard -t image/png
                $ACTIONS_PATH clipboard
				;;
            windowToFile )
                FILENAME=$SCREENSHOT_DIR/$(date +%s).png
                maim -i $(xdotool getactivewindow) $FILENAME
                $ACTIONS_PATH $FILENAME
                ;;
			windowToClip )
				maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png
                $ACTIONS_PATH clipboard
				;;
			*)
				send_error "$2 is not a supported action for $1"
				;;
		esac
		;;
	"flameshot")
		case "$2" in
			full )
				flameshot full -p $SCREENSHOT_DIR
				;;
			select )
				flameshot gui -p $SCREENSHOT_DIR
				;;
			"Flameshot Info" )
				FILENAME="${3##* }" # gets the last word in the notification body, which is either the file path or clipboard
				$ACTIONS_PATH $FILENAME
				;;
			*)
				send_error "$2 is not a supported action for $1"
				;;
		esac
		;;
	* )
		send_error "$1 is not a supported screenshot tool."
		;;
esac
