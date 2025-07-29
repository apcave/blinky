#!/bin/bash

echo "Starting RTT console for nRF52840..."

# Create OpenOCD RTT configuration
cat > rtt-console.cfg << 'EOF'
source [find interface/cmsis-dap.cfg]
set WORKAREASIZE 0x40000
set CHIPNAME nrf52
source [find target/nrf52.cfg]

init

# Connect to target without resetting
halt

# Setup RTT
rtt setup 0x20000000 0x40000 "SEGGER RTT"
rtt start

# Resume target
resume

echo "RTT console ready. Starting RTT server on port 9090..."
rtt server start 9090 0
EOF

echo "Starting OpenOCD with RTT server..."
echo "Connect with: telnet localhost 9090"
echo "Press Ctrl+C to stop"

openocd -f rtt-console.cfg
