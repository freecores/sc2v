/* 
This is a example code that does nothing but uses the new
features included in new versions
*/


#include "systemc.h"

SC_MODULE(fsm){

   sc_in<bool> clk;
   sc_in<bool> rst,input1, input2;
   sc_out< sc_uint<2> > a,b,w;

   enum state_t {S0,S1,S2};
   sc_signal<state_t> state,next_state;
   
   enum {AA,BB,CC,DD,EE} estado;
   enum {AAA} est;
   

   sc_signal<sc_uint<4> > temp;


   void regs();
   void fsm_proc();
   sc_uint<2> func1 (sc_uint<2> a, sc_uint<2> b);
  
   moduleA *moda;
   
   SC_CTOR(fsm){
 
     moda = new moduleA("MODA");
     
     moda->m1_in(input1);
     moda->m1_out(w);

     SC_METHOD(regs);
     sensitive_pos(clk);
     sensitive_neg(rst);
	 
     SC_METHOD(fsm_proc);
     sensitive(state);
     sensitive << input1;
     sensitive(input2);
	  
 }
};
