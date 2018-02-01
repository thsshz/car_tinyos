interface Button
{
	command void start();
	event void startDone(error_t err);
	command void stop();
	event void stopDone(error_t err);
	command void pinvalueA();
	event void pinvalueADone(error_t err);
	command void pinvalueB();
	event void pinvalueBDone(error_t err);
	command void pinvalueC();
	event void pinvalueCDone(error_t err);
	command void pinvalueD();
	event void pinvalueDDone(error_t err);
	command void pinvalueE();
	event void pinvalueEDone(error_t err);
	// command void pinvalueF();
	// event void pinvalueFDone(error_t err);
}