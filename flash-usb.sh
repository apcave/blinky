#!/bin/bash

echo "=== nRF52840 USB Flash Script ==="

# Check if device is in DFU mode
check_dfu_device() {
    if lsusb | grep -q "1915:cafe"; then
        echo "✓ nRF52840 in DFU mode detected"
        return 0
    else
        echo "✗ nRF52840 DFU mode not detected"
        return 1
    fi
}

# Check if device is running normal firmware
check_normal_device() {
    if lsusb | grep -q "2fe3:0100"; then
        echo "✓ nRF52840 device detected (normal mode)"
        return 0
    else
        echo "✗ nRF52840 device not detected in normal mode"
        return 1
    fi
}

# Build the firmware
echo "Building firmware..."
/home/apcave/nordic/.venv/bin/west build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✓ Build successful"

# Check current device state
echo ""
echo "Checking device state..."

if check_dfu_device; then
    echo "Device already in DFU mode, proceeding with flash..."
elif check_normal_device; then
    echo "Device in normal mode. You have two options:"
    echo ""
    echo "Option 1: Use shell command (if device is responsive):"
    echo "  - Connect to device console and run: dfu"
    echo ""
    echo "Option 2: Manual DFU mode:"
    echo "  - Hold BOOT button and press RESET button"
    echo "  - Or double-tap RESET button quickly"
    echo ""
    echo "Waiting for device to enter DFU mode..."
    
    # Wait for DFU mode
    timeout=30
    while [ $timeout -gt 0 ]; do
        if check_dfu_device; then
            break
        fi
        echo -n "."
        sleep 1
        ((timeout--))
    done
    
    if [ $timeout -eq 0 ]; then
        echo ""
        echo "❌ Timeout waiting for DFU mode"
        echo "Please manually put device in DFU mode and run this script again"
        exit 1
    fi
else
    echo "❌ No nRF52840 device detected"
    echo "Please connect the device and try again"
    exit 1
fi

echo ""
echo "Flashing firmware via USB DFU..."

# Flash using nrfutil
if command -v /home/apcave/nordic/.venv/bin/nrfutil &> /dev/null; then
    echo "Using nrfutil for DFU flashing..."
    /home/apcave/nordic/.venv/bin/nrfutil device program --firmware build/blinky/zephyr/zephyr.hex --traits nordicDfu
elif command -v dfu-util &> /dev/null; then
    echo "Using dfu-util for DFU flashing..."
    dfu-util -d 1915:cafe -a 0 -s 0x0000:leave -D build/blinky/zephyr/zephyr.bin
else
    echo "❌ Neither nrfutil nor dfu-util found!"
    echo "Please install one of these tools:"
    echo "  - nrfutil: pip install nrfutil"
    echo "  - dfu-util: sudo apt install dfu-util"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✅ Flash successful!"
    echo ""
    echo "Device should restart automatically."
    echo "Check lsusb to see if it appears as '2fe3:0100 NordicSemiconductor Zephyr Blinky'"
else
    echo "❌ Flash failed!"
    exit 1
fi
