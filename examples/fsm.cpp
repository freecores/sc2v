#include "systemc.h"

#define HOLA 1
#define CONCAT 1

void fsm::regs(){
	if(rst.read()){
		state.write(S0);
	}else
		state.write(next_state);
}

void fsm::fsm_proc(){
/*Verilog begin
	cfsm_proc={a[1:0],b[1:0]};
verilog end*/

	sc_uint<2> c;
	next_state.write(state.read());
	a.write(0);
	b.write(HOLA);
	
	#ifdef CONCAT
	  c.write((a.range(1,0),b.range(1,0)));
	#else
	  c.write((a,a));
	#endif
	
	switch((int)state.read()){
	  case S0 :  //Case 0
		  if(input1.read()){
	         next_state.write(S1);
		     a.write(true); 
		  }else if (input2.read()){
			 next_state.write(S2);
		     a.write(false); 
		  }else{
			 next_state.write(S0);
		     a.write(1); 
		  }
		  break;
//   tRaNsLaTe   oFF		  
	  case S1:
		  if(input2.read()){ 
	         next_state.write(S2);
		     b.write(1); 
		  }
		  break;
//   tRaNsLaTe   oN		  
      case S2:
 		  next_state.write(S0);
  	      break;
  }
}
