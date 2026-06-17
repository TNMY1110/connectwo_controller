/*
 * Nonholonomic.cpp
 *
 *  Created on: 2021. 2. 24.
 *      Author: colson
 */

#ifndef NONHOLONOMIC_H_
#define NONHOLONOMIC_H_

#ifdef __cplusplus
extern "C" {
#endif
/*      _____________
 *     |             |
 *  ___|             |___
 * |   |             |   |
 * |   |<----(2l)---->|   |
 * |___|             |___|
 *     |             |
 *     |_____________|
 *
 *	wheel diameter = (2r)
 *
 * */

typedef struct motorValue_t {
	double leftValue;
	double rightValue;
} motorValueTypeDef;
class Nonholonomic {
private:
	double r;
	double l;
	double p;
	double t;

	double factor;
public:
	/*
	 * @param _r	: wheel radius (no diameter)
	 * @param _l	: wheel distance / 2
	 * @param _p	: pulses within 1 rev.
	 * @param _t	: control cycle
	 * */
	Nonholonomic(double _r, double _l, double _p, double _t) :
			r(_r), l(_l), p(_p), t(_t) {
		factor = p * t / 6.28 / r;
	}
	;
	~Nonholonomic() {
	}
	;

	motorValueTypeDef calc(double _linearVelocity,
			double _angularVelocity) {
		motorValueTypeDef ret;
		double l_value = 0;
		double a_value = 0;
		
		if (_linearVelocity)
			l_value = _linearVelocity * factor;

		// 4륜 로봇은 바닥을 미끄러지며 돌아야 하므로 2륜 공식보다 훨씬 더 많은 바퀴 회전수가 필요함(보통 1.2배 ~ 1.8배)
		if(_angularVelocity)
		{
			const double SKID_FACTOR = 1.3;
			a_value = _angularVelocity * l * factor * SKID_FACTOR;
		}

		ret.rightValue = l_value + a_value;
		ret.leftValue = l_value - a_value;

		// 만약 완전히 제자리 회전 명령(선속도=0, 각속도만 존재)이 들어왔다면 마찰력을 확실히 이기도록 강하게 회전 토크를 걸어줌
        if (_linearVelocity == 0 && _angularVelocity != 0) {
            ret.rightValue *= 1.1; // 제자리 회전 시 10% 추가 증폭 (필요시 조정)
            ret.leftValue  *= 1.1;
        }

		return ret;
	}
private:

};


#ifdef __cplusplus
}
#endif
#endif /* NONHOLONOMIC_H_ */
