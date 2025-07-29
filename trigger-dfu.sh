#!/bin/bash

echo "Connecting to nRF52840 console to trigger DFU mode..."

# Find the correct ttyACM device
for device in /dev/ttyACM*; do
    if [ -c "$device" ]; then
        echo "Trying device: $device"
        
        # Try to send DFU command
        {
            echo "dfu"
            sleep 1
        } | timeout 3 socat - "$device,raw,echo=0,crnl" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "✓ DFU command sent successfully"
            sleep 2
            break
        fi
    fi
done

echo "Checking if device entered DFU mode..."
if lsusb | grep -q "1915:cafe"; then
    echo "✅ Device in DFU mode!"
else
    echo "❌ Device not in DFU mode. Try manual method:"
    echo "  1. Double-tap the RESET button quickly"
    echo "  2. Or hold RESET while connecting USB"
fi
