#!/usr/bin/env python3
"""
Client script to receive streamed data from nRF52840
Supports both USB CDC and Bluetooth LE connections
"""

import sys
import time
import argparse

def usb_client(device_path="/dev/ttyACM0", baudrate=115200):
    """Connect via USB CDC and receive data"""
    try:
        import serial
    except ImportError:
        print("Please install pyserial: pip install pyserial")
        return
    
    try:
        ser = serial.Serial(device_path, baudrate, timeout=1)
        print(f"Connected to {device_path} at {baudrate} baud")
        print("Listening for data... Press Ctrl+C to exit")
        
        while True:
            data = ser.read(64)  # Read up to 64 bytes
            if data:
                print(f"Received {len(data)} bytes: {data.hex()}")
                # Try to decode as text if possible
                try:
                    text = data.decode('utf-8', errors='ignore')
                    if text.strip():
                        print(f"As text: {text.strip()}")
                except:
                    pass
            time.sleep(0.1)
            
    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except KeyboardInterrupt:
        print("\nDisconnected")
    finally:
        if 'ser' in locals():
            ser.close()

def ble_client():
    """Connect via Bluetooth LE and receive data"""
    try:
        import asyncio
        from bleak import BleakScanner, BleakClient
    except ImportError:
        print("Please install bleak: pip install bleak")
        return
    
    # Service and characteristic UUIDs (matching the nRF52840 code)
    SERVICE_UUID = "12345678-1234-1234-1234-123456789abc"
    DATA_CHAR_UUID = "12345678-1234-1234-1234-123456789abd"
    
    async def notification_handler(sender, data):
        print(f"Received {len(data)} bytes via BLE: {data.hex()}")
        try:
            text = data.decode('utf-8', errors='ignore')
            if text.strip():
                print(f"As text: {text.strip()}")
        except:
            pass
    
    async def run_ble_client():
        print("Scanning for Zephyr Data Streamer...")
        devices = await BleakScanner.discover(timeout=10.0)
        
        target_device = None
        for device in devices:
            if device.name and "Zephyr Data Streamer" in device.name:
                target_device = device
                break
        
        if not target_device:
            print("Device not found. Make sure the nRF52840 is advertising.")
            return
        
        print(f"Connecting to {target_device.name} ({target_device.address})")
        
        async with BleakClient(target_device.address) as client:
            print("Connected!")
            
            # Subscribe to notifications
            await client.start_notify(DATA_CHAR_UUID, notification_handler)
            print("Listening for data... Press Ctrl+C to exit")
            
            try:
                while True:
                    await asyncio.sleep(1)
            except KeyboardInterrupt:
                print("\nDisconnecting...")
                await client.stop_notify(DATA_CHAR_UUID)
    
    asyncio.run(run_ble_client())

def main():
    parser = argparse.ArgumentParser(description="nRF52840 Data Stream Client")
    parser.add_argument("--method", choices=["usb", "ble"], default="usb",
                       help="Connection method (default: usb)")
    parser.add_argument("--device", default="/dev/ttyACM0",
                       help="USB device path (default: /dev/ttyACM0)")
    parser.add_argument("--baudrate", type=int, default=115200,
                       help="USB baudrate (default: 115200)")
    
    args = parser.parse_args()
    
    print("nRF52840 Data Stream Client")
    print("=" * 40)
    
    if args.method == "usb":
        print("Using USB CDC connection")
        usb_client(args.device, args.baudrate)
    elif args.method == "ble":
        print("Using Bluetooth LE connection")
        ble_client()

if __name__ == "__main__":
    main()
