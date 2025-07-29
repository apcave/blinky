#!/bin/bash
echo "=== nRF52840 USB Console Connection ==="
echo ""
sudo screen /dev/ttyACM1 115200



# # Find available USB serial devices
# devices=$(ls /dev/ttyACM* 2>/dev/null)
# if [ -z "$devices" ]; then
#     echo "❌ No USB serial devices found"
#     echo "Make sure your nRF52840 is connected via USB"
#     exit 1
# fi

# echo "Available USB serial devices:"
# for device in $devices; do
#     echo "  $device"
# done

# # Try to connect to the first available device
# device=$(echo $devices | cut -d' ' -f1)
# echo ""
# echo "Connecting to $device..."
# echo "Type 'dfu' and press Enter to enter DFU mode"
# echo "Press Ctrl+A then K to exit screen"
# echo ""

# # Give user a moment to read
# sleep 2

# # Connect using screen
# sudo screen $device 115200
