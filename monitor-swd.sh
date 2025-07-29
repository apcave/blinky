#!/bin/bash

# Monitor script for nRF52840 using Raspberry Pi Pico probe
echo "Starting debug monitor for nRF52840..."
echo "Press Ctrl+C to exit"

# Start OpenOCD in background and connect with telnet for monitoring
openocd -f openocd-pico-nrf52.cfg &
OPENOCD_PID=$!

# Wait a moment for OpenOCD to start
sleep 2

echo "OpenOCD started. You can now:"
echo "1. Connect with telnet: telnet localhost 4444"
echo "2. Use GDB: arm-none-eabi-gdb build/blinky/zephyr/zephyr.elf"
echo "3. In GDB: target remote localhost:3333"

# Keep the script running
wait $OPENOCD_PID
