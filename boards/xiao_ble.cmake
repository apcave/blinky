# Board configuration for xiao_ble with Raspberry Pi Pico probe

set(BOARD_FLASH_RUNNER openocd)
set(BOARD_DEBUG_RUNNER openocd)

board_runner_args(openocd "--config=${APPLICATION_SOURCE_DIR}/openocd-pico-nrf52.cfg")
