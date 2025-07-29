#!/bin/bash

# RTT Console script for nRF52840 using Raspberry Pi Pico probe
echo "Starting RTT Console for nRF52840..."
echo "This will show log output from your Zephyr application"
echo "Press Ctrl+C to exit"
echo ""

# Start OpenOCD with RTT support in background
echo "Starting OpenOCD..."
openocd -f openocd-pico-nrf52.cfg -c "init; setup_rtt" &
OPENOCD_PID=$!

# Wait for OpenOCD to start
sleep 3

echo "OpenOCD started with RTT support"
echo "RTT server is running on port 9090"
echo ""
echo "You can now connect to RTT in multiple ways:"
echo "1. Using telnet: telnet localhost 9090"
echo "2. Using JLinkRTTClient (if available)"
echo "3. Using netcat: nc localhost 9090"
echo ""
echo "Starting telnet connection to RTT..."
echo "----------------------------------------"

# Connect to RTT via telnet
telnet localhost 9090

# Cleanup
echo ""
echo "Stopping OpenOCD..."
kill $OPENOCD_PID 2>/dev/null
wait $OPENOCD_PID 2>/dev/null
echo "RTT Console stopped."
