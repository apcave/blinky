#!/bin/zsh
# Zephyr and West environment setup script
# Source this file to set up your development environment

# Set up Nordic/Zephyr environment
export ZEPHYR_BASE="/home/apcave/nordic/zephyr"
export ZEPHYR_SDK_INSTALL_DIR="/home/apcave/stm32-tools"

# Add West virtual environment to PATH
export PATH="/home/apcave/nordic/.venv/bin:$PATH"

# Source the Zephyr environment if it exists
if [ -f "$ZEPHYR_BASE/zephyr-env.sh" ]; then
    source "$ZEPHYR_BASE/zephyr-env.sh"
fi

# Activate the Python virtual environment
if [ -f "/home/apcave/nordic/.venv/bin/activate" ]; then
    source "/home/apcave/nordic/.venv/bin/activate"
fi

echo "Nordic/Zephyr development environment loaded!"
echo "ZEPHYR_BASE: $ZEPHYR_BASE"
echo "West executable: $(which west)"
echo "Python executable: $(which python)"
