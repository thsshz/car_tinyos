#include "Car.h"

configuration CarC {
  provides interface Car;
}
implementation {
  components HplMsp430Usart0C as HplUsart;
  components new Msp430Uart0C() as Uart;
  components HplMsp430GeneralIOC as GIO;
  components LedsC;
  components CarP;
  Car = CarP;

  CarP.HplMsp430Usart -> HplUsart;
  CarP.Resource -> Uart;
  CarP.P20 -> GIO.Port20;
  CarP.Leds -> LedsC;
}
