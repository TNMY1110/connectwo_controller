#ifndef PID_H
#define PID_H

#ifdef __cplusplus
extern "C" {
#endif

// 임시 PID 구조체 정의
typedef struct {
    float kp, ki, kd;
    float previous_error;
    float integral;
    float output_limit;
} PID_Controller;

// 함수 프로토타입
void PID_Init(PID_Controller* pid, float kp, float ki, float kd);
float PID_Calculate(PID_Controller* pid, float setpoint, float current);
void PID_Reset(PID_Controller* pid);

#ifdef __cplusplus
}

// C++ 클래스 버전 (ros_main.cpp에서 사용할 수 있도록)
class PID {
public:
    PID(float kp, float ki, float kd) : kp_(kp), ki_(ki), kd_(kd), 
        previous_error_(0), integral_(0) {}
    
    float calculate(float setpoint, float current) {
        float error = setpoint - current;
        integral_ += error;
        float derivative = error - previous_error_;
        previous_error_ = error;
        return kp_ * error + ki_ * integral_ + kd_ * derivative;
    }
    
private:
    float kp_, ki_, kd_;
    float previous_error_, integral_;
};

#endif

#endif // PID_H
