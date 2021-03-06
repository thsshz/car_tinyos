// $Id: BlinkToRadio.h,v 1.4 2006-12-12 18:22:52 vlahan Exp $

#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 100,
  MIN_JOYSTICK = 1000,
  MAX_JOYSTICK = 3000
};

typedef nx_struct BlinkToRadioMsg {
  nx_uint8_t type;
  nx_uint8_t data;
} BlinkToRadioMsg;

#endif
