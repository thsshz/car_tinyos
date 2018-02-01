#include "Car.h"
#include "msp430usart.h"

module CarP {
  provides {
    interface Car;
  }
  uses {
    interface Leds;
    interface Resource;
    interface HplMsp430Usart;
   // interface Msp430Usart;
    interface HplMsp430GeneralIO as P20;
  }
}
implementation {

  bool request_busy = FALSE;
  uint8_t type;
  uint16_t data;
  uint16_t speed = 500;
  uint16_t angle_change = 300;
  uint16_t angle1 = 3400;
  uint16_t angle2 = 3400;
  uint16_t angle3 = 3400;
  uint16_t init_angle = 3400;

  void setLeds(uint8_t val) {
    if(val == 0x02){
      call Leds.led0Off();
      call Leds.led1On();
      call Leds.led2Off();
    }
    if(val == 0x03){
      call Leds.led0Off();
      call Leds.led1On();
      call Leds.led2On();
    }
    if(val == 0x04){
      call Leds.led0On();
      call Leds.led1Off();
      call Leds.led2Off();
    }
    if(val == 0x05){
      call Leds.led0On();
      call Leds.led1Off();
      call Leds.led2On();
    }
    if(val == 0x06){
      call Leds.led0On();
      call Leds.led1On();
      call Leds.led2Off();
    }

    if(val == 0x01){
      call Leds.led0Off();
      call Leds.led1Off();
      call Leds.led2On();
    }
    if(val == 0x07){
      call Leds.led0On();
      call Leds.led1On();
      call Leds.led2On();
    }
    if(val == 0x08){
      call Leds.led0Toggle();
      call Leds.led1Off();
      call Leds.led2Off();
    }
    if(val == 0x09){
      call Leds.led0Off();
      call Leds.led1Toggle();
      call Leds.led2Off();
    }
    if(val == 0x0A){
      call Leds.led0Toggle();
      call Leds.led1Toggle();
      call Leds.led2Toggle();
    }
  }


  command error_t Car.Angle_1(uint16_t value) {
    type = 0x01;
    if(value == 0x01){
      setLeds(type);
      if(angle1 + angle_change < 4500){
        angle1 += angle_change;
      }
    }
    else if(value == 0x02){
      setLeds(0x08);
      if(angle1 - angle_change > 500){
        angle1 -= angle_change;
      }
    }
    else if(value == 0x03){
      setLeds(0x0A);
      angle1 = init_angle;
    }
    data = angle1;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Angle_2(uint16_t value) {
    type = 0x07;
    if(value == 0x01){
      setLeds(type);
      if(angle2 + angle_change < 4500){
        angle2 += angle_change;
      }
    }
    else if(value == 0x02){
      setLeds(0x09);
      if(angle2 - angle_change > 500){
        angle2 -= angle_change;
      }
    }
    else if(value == 0x03){
      angle2 = init_angle;
    }
    data = angle2;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Angle_3(uint16_t value) {
    type = 0x08;
    if(value == 0x01){
      setLeds(type);
      if(angle3 + angle_change < 4500){
        angle3 += angle_change;
      }
    }
    else if(value == 0x02){
      if(angle3 - angle_change > 500){
        angle3 -= angle_change;
      }
    }
    else if(value == 0x03){
      angle3 = init_angle;
    }
    data = angle3;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Right() {
    type = 0x02;
    setLeds(type);
    data = speed;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Left() {
    type = 0x03;
    setLeds(type);
    data = speed;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Forward() {
    type = 0x04;
    setLeds(type);
    data = speed;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Back() {
    type = 0x05;
    setLeds(type);
    data = speed;
    call Resource.request();
    return SUCCESS;
  }
  command error_t Car.Pause() {
    type = 0x06;
    setLeds(type);
    data = 0x0000;
    call Resource.request();
    return SUCCESS;
  }

  event void Resource.granted() {
    call HplMsp430Usart.setModeUart(&config1);
    call HplMsp430Usart.enableUart();
    U0CTL &= ~SYNC;
    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx(0x01);

    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx(0x02);

    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx(type);

    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx((uint8_t)(data >> 8u));

    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx((uint8_t)data);

    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx(0xFF);
    
    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx(0xFF);
    
    while(!call HplMsp430Usart.isTxEmpty()){}
    call HplMsp430Usart.tx(0x00);

    while(!call HplMsp430Usart.isTxEmpty()){}
    call Resource.release();
    request_busy = FALSE;
  }


  command error_t Car.InitMaxSpeed(uint16_t value) {

    return SUCCESS;
  }

  command error_t Car.InitMinSpeed(uint16_t value) {
    return SUCCESS;
  }

  command error_t Car.InitLeftServo(uint16_t value) {
    call Car.Angle_2(0x1800);
    return SUCCESS;
  }

  command error_t Car.InitRightServo(uint16_t value) {
    return SUCCESS;
  }

  command error_t Car.InitMidServo(uint16_t value) {
    call Car.Angle_1(0x3400);
    return SUCCESS;
  }

  command void Car.Start() {
  }
}
