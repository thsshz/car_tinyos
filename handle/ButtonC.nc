configuration ButtonC {
  provides interface Button;
}
implementation {
  components HplMsp430GeneralIOC as GIO;
  components ButtonP;
  Button = ButtonP;

  ButtonP.IOA -> GIO.Port60;
  ButtonP.IOB -> GIO.Port21;
  ButtonP.IOC -> GIO.Port61;
  
  ButtonP.IOD -> GIO.Port62;
  ButtonP.IOE -> GIO.Port26;
  // ButtonP.IOF -> GIO.Port23;
}
