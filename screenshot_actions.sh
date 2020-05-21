#!/usr/bin/env bash
# www.jrodal.dev

source $HOME/.config/dunst/variables.sh

function rename() {
    FILENAME=$(zenity --file-selection --file-filter=*.png --confirm-overwrite --title="Save screenshot as..." --save --filename="$1")
    case $? in
        0 )
            mv $1 $FILENAME
            ;;
    esac
}
function saveas() {
    FILENAME=$(zenity --file-selection --file-filter=*.png --confirm-overwrite --title="Save screenshot as..." --save --filename="$SCREENSHOT_DIR/$(date +%s).png")
    case $? in
        0 )
            xclip -o -selection clipboard -t image/png > $FILENAME
            ;;
    esac
}
function delete() {
    case $(echo -e "yes\nno" | dmenu -p "Are you sure you want to delete the screenshot?") in
        yes )
            rm $1
            dunstify -i $CAMERA_ICON "Screenshot has been deleted"
            ;;
    esac
}

function ocr() {
    xclip -o -selection clipboard -t image/png | tesseract -l $OCR_LANG stdin stdout | xclip -sel clip
    dunstify -i $OCR_ICON "Text copied to clipboard"

}

function to_clip() {
    xclip -sel clip -t image/png $1
    case $2 in
        moved )
            rm $1
            ;;
        *)
            ;;
    esac
    dunstify -i $CAMERA_ICON "Image $2 to clipboard"
}

function upload_0x0() {
    case $1 in
        clipboard )
            FILENAME=/tmp/screenshot-actions.png
            xclip -o -selection clipboard -t image/png > $FILENAME
            ;;
        *)
            FILENAME=$1
            ;;
    esac
    URL=$(curl -F"file=@$FILENAME" http://0x0.st)
    dunstify -i $CAMERA_ICON "Image uploaded to $URL"
}


case $1 in
    clipboard)
        ACTION=$(play_sound & dunstify -A "saveas,save as" -A "ocr,ocr" -A "upTo0x0,upload to 0x0.st" -i $HOME/.local/share/icons/dunst_icons/icons8-camera-100.png "Screenshot" "Screenshot saved to clipboard")
        ;;
    *)
        ACTION=$(play_sound & dunstify -A "rename,rename" -A "delete,delete" -A "mvToClip,move to clipboard" -A "cpToClip,copy to clipboard" -A "upTo0x0,upload to 0x0.st" -i $HOME/.local/share/icons/dunst_icons/icons8-camera-100.png "Screenshot" "Screenshot saved to $1")
        ;;
esac

case "$ACTION" in
    "rename")
        rename $1
        ;;
    "saveas")
        saveas
        ;;
    "delete")
        delete $1
        ;;
    "ocr")
        ocr
        ;;
    "cpToClip")
        to_clip $1 copied
        ;;
    "mvToClip")
        to_clip $1 moved
        ;;
    "upTo0x0")
        upload_0x0 $1
        ;;
    esac

