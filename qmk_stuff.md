## How to flash Ferris Sweep

Go to website and generate keymap, download .json keymap
Run `qmk json2c -o keymap.c keymap.json` then `qmk compile` in directory of configured keymap.
For flashing the two halves with Elite-C, run `qmk flash -bl dfu`.
