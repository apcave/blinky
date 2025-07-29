# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(blinky)

target_sources(app PRIVATE src/main.c)

# Set the signing key for MCUboot
set(mcuboot_key_file "${CMAKE_CURRENT_SOURCE_DIR}/keys/mcuboot-rsa-key.pem")
set_property(GLOBAL PROPERTY PROPERTY_MCUBOOT_SIGNATURE_KEY_FILE "${mcuboot_key_file}")

# Configure OpenOCD runner for west flash
board_runner_args(openocd "--config=openocd-pico-nrf52.cfg")
