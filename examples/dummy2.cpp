#include "systemc.h"

void
fsm::regs ()
{
  if (rst.read ())
    {
      state.write (0);
    }
  else
    state.write (next_state);
}

void
fsm::fsm_proc ()
{

  sc_uint <2> c[4];
  sc_uint <4> f;
  next_state.write (state.read ());
  array[0].write(1);
  
  c[1]=0;
  
  switch ((int) state.read ())
    {
     case 0x1a:			
      if (input1.read ())
	{
	  next_state.write (sc_uint<4>(0x1b1));
	  a.write (true);
	}
      else if (input2.read () < input1.read())
	{
	  next_state.write (2);
	  a.write (false);
	}
      else
	{
	  next_state.write (1);
	  a.write (1);
	}
      break;
     case 0xfaf67:
       //hola
       switch(input1.read()){
	case 0x1:
	case 0x2:
	  switch(input1.read()){
	   case 0x1:
	    b.write(0);
	    break;
	   case 0x3:
	    b.write(1);
	    break;
	  }
	  b.write(0);
	  break;
	case 0x3:
	  b.write(1);
	  break;
	}
                

      if (input2.read ())
	{
	  next_state.write (2);
	  b.write (1);
	}
      break;
     case 35:
      next_state.write (0);
      break;
    }
}
