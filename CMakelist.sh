#!/bin/bash

# motor_controller CMake 프로젝트 설정 스크립트

set -e  # 오류 시 스크립트 중단

echo "🚀 motor_controller CMake 프로젝트 설정 시작..."

# 프로젝트 디렉토리로 이동
PROJECT_DIR="$HOME/projects/connectwo-controller/stm32cubeide/motor_controller"
cd "$PROJECT_DIR"

echo "📁 현재 위치: $(pwd)"

# 1. 기존 빌드 디렉토리 정리
echo "🧹 기존 빌드 디렉토리 정리..."
rm -rf build CMakeCache.txt CMakeFiles

# 2. CMakeLists.txt 복사 (위에서 생성한 파일을 여기에 붙여넣기)
echo "📝 CMakeLists.txt 생성..."
cat > CMakeLists.txt << 'EOF'
# motor_controller CMakeLists.txt - 위의 내용을 여기에 붙여넣을 예정
# 이 스크립트 실행 전에 CMakeLists.txt를 수동으로 생성해주세요
EOF

# 3. 필수 파일 확인
echo "🔍 필수 파일 확인..."

# 스타트업 파일 찾기
STARTUP_FILE=$(find . -name "startup_stm32f446*.s" 2>/dev/null | head -1)
if [ -z "$STARTUP_FILE" ]; then
    echo "⚠️  스타트업 파일을 찾을 수 없습니다. 다음 위치를 확인하세요:"
    find . -name "startup*.s" 2>/dev/null || echo "   스타트업 파일이 없습니다."
else
    echo "✅ 스타트업 파일 발견: $STARTUP_FILE"
fi

# 링커 스크립트 찾기
LINKER_SCRIPT=$(find . -name "*STM32F446*FLASH*.ld" 2>/dev/null | head -1)
if [ -z "$LINKER_SCRIPT" ]; then
    echo "⚠️  링커 스크립트를 찾을 수 없습니다. 다음 위치를 확인하세요:"
    find . -name "*.ld" 2>/dev/null || echo "   링커 스크립트가 없습니다."
else
    echo "✅ 링커 스크립트 발견: $LINKER_SCRIPT"
fi

# HAL 드라이버 확인
if [ -d "Drivers/STM32F4xx_HAL_Driver" ]; then
    echo "✅ HAL 드라이버 발견"
else
    echo "⚠️  HAL 드라이버 디렉토리가 없습니다."
    echo "   STM32CubeMX로 코드 재생성이 필요할 수 있습니다."
fi

# ROS 라이브러리 확인
if [ -d "../MC_lib/main/ros" ]; then
    echo "✅ 기존 ROS 라이브러리 발견"
    ls -la ../MC_lib/main/ros/
else
    echo "⚠️  ROS 라이브러리 경로를 확인해주세요."
fi

# 4. 툴체인 확인
echo "🔧 툴체인 확인..."
if command -v arm-none-eabi-gcc >/dev/null 2>&1; then
    echo "✅ ARM GCC: $(arm-none-eabi-gcc --version | head -1)"
else
    echo "❌ ARM GCC를 찾을 수 없습니다!"
    echo "   PATH 설정을 확인하세요: export PATH=\"/opt/gcc-arm-none-eabi-10-2020-q4-major/bin:\$PATH\""
fi

if command -v cmake >/dev/null 2>&1; then
    echo "✅ CMake: $(cmake --version | head -1)"
else
    echo "❌ CMake를 찾을 수 없습니다!"
fi

# 5. 빌드 디렉토리 생성
echo "📁 빌드 디렉토리 생성..."
mkdir -p build

echo ""
echo "🎯 다음 단계:"
echo "1. 위에서 생성한 CMakeLists.txt 내용을 $PROJECT_DIR/CMakeLists.txt에 붙여넣기"
echo "2. 스타트업 파일과 링커 스크립트 경로 확인 및 수정"
echo "3. cd build && cmake .. 실행"
echo ""
echo "✅ 설정 스크립트 완료!"
