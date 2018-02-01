#include <Timer.h>
#include <Msp430Adc12.h>
#include "BlinkToRadio.h"
#include "printf.h"

module BlinkToRadioC {
  uses{
    interface Boot;
    interface Leds;
    interface Timer<TMilli> as Timer0;
    interface Packet;
    interface AMPacket;
    interface AMSend;
    interface Receive;
    interface SplitControl as AMControl;

    interface Car;
//    interface Read<uint16_t> as Read;
}
}
implementation {

  uint16_t counter = 0;
  message_t pkt;
  bool busy = FALSE;
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    counter++;
    if(counter == 1) {
      call Car.Forward();
    }
    else if(counter == 11) {
      call Car.Back();
    }
    else if(counter == 21) {
      call Car.Left();
    }
    else if(counter == 31) {
      call Car.Right();
    }
    else if(counter == 41) {
      call Car.Pause();
    }
    else if(counter < 44 && counter >= 42) {
      call Car.Angle_1(0x01);
    }
    else if(counter < 49 && counter >= 44) {
      call Car.Angle_1(0x02);
    }
    else if(counter == 49){
      call Car.Angle_1(0x03);
    }
    else if(counter < 52 && counter >= 50) {
      call Car.Angle_2(0x01);
    }
    else if(counter < 57 && counter >= 52) {
      call Car.Angle_2(0x02);
    }
    else if(counter == 57){
      call Car.Angle_2(0x03);
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      if(btrpkt->type == 0) {
        if(btrpkt->data == 0x02) {
          call Car.Forward();
        }
        else if(btrpkt->data == 0x03) {
          call Car.Back();
        }
        else if(btrpkt->data == 0x04) {
          call Car.Left();
        }
        else if(btrpkt->data == 0x05) {
          call Car.Right();
        }
        else if(btrpkt->data == 0x06) {
          call Car.Pause();
        }
      }
      else if(btrpkt->type == 1) {
        if(btrpkt->data == 0x01){
          call Car.Angle_1(0x01);
        }
        else if(btrpkt->data == 0x02){
          call Car.Angle_1(0x02);
        }
        else if(btrpkt->data == 0x03){
          call Car.Angle_1(0x03);
        }
      }
      else if(btrpkt->type == 2) {
        if(btrpkt->data == 0x01){
          call Car.Angle_2(0x01);
        }
        else if(btrpkt->data == 0x02){
          call Car.Angle_2(0x02);
        }
        else if(btrpkt->data == 0x03){
          call Car.Angle_2(0x03);
        }
      }
      return msg;
    }
  }
}
