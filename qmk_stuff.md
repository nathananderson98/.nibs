## How to flash Ferris Sweep
Run this to install qmk cli tool
`sudo pacman -S qmk`

To copy over udev rules:
`sudo cp /home/nathana/qmk_firmware/util/udev/50-qmk.rules /etc/udev/rules.d/`

Go to website and generate keymap, download .json keymap
Run `qmk json2c -o keymap.c keymap.json` then `qmk compile` in directory of configured keymap.
For flashing the two halves with Elite-C, run `qmk flash -bl dfu`.

  SES_FROM_ADDRESS: Neighbor <support@neiybor.com>
  SES_REPLY_TO_ADDRESS: Neighbor <r@inbox.neiybor.com>
