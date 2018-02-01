#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 300
};

typedef nx_struct BlinkToRadioMsg {
  nx_uint8_t type;
  nx_uint8_t data;
} BlinkToRadioMsg;

#endif
