#!/bin/bash

# Alternative RTT Console using JLinkRTTClient
echo "Starting JLink RTT Console for nRF52840..."
echo "This will show log output from your Zephyr application"
echo "Press Ctrl+C to exit"
echo ""

# Start OpenOCD in background (for SWD connection)
echo "Starting OpenOCD for SWD connection..."
openocd -f openocd-pico-nrf52.cfg &
OPENOCD_PID=$!

# Wait for OpenOCD to establish connection
sleep 3

echo "Starting JLinkRTTClient..."
echo "----------------------------------------"

# Use JLinkRTTClient to connect
JLinkRTTClient

# Cleanup
echo ""
echo "Stopping OpenOCD..."
kill $OPENOCD_PID 2>/dev/null
wait $OPENOCD_PID 2>/dev/null
echo "RTT Console stopped."
