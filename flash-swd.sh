#!/bin/bash
#cp /home/apcave/nordic/blinky/openocd-pico-nrf52.cfg /home/apcave/nordic/zephyr/boards/seeed/xiao_ble/support/

west flash --runner openocd


# # Flash script for nRF52840 using Raspberry Pi Pico probe
# echo "Flashing nRF52840 via SWD using Raspberry Pi Pico probe..."

# # Check if firmware exists
# if [ ! -f "build/blinky/zephyr/zephyr.hex" ]; then
#     echo "Error: Firmware not found. Please build first with 'west build -b xiao_ble'"
#     exit 1
# fi

# # Flash the firmware
# openocd -f openocd-pico-nrf52.cfg -c "
#     init
#     halt
#     nrf5 mass_erase
#     flash write_image erase build/blinky/zephyr/zephyr.hex
#     verify_image build/blinky/zephyr/zephyr.hex
#     reset run
#     exit
# "

# echo "Flashing completed!"


#/home/apcave/nordic/.venv/bin/west build -p auto -b xiao_ble -- -Dmcuboot_DTC_OVERLAY_FILE="/home/apcave/nordic/bootloader/mcuboot/boot/zephyr/boards/xiao_ble.overlay"