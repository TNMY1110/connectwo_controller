#!/bin/bash

BINARY=build/motor_controller.bin

if [ ! -f "$BINARY" ]; then
    echo "Error: $BINARY not found!"
    exit 1
fi

echo "=== Flashing with OpenOCD (ST-Link) ==="
openocd -f interface/stlink.cfg \
        -f target/stm32f4x.cfg \
        -c "init" \
        -c "reset halt" \
        -c "flash write_image erase $BINARY 0x08000000" \
        -c "verify_image $BINARY 0x08000000" \
        -c "reset halt" \
        -c "mww 0xE000EDF0 0xA05F0003" \
        -c "shutdown"

if [ $? -eq 0 ]; then
    echo ""
    echo "=== Flash Complete! ==="
    echo ""
    echo "Now run: st-info --probe"
    echo "Then start Agent"
else
    echo ""
    echo "=== Flash Failed! ==="
    exit 1
fi
