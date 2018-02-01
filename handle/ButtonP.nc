module ButtonP @safe() {	
	provides {
		interface Button;
	}
	uses {
		interface HplMsp430GeneralIO as IOA;
		interface HplMsp430GeneralIO as IOB;
		interface HplMsp430GeneralIO as IOC;
		interface HplMsp430GeneralIO as IOD;
		interface HplMsp430GeneralIO as IOE;
		// interface HplMsp430GeneralIO as IOF;
	}
}
implementation {
	command void Button.start(){
		call IOA.clr();
		call IOB.clr();
		call IOC.clr();
		call IOD.clr();
		call IOE.clr();
		// call IOF.clr();
		call IOA.makeInput();
		call IOB.makeInput();
		call IOC.makeInput();
		call IOD.makeInput();
		call IOE.makeInput();
		// call IOF.makeInput();
		signal Button.startDone(SUCCESS);
	}


	command void Button.stop(){
		call IOA.clr();
		call IOB.clr();
		call IOC.clr();
		call IOD.clr();
		call IOE.clr();
		// call IOF.clr();
		signal Button.stopDone(SUCCESS);
	}


	command void Button.pinvalueA(){
		if(call IOA.get()){
			signal Button.pinvalueADone(FAIL);
		}
		else {
			signal Button.pinvalueADone(SUCCESS);
		}
	}

	command void Button.pinvalueB(){
		if(call IOB.get()){
			signal Button.pinvalueBDone(FAIL);
		}
		else {
			signal Button.pinvalueBDone(SUCCESS);
		}
	}
	command void Button.pinvalueC(){
		if(call IOC.get()){
			signal Button.pinvalueCDone(FAIL);
		}
		else {
			signal Button.pinvalueCDone(SUCCESS);
		}
	}
	command void Button.pinvalueD(){
		if(call IOD.get()){
			signal Button.pinvalueDDone(FAIL);
		}
		else {
			signal Button.pinvalueDDone(SUCCESS);
		}
	}
	command void Button.pinvalueE(){
		if(call IOE.get()){
			signal Button.pinvalueEDone(FAIL);
		}
		else {
			signal Button.pinvalueEDone(SUCCESS);
		}
	}
	/*
	command void Button.pinvalueF(){
		if(call IOF.get()){
			signal Button.pinvalueFDone(FAIL);
		}
		else {
			signal Button.pinvalueFDone(SUCCESS);
		}
	} */
}