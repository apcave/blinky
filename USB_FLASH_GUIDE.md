# USB Flashing Guide for nRF52840

This guide explains how to flash your nRF52840 via USB instead of using the SWD probe.

## Quick Start

### Option 1: Using VS Code Tasks (Recommended)
1. Open VS Code with the blinky project
2. Press `Ctrl+Shift+P` → "Tasks: Run Task"
3. Choose "Flash via USB DFU"
4. Follow the on-screen instructions

### Option 2: Using Shell Scripts
```bash
# Connect to USB console and send DFU command
./usb-console.sh
# In the console, type: dfu

# Or try automatic DFU trigger
./trigger-dfu.sh

# Then flash via USB
./flash-usb.sh
```

## Detailed Steps

### Step 1: Put Device in DFU Mode

#### Method A: Software Command (if device is responsive)
1. Run: `./usb-console.sh` 
2. In the console, type: `dfu` and press Enter
3. Device will reboot into DFU mode

#### Method B: Hardware Reset (XIAO nRF52840 Sense)
1. **Double-tap the RESET button quickly** (< 0.5 seconds between taps)
2. LED should change indicating DFU mode
3. Verify with: `lsusb | grep 1915:cafe`

#### Method C: Power-on DFU Mode
1. Disconnect USB cable
2. Hold RESET button while reconnecting USB
3. Release RESET button after 1 second

### Step 2: Verify DFU Mode
```bash
lsusb | grep 1915:cafe
```
You should see: `Bus XXX Device XXX: ID 1915:cafe`

### Step 3: Flash Firmware
```bash
./flash-usb.sh
```

## Device States

### Normal Mode (Running Firmware)
- USB ID: `2fe3:0100 NordicSemiconductor Zephyr Blinky`
- Serial console available at `/dev/ttyACM0` or `/dev/ttyACM1`
- Can receive `dfu` command to enter DFU mode

### DFU Mode (Bootloader)
- USB ID: `1915:cafe`
- Ready for firmware upload
- No serial console available

## VS Code Tasks Available

- **Flash via USB DFU**: Complete build and flash process
- **Connect to USB Console**: Open serial console to device
- **Trigger DFU Mode**: Attempt to trigger DFU via software
- **Build Blinky**: Build firmware only

## Troubleshooting

### Device Not Detected
- Check USB cable connection
- Try different USB port
- Run `lsusb` to see all USB devices

### Cannot Enter DFU Mode
- Try double-tapping RESET button more quickly
- Try holding RESET while connecting USB
- Some XIAO boards require specific timing

### Flash Fails
- Ensure device is in DFU mode (`lsusb | grep 1915:cafe`)
- Try using dfu-util instead of nrfutil
- Check permissions: `sudo usermod -a -G dialout $USER` (logout/login required)

### Permission Denied
```bash
sudo usermod -a -G dialout $USER
# Logout and login again
```

## Tools Used

- **nrfutil**: Nordic's official DFU tool (preferred)
- **dfu-util**: Generic DFU utility (backup)
- **screen**: For serial console connection

## File Structure

```
blinky/
├── flash-usb.sh          # Main USB flashing script
├── usb-console.sh        # Connect to device console
├── trigger-dfu.sh        # Auto-trigger DFU mode
└── .vscode/
    ├── tasks.json        # VS Code build/flash tasks
    └── launch.json       # Debug configurations
```

## Tips

1. **USB vs SWD**: USB flashing is easier but requires the device to be responsive
2. **Shell Commands**: Your firmware includes LED control commands (`led on`, `led off`, `led toggle`)
3. **Console Access**: Use USB console for debugging and sending commands
4. **DFU Recovery**: If device becomes unresponsive, use hardware reset method
