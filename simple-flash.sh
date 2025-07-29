#!/bin/bash

echo "Flashing nRF52840 with mass erase..."

# Create a simple flash script
cat > simple-flash.cfg << 'EOF'
source [find interface/cmsis-dap.cfg]
set WORKAREASIZE 0x40000
set CHIPNAME nrf52
source [find target/nrf52.cfg]

init
reset init

# Mass erase first
nrf5 mass_erase

# Flash the firmware
flash write_image erase build/blinky/zephyr/zephyr.hex

# Verify
verify_image build/blinky/zephyr/zephyr.hex

# Reset and run
reset run

exit
EOF

openocd -f simple-flash.cfg
