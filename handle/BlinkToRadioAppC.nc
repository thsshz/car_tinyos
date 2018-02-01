#include <Timer.h>
#include "printf.h"
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC {
}
implementation {
  components MainC;
  components LedsC;
  components BlinkToRadioC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new JoyStickAppC() as JoyStickAppC;
  components ButtonC;
  components new AMSenderC(AM_BLINKTORADIO);
  components PrintfC;
  components SerialStartC;
  components HplMsp430GeneralIOC as GIO;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Read1 -> JoyStickAppC.Read1;
  App.Read2 -> JoyStickAppC.Read2;
  App.Button -> ButtonC;
}
