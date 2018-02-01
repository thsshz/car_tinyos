interface Car {
	command void Start();
	command error_t Angle_1(uint16_t value);
	command error_t Angle_2(uint16_t value);
	command error_t Angle_3(uint16_t value);
	command error_t Forward();
	command error_t Back();
	command error_t Left();
	command error_t Right();
	//command error_t QuiryReader(uint8_t value);
	command error_t Pause();
	command error_t InitMaxSpeed(uint16_t value);
	command error_t InitMinSpeed(uint16_t value);
	command error_t InitLeftServo(uint16_t value);
	command error_t InitRightServo(uint16_t value);
	command error_t InitMidServo(uint16_t value);
}