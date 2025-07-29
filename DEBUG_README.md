# VS Code Debug Configuration for nRF52840

This project is configured for debugging the nRF52840 using a Raspberry Pi Pico probe with VS Code.

## Prerequisites

- **Hardware**: nRF52840 (XIAO BLE Sense) connected to Raspberry Pi Pico probe via SWD
- **Extensions**: Cortex-Debug and C/C++ extensions (already installed)
- **Tools**: OpenOCD, ARM GCC toolchain

## Debug Configurations

### 1. Debug nRF52840 (Pico Probe)
- **Type**: Launch configuration
- **Description**: Builds the project, flashes firmware, and starts debugging
- **Entry Point**: Stops at `main()` function
- **Features**: 
  - Automatic build before debugging
  - RTT console output (available on port 9090)
  - Register viewing via SVD file
  - Breakpoint support

### 2. Debug nRF52840 (Attach)
- **Type**: Attach configuration  
- **Description**: Attaches to already running firmware without reflashing
- **Use Case**: When firmware is already flashed and running

## How to Debug

1. **Ensure Hardware Connection**:
   - Connect Raspberry Pi Pico probe to nRF52840 via SWD
   - Connect Pico probe to computer via USB

2. **Start Debugging**:
   - Open the project in VS Code
   - Go to Run and Debug view (Ctrl+Shift+D)
   - Select "Debug nRF52840 (Pico Probe)" configuration
   - Press F5 or click the green play button

3. **Debugging Features**:
   - Set breakpoints by clicking in the gutter
   - Step through code with F10 (step over) or F11 (step into)
   - View variables in the Variables panel
   - Watch expressions in the Watch panel
   - View CPU registers in the Cortex-Debug: Registers panel

## RTT Console

During debugging, RTT console output is available:
- **Manual connection**: `telnet localhost 9090`
- **Alternative**: Use the "Start RTT Console" task

## Tasks Available

- **Build Blinky**: Builds the project (`Ctrl+Shift+P` → Tasks: Run Task → Build Blinky)
- **Clean Build**: Cleans and rebuilds the project
- **Flash via SWD**: Builds and flashes firmware via SWD
- **Start RTT Console**: Starts RTT console server

## Troubleshooting

1. **"No device found"**: 
   - Check USB connection to Pico probe
   - Verify SWD wiring to nRF52840

2. **Build errors**:
   - Run "Clean Build" task
   - Check that all dependencies are installed

3. **Debug session won't start**:
   - Make sure no other OpenOCD instances are running
   - Try the "Flash via SWD" task first

4. **RTT console not working**:
   - Ensure firmware is built with RTT enabled (already configured)
   - Try restarting the debug session

## File Structure

```
.vscode/
├── launch.json          # Debug configurations
├── tasks.json           # Build and utility tasks
├── settings.json        # VS Code settings for C/C++
├── openocd-debug.cfg    # OpenOCD configuration for debugging
└── nrf52840.svd         # SVD file for register viewing
```
