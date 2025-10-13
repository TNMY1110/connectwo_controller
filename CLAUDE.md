# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the connectwo-controller repository for the Tresc3 mobile robot base controller. It's an embedded STM32F446RE microcontroller project that controls a 4-motor robot with various communication interfaces.

## Hardware Platform

- **MCU**: STM32F446RE (ARM Cortex-M4 with FPU)
- **Toolchain**: STM32CubeIDE + ARM GCC cross-compiler
- **Communication**: USB_OTG_FS, UART (2x), CAN, I2C, USB to TTL
- **Motor Control**: 4 motors with PWM, direction control, and encoder feedback
- **Other**: 4 ADC channels, MAX232 level shifter

## Build System

### CMake Build Commands

The project uses CMake for building. Main build directory is `stm32cubeide/motor_controller/`.

```bash
# Navigate to project directory
cd stm32cubeide/motor_controller

# Clean and build
rm -rf build
mkdir build
cd build
cmake ..
make

# Flash to device
make flash

# Open serial monitor
make monitor
```

### Build Script

Use the provided build script for setup:
```bash
./CMakelist.sh
```

### Build Outputs

- `motor_controller.elf` - Main executable
- `motor_controller.hex` - Intel HEX format for flashing
- `motor_controller.bin` - Binary format for st-flash

## Code Architecture

### Main Project Structure

- `stm32cubeide/motor_controller/` - Main STM32 project
  - `Src/` - Source files (HAL-generated + user code)
  - `Inc/` - Header files
  - `Startup/` - Boot code and linker scripts
  - `Drivers/` - STM32 HAL drivers
- `stm32cubeide/MC_lib/` - Motor control and ROS integration library
  - `main/ros/` - ROS communication layer
  - `lib/` - Motor control algorithms and peripherals
  - `ROS/` - ROS message definitions and protocols

### Key Components

1. **HAL Layer**: STM32 Hardware Abstraction Layer for peripherals (ADC, CAN, I2C, TIM, USART, USB_OTG, GPIO, DMA)
2. **Motor Control**: PID controllers and motor driver interfaces in MC_lib
3. **Communication**: ROS integration for robot communication (main entry point: `ros_main.h`)
4. **Configuration**: Hardware configuration via STM32CubeMX (`.ioc` file)

### Code Generation

The project uses STM32CubeMX for hardware configuration. The `.ioc` file contains the peripheral setup. When modifying hardware configuration:

1. Open `motor_controller.ioc` in STM32CubeMX
2. Make changes and regenerate code
3. User code is preserved in `/* USER CODE BEGIN */` and `/* USER CODE END */` blocks

## Development Workflow

### Prerequisites

- ARM GCC toolchain (`arm-none-eabi-gcc`)
- CMake 3.22+
- st-flash (for flashing)
- STM32CubeMX (for hardware configuration)

### Flashing and Debugging

- **Flash**: `make flash` or `st-flash write motor_controller.bin 0x8000000`
- **Serial Monitor**: `make monitor` or `screen /dev/ttyUSB0 115200`
- **Debugging**: Use STM32CubeIDE or GDB with ST-Link

### Key Files to Understand

- `stm32cubeide/motor_controller/Src/main.c:33` - ROS integration entry point
- `stm32cubeide/motor_controller/CMakeLists.txt` - Build configuration
- `stm32cubeide/motor_controller/motor_controller.ioc` - Hardware configuration
- `stm32cubeide/MC_lib/main/ros/` - ROS communication layer