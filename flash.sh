#!/bin/bash
lsblk | grep -i xiao || echo "XIAO bootloader not detected. Please double-press the reset button."
echo -e "Hope you double click the rst button before running this script!\n"
cp build/blinky/zephyr/zephyr.uf2 /media/apcave/XIAO-SENSE/.