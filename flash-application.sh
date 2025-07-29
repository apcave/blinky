#!/bin/bash

# Flash script for nRF52840 application using Raspberry Pi Pico probe
echo "Flashing nRF52840 application via SWD using Raspberry Pi Pico probe..."

# Check if application firmware exists
if [ ! -f "build/blinky/zephyr/zephyr.hex" ]; then
    echo "Error: Application firmware not found. Please build the project first."
    exit 1
fi

# Flash the application firmware
openocd -f openocd-pico-nrf52.cfg -c "
    init
    halt
    nrf5 mass_erase
    flash write_image erase build/blinky/zephyr/zephyr.hex
    verify_image build/blinky/zephyr/zephyr.hex
    reset run
    exit
"

echo "Application flashing completed!"
