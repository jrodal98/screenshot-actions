# screenshot-actions

![screenshot-tool](https://user-images.githubusercontent.com/35352333/82405961-50555280-9a33-11ea-8240-b690555afc85.gif)

Dunst actions for screenshots. Current actions include:

1) **clipboard mode**: works with screenshots that were saved to the clipboard
    * Extract text from screenshot using **ocr**
    * **Save** screenshot stored in clipboard to an image file
    * **Upload** screenshot to 0x0.st
2) **file mode**: works with screenshots that were saved to a file
    * **Delete** screenshot
    * **Rename** screenshot
    * **Copy** screenshot to clipboard
    * **Move** screenshot to clipboard (deletes file)
    * **Upload** screenshot to 0x0.st

Currently supports scrot, maim, and flameshot. New screenshot tools can be added easily (see `screenshot.sh` configuration section).

The tool is simple to install, configure, and use. See the instructions below. Examples are also at the bottom of this document.

## Requirements

* dunst (notification daemon)
* dmenu (for selecting dunst actions)
* xclip (for managing clipboard)
* zenity (for saving/renaming files)
* tesseract (for OCR)
* tesseract-data-* (for OCR)
* scrot, maim, or flameshot. Submit an issue request for support for other screenshot tools

## Installation/Setup instructions

Installation instructions for an arch based distribution are provided under the assumption that most people using dunst are using an arch based distribution. Installation instructions should be similar for other distributions as well.

### Install required packages

`sudo pacman -Syu dunst dmenu zenity xclip tesseract tesseract-data-eng`

The above command assumes you which to use english OCR data. If you wish to have a different language, please refer to the aur page for tesseract.

### Install screenshot-actions

Clone the repository and run `./install.sh`.

**Run `./install.sh` anytime you modify any of the files!**

```bash
git clone https://github.com/jrodal98/screenshot-actions.git
cd screenshot-actions
./install.sh
```

**NOTE:** Icons and Flameshot aren't supported without configuration. Fear not, configuring the script is very simple.

**Make sure you set `SCREENSHOT_DIR` at the top of the `variables.sh` file or else your files won't end up where you want them!**

### Configuring screenshot-actions

There are two files that the average user should be aware of: `variables.sh` and `screenshot.sh`. `variables.sh` contains some variables that the other scripts need to be aware of, such as the path to the directory you wish to save screenshots in. `screenshot.sh` is an optional controller that takes screenshots and then calls the `screenshot_actions.sh` script, which sends the dunst notifications and does different actions. If you wish to change the screenshot options that `scrot`, `maim`, or `flameshot` do, or if you wish to add another screenshot tool, it should be added to `screenshot.sh`.

Flameshot requires a bit of additional configuration, which I will describe below.

#### `variables.sh`

The icons and camera shutter variables are optional

```bash
# required
SCREENSHOT_DIR="path to screenshot directory"
ACTIONS_PATH="path to the screenshot_actions.sh file (this variable shouldn't have to be changed)"
OCR_LANG="OCR language code (eng for english)"

# Optional

ERROR_ICON="Path to icon displayed when an error occurs"
CAMERA_ICON="Path to icon displayed when a normal operation occurs"
OCR_ICON="Path to icon displayed when OCR is invoked"
CAMERA_SHUTTER="Path to sound file played when a screenshot is taken"
```

#### `screenshot.sh`

When adding your own screenshot methods, you should do the following:

1) put the name of the tool in the outermost case statement
2) put your desired alias for your screenshot method in an inner case statement
3) call `$ACTIONS_PATH PATH_TO_FILE` or `$ACTIONS_PATH CLIPBOARD`, depending on whether the screenshot was saved to a file or to the clipboard.

I posted the default configuration for `maim`, as it showcases this philosophy the best. `scrot` allows you to execute a script after taking a screenshot, so I used that instead of following the algorithm above. Flameshot isn't very unix like and thus the solution is hacky and doesn't follow the algorithm above either.


```bash
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
```

#### A note on Flameshot

Flameshot is a bit trickier to use than scrot or maim. To use flameshot, make sure that flameshot notifications are turned on. You can modify this using `flameshot config` in your terminal and making sure "show desktop notifications" is selected. Then, add the following code to the bottom of your `dunstrc` file:

```
[change_flameshot]
    appname = flameshot
    format = ""
    script = ~/.config/dunst/screenshot.sh
```

## Examples


General usage: `./screenshot.sh SCREENSHOT_PROGRAM SCREENSHOT_TYPE`

Once your dunst notification appears, trigger the dunst context menu to access the actions provided by my program. Navigate the actions using dmenu. If you are unfamiliar with either of these concepts, please refer to their documentation.

You can see what keybinding triggers your context menu by looking at `context` variable in the `shortcuts` section of your `dunstrc` configuration.

### Scrot

* Take a screenshot of the full display and save it to a file: `./screenshot.sh scrot fullToFile`
* Take a screenshot of the full display and copy it to the clipboard: `./screenshot.sh scrot fullToClip`
* Take a screenshot using selection tool and save it to a file: `./screenshot.sh scrot selectToFile`
* Take a screenshot using selection tool and copy it to the clipboard: `./screenshot.sh scrot selectToClip`
* Take a screenshot of active window and save it to a file: `./screenshot.sh scrot windowToFile`
* Take a screenshot of active window and copy it to the clipboard: `./screenshot.sh scrot windowToClip`

### Maim

* Take a screenshot of the full display and save it to a file: `./screenshot.sh maim fullToFile`
* Take a screenshot of the full display and copy it to the clipboard: `./screenshot.sh maim fullToClip`
* Take a screenshot using selection tool and save it to a file: `./screenshot.sh maim selectToFile`
* Take a screenshot using selection tool and copy it to the clipboard: `./screenshot.sh maim selectToClip`
* Take a screenshot of active window and save it to a file: `./screenshot.sh maim windowToFile`
* Take a screenshot of active window and copy it to the clipboard: `./screenshot.sh maim windowToClip`

### Flameshot

* Take a screenshot of the full display and save it to a file: `./screenshot.sh flameshot full`
* Open the flameshot gui tool: `./screenshot.sh flameshot select`

## Contributing

I will accept pull requests on this repository for adding different screenshot tools to `screenshot.sh`, adding new actions to `screenshot_actions.sh`, reasonable refactoring of preexisting code, etc. Feel free to submit an issue request if there's a specific action you'd like to see. No guarantees, but if it sounds cool and sounds like something I'm capable of implementing, I might implement it.

