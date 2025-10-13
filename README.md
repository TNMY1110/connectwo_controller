# Connectwo 컨트롤러
##### Tresc3 모바일 로봇 베이스 컨트롤러

***

<img src="./image/tresc3_0.jpg" alt="board" style="width:200px;"/>
<img src="./image/microschool_1.jpg" alt = "microschool" style="width:200px;">

***

</br>

> I cannot give you the fomular for success, but I can give you the formula for failure-Which is: Try to please everybody. -H. B. Swope -

<img src="./image/robot_0.jpeg" alt="robot" style="width:500px;"/>

<img src="./image/robot_1.jpeg" alt="boards" style="width:500px;"/>

<img src="./image/board_0.jpg" alt="board" style="width:500px;"/>

## 📋 프로젝트 개요

이 레포지토리는 Tresc3 로봇 플랫폼용 Connectwo 모바일 로봇 베이스 컨트롤러의 임베디드 펌웨어를 포함합니다. STM32F446RE 마이크로컨트롤러를 기반으로 하여 포괄적인 모터 제어, 센서 통합 및 ROS 통신 기능을 제공합니다.

## 🔧 하드웨어 사양

### 핵심 플랫폼
* **MCU**: STM32F446RE (ARM Cortex-M4 with FPU, 180MHz)
* **툴체인**: STM32CubeIDE + ARM GCC 크로스 컴파일러
* **전원**: 5V 입력 및 온보드 전압 조절

### 통신 인터페이스
* **USB_OTG_FS**: USB On-The-Go Full Speed
* **UART**: 2개의 UART 인터페이스 (USART2, USART3, UART5)
* **USB to TTL**: USB를 통한 직렬 통신
* **MAX232**: 레거시 통신용 RS-232 레벨 시프터
* **CAN**: Controller Area Network 버스 (1Mbps)
* **I2C**: Inter-Integrated Circuit 버스

### 모터 제어 시스템
* **모터**: 4개의 독립적인 모터 완전 제어
* **PWM 제어**: 속도 제어를 위한 펄스 폭 변조
* **방향 제어**: 양방향 모터 작동
* **엔코더 피드백**: 4개 모터 모두에 대한 쿼드러처 엔코더 지원
* **드라이브 시스템**: 차동 구동 및 메카넘 휠 구성 지원

### 센서 통합
* **ADC**: 4개의 아날로그-디지털 변환기 채널
* **IMU**: 관성 측정 장치 지원 (가속도계, 자이로스코프)
* **엔코더 피드백**: 모터로부터 위치 및 속도 피드백

## 🏗️ 프로젝트 구조

```
connectwo-controller/
├── stm32cubeide/
│   ├── motor_controller/          # 메인 STM32 프로젝트
│   │   ├── Src/                   # 소스 파일 (HAL + 사용자 코드)
│   │   ├── Inc/                   # 헤더 파일
│   │   ├── Startup/               # 부트 코드 및 링커 스크립트
│   │   ├── Drivers/               # STM32 HAL 드라이버
│   │   ├── CMakeLists.txt         # CMake 빌드 설정
│   │   └── motor_controller.ioc   # STM32CubeMX 설정
│   └── MC_lib/                    # 모터 제어 라이브러리
│       ├── main/ros/              # ROS 통신 레이어
│       ├── lib/                   # 모터 제어 알고리즘
│       └── ROS/                   # ROS 메시지 정의
├── CMakelist.sh                   # 빌드 설정 스크립트
└── CLAUDE.md                      # 개발 가이드라인
```

### 주요 구성 요소

1. **HAL 레이어**: 모든 주변장치용 STM32 하드웨어 추상화 레이어
2. **모터 제어 라이브러리**: PID 컨트롤러를 포함한 고급 모터 제어 알고리즘
3. **ROS 통합**: 로봇 애플리케이션을 위한 완전한 Robot Operating System 지원
4. **상태 머신**: 로봇 제어 로직을 위한 작업 기반 상태 머신
5. **통신 스택**: 다중 프로토콜 통신 시스템

## 🚀 시작하기

### 필요 조건

```bash
# ARM GCC 툴체인
sudo apt-get install gcc-arm-none-eabi

# CMake (버전 3.22 이상)
sudo apt-get install cmake

# 플래싱용 ST-Link 도구
sudo apt-get install stlink-tools

# 선택사항: 하드웨어 구성용 STM32CubeMX
```

