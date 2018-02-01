#include <Msp430Adc12.h>
#include <Timer.h>

generic configuration JoyStickAppC() {
  provides interface Read<uint16_t> as Read1;
  provides interface Read<uint16_t> as Read2;
}
implementation {
  components new AdcReadClientC() as AdcReadClientC1;
  components new AdcReadClientC() as AdcReadClientC2;
  Read1 = AdcReadClientC1.Read;
  Read2 = AdcReadClientC2.Read;
  components JoyStickC;
  AdcReadClientC1.AdcConfigure -> JoyStickC.AdcConfigure1;
  AdcReadClientC2.AdcConfigure -> JoyStickC.AdcConfigure2; 
}
