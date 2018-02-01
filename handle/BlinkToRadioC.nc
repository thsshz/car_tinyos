#include <Timer.h>
#include <Msp430Adc12.h>
#include "BlinkToRadio.h"
#include "printf.h"

 module BlinkToRadioC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as Read1;
  uses interface Read<uint16_t> as Read2;
  uses interface Button;
}
implementation {

  enum {
    UART_QUEUE_LEN = 12,
  };

  message_t  uartQueueBufs[UART_QUEUE_LEN];
  message_t  * ONE_NOK uartQueue[UART_QUEUE_LEN];
  uint8_t    uartIn, uartOut;
  bool       uartFull;

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;
  bool angleFlag = FALSE;
  uint16_t joystick_x;
  uint16_t joystick_y;
  uint8_t joystick = 0x06;
  uint8_t pre_joystick = 0x06;
  uint8_t angle1 = 0;
  uint8_t angle2 = 0;

  void setQueue(message_t *msg);
  task void sendQueue();
  void setLeds(uint16_t val) {
    if (val & 0x01)
      call Leds.led0On();
    else 
      call Leds.led0Off();
    if (val & 0x02)
      call Leds.led1On();
    else
      call Leds.led1Off();
    if (val & 0x04)
      call Leds.led2On();
    else
      call Leds.led2Off();
  }

  void setQueue(message_t *msg) {
    atomic{
      if (!uartFull)
      {
        uartQueue[uartIn] = msg;
        uartIn = (uartIn + 1) % UART_QUEUE_LEN; 
        if (uartIn == uartOut)
          uartFull = TRUE;
      }
    }
  }

  task void sendQueue() {
    if (!busy) {
      atomic{
        if (uartIn == uartOut && !uartFull)
        {
          return;
        }
      }
      if (call AMSend.send(AM_BROADCAST_ADDR, 
      uartQueue[uartOut], sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
        call Leds.led2On();
      }
      else
        post sendQueue();
      }
  }

  void judgeJoystick() {
    if (joystick_x < MIN_JOYSTICK)
      joystick = 0x05;
    else if (joystick_x > MAX_JOYSTICK)
      joystick = 0x04;
    if (joystick_y < MIN_JOYSTICK)
      joystick = 0x02;
    else if (joystick_y > MAX_JOYSTICK)
      joystick = 0x03;
    else if (joystick_x >= MIN_JOYSTICK && joystick_x <= MAX_JOYSTICK)
      joystick = 0x06;
  }

  event void Boot.booted() {
    uint8_t i;

    for (i = 0; i < UART_QUEUE_LEN; i++)
      uartQueue[i] = &uartQueueBufs[i];
    uartIn = uartOut = 0;
    uartFull = TRUE;
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Leds.led1On();
      uartFull = FALSE;
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
      call Button.start();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Button.startDone(error_t err){
    if(err != SUCCESS){
      call Button.start();
    }
  }
  
  event void Button.stopDone(error_t err){ 

  }
  event void Timer0.fired() {
    call Read1.read();
    call Read2.read();
    call Button.pinvalueA();
    call Button.pinvalueB();
    call Button.pinvalueC();
    call Button.pinvalueD();
    call Button.pinvalueE();
    if (angleFlag == TRUE){
      BlinkToRadioMsg* btrpkt = 
        (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
      btrpkt->type = 2;
      btrpkt->data = 0x03;
      angleFlag = FALSE;
      setQueue(&pkt);
    }
    // call Button.pinvalueF();
    post sendQueue();
    atomic{
      judgeJoystick();
      if(joystick != pre_joystick){
        BlinkToRadioMsg* btrpkt = 
        (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
        btrpkt->type = 0;
        btrpkt->data = joystick;
        setQueue(&pkt);
      }

      if (angle1 != 0){
        BlinkToRadioMsg* btrpkt = 
        (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
        btrpkt->type = 1;
        btrpkt->data = angle1;
        setQueue(&pkt);
      }

      if (angle2 != 0){
        if(angle2 == 0x03){
          angleFlag = TRUE;
        }
        else {
          BlinkToRadioMsg* btrpkt = 
          (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
          btrpkt->type = 2;
          btrpkt->data = angle2;
          setQueue(&pkt);
        }
      }
    }
  }


  event void Read1.readDone(error_t result, uint16_t val) {
    if (result == SUCCESS) {
      joystick_x = val;
    }
  }

  event void Read2.readDone(error_t result, uint16_t val) {
    if (result == SUCCESS) {
      joystick_y = val;
    }
  }

  event void Button.pinvalueADone(error_t err) {
    if (err == SUCCESS) {
      angle1 = 0x01;
    }
  }

  event void Button.pinvalueBDone(error_t err) {
    if (err == SUCCESS) {
      angle1 = 0x02;
    }
  }

  event void Button.pinvalueCDone(error_t err) {
    if (err == SUCCESS) {
      angle2 = 0x01;
    }
  }

  event void Button.pinvalueDDone(error_t err) {
    if (err == SUCCESS) {
      angle2 = 0x02;
    }
  }

  event void Button.pinvalueEDone(error_t err) {
    if (err == SUCCESS) {
      angle1 = 0x03;
      angle2 = 0x03;
    }
  }
/*
  event void Button.pinvalueFDone(error_t err) {
    if (err == SUCCESS) {
      angle1 = 0x03;
      angle2 = 0x03;
    }
  }
  */

  event void AMSend.sendDone(message_t* msg, error_t err) {
    atomic{
      if (msg == uartQueue[uartOut])
      {
        if (++uartOut >= UART_QUEUE_LEN)
          uartOut = 0;
        if (uartFull)
          uartFull = FALSE;
      }
      busy = FALSE;
      pre_joystick = joystick;
      angle1 = 0;
      angle2 = 0;
    }
    post sendQueue();
  }

}
