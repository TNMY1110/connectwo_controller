#ifndef AUCAR_CONF_H
#define AUCAR_CONF_H

// AuCAR 설정값들
#define AUCAR_MAX_SPEED     1000
#define AUCAR_WHEEL_BASE    260   // mm
#define AUCAR_WHEEL_RADIUS  57    // mm

// 모터 관련 설정
#define AUCAR_MOTOR_COUNT   4
#define AUCAR_USE_CAN       1
#define AUCAR_USE_PWM       1

// 센서 관련 설정
#define AUCAR_USE_IMU       1
#define AUCAR_USE_ENCODER   1

// State Machine 관련 설정
#define TASK_MAX_QUEUE_SIZE 10
#define TASK_MAX_SIZE       5

#endif /* AUCAR_CONF_H */