### 프로젝트 빌드

```bash
# 제공된 스크립트를 사용한 빠른 빌드
./CMakelist.sh

# 또는 수동 CMake 빌드
cd stm32cubeide/motor_controller
rm -rf build
mkdir build && cd build
cmake ..
make
```

### 플래싱 및 실행

```bash
# 디바이스에 플래시
make flash

# 또는 st-flash 직접 사용
st-flash write motor_controller.bin 0x8000000

# 직렬 출력 모니터링
make monitor
# 또는 screen 사용
screen /dev/ttyUSB0 115200
```

## 🤖 ROS 통합

컨트롤러는 로봇 애플리케이션을 위한 완전한 ROS(Robot Operating System) 통합을 제공합니다:

### ROS 토픽
- `/imu` - IMU 센서 데이터
- `/odom` - 오도메트리 정보
- `/joint_states` - 모터 조인트 상태
- `/cmd_vel` - 속도 명령

### 구성
- **휠 파라미터**: 반지름 65mm, 분리 거리 377mm
- **업데이트 속도**: 센서 및 제어 루프용 구성 가능한 타이밍
- **TF 프레임**: ROS 변환 트리 지원

## ⚙️ 모터 제어 기능

### 제어 모드
- **PWM 모드**: 모터 속도를 위한 직접 PWM 제어
- **PID 모드**: 폐루프 위치/속도 제어
- **엔코더 모드**: 위치 피드백 제어

### 모터 구성
```cpp
#define AUCAR_MAX_SPEED     1000      // 최대 속도 설정
#define AUCAR_WHEEL_BASE    250       // 휠베이스 (mm)
#define AUCAR_WHEEL_RADIUS  65        // 휠 반지름 (mm)
#define AUCAR_MOTOR_COUNT   4         // 모터 개수
```

## 🛠️ 개발

### 하드웨어 구성
프로젝트는 하드웨어 구성을 위해 STM32CubeMX를 사용합니다. 주변장치 설정을 수정하려면:

1. STM32CubeMX에서 `motor_controller.ioc` 열기
2. 주변장치 구성 수정
3. 코드 재생성 (`USER CODE BEGIN/END` 블록의 사용자 코드는 보존됨)

### 빌드 출력물
- `motor_controller.elf` - 심볼이 포함된 디버그 실행 파일
- `motor_controller.hex` - 프로그래밍용 Intel HEX 형식
- `motor_controller.bin` - st-flash용 바이너리 형식

### 개발 팁
- 개발 가이드라인은 제공된 CLAUDE.md 참조
- 기존 코드 패턴과 규칙 준수
- 시뮬레이션과 하드웨어 모두에서 테스트
- 디버깅을 위한 직렬 출력 모니터링

## 📊 성능

- **제어 루프**: 10ms 메인 제어 루프
- **CAN 버스**: 1Mbps 통신 속도
- **UART**: 디버깅용 115200 보드레이트
- **ADC**: DMA 지원하는 12비트 해상도

## 🔧 디버깅

### 직렬 모니터
```bash
# 실시간 디버그 출력 보기
make monitor
```

### 개발 환경
- **IDE**: STM32CubeIDE (권장) 또는 ARM 호환 IDE
- **디버거**: GDB 지원하는 ST-Link v2/v3
- **분석**: 내장 성능 모니터링 및 진단 도구

## 📚 코드 아키텍처

### 메인 진입점
- `stm32cubeide/motor_controller/Src/main.c:33` - ROS 통합 진입점
- `stm32cubeide/MC_lib/main/ros/inc/ros_main.h` - ROS 통신 인터페이스

### 통신 프로토콜
컨트롤러는 다음 구조의 패킷 기반 통신 프로토콜을 구현합니다:

```
| 2바이트 | 2바이트 | 2바이트 | 2바이트 | 가변 바이트 | 1바이트 |
| s-bits  |  cmd1   |  cmd2   | length  |    data     |  csum   |
```

### 주요 구성 파일
- `stm32cubeide/motor_controller/Inc/AuCAR_conf.h` - 로봇 구성
- `stm32cubeide/MC_lib/main/ros/inc/connectwo_config.h` - ROS 설정

