/* -----------------------------------------------------------------------------
 *
 *  SystemC to Verilog Translator v0.3
 *  Provided by OpenSoc Design
 *  
 *  www.opensocdesign.com
 *
 * -----------------------------------------------------------------------------
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

%{

#include <stdio.h>
#include <string.h>
#include <math.h>

#include "sc2v_step2.h"


  char *enumname;

  int reading_enumerates = 0;


/*Multiple Declarations*/
  int multipledec;
  char *storedtype;


/* Global var to store process module name*/
  char *module_name;
  int module_name_found = 0;


/* Global var to store last port type*/
  char *lastportkind;
  int lastportsize;
  int activeport = 0;		// 1 -> reading port list

/* Global var to store last signal type*/
  int lastsignalsize;
  int signalactive = 0;


/* Global var to store last SC_METHOD found*/
  char *active_method;
  char *active_method_type;
  int method_found;


/* Global var to store last sensitivity found*/
  char *last_sensibility;
  int sensibility_active = 0;


  int translate;


  void yyerror (const char *str)
  {
    fprintf (stderr, "error: %s\n", str);
  }

  int yywrap ()
  {
    return 1;
  }


  main ()
  {

    /*Initialize lists */
    writeslist = NULL;
    portlist = NULL;;
    signalslist = NULL;
    sensibilitylist=NULL;
    processlist=NULL;
    instanceslist = NULL;
    enumlistlist = NULL;

    translate = 1;

    fprintf(stderr,"\nSystemC to Verilog Translator v0.3\n\n");
	fprintf(stderr,"Parsing header file.......\n\n");
	
    yyparse ();


    printf ("module %s(", module_name);
    EnumeratePorts (portlist);
    printf (");\n");


    ShowPortList (portlist);
    printf ("\n");
    RegOutputs (portlist);
    printf ("\n");


    ShowEnumListList (enumlistlist);

    writeslist=ReadWritesFile (writeslist,(char *) "file_writes.sc2v");

    ShowSignalsList (signalslist);
    printf ("\n");

    ShowInstancedModules (instanceslist);
    printf ("\n");

    ShowDefines ((char *) "file_defines.sc2v");

    ShowProcessCode (processlist);
    printf ("\n");

    printf ("endmodule\n");

	fprintf(stderr,"\nDone\n");
  }

%}

%token NUMBER SC_MODULE WORD OPENPAR CLOSEPAR SC_IN SC_OUT SEMICOLON BOOL ENUM 
%token MENOR MAYOR SC_INT SC_UINT SC_METHOD SENSITIVE_POS SENSITIVE_NEG SENSITIVE 
%token SENSIBLE CLOSEKEY OPENKEY SEMICOLON COLON SC_SIGNAL ARROW EQUALS NEW QUOTE 
%token SC_CTOR VOID ASTERISCO TRANSLATEON TRANSLATEOFF 

%% commands:	/* empty */
|commands command;

command:
module
  |
  in_bool
  |
  in_sc_int
  |
  in_sc_uint
  |
  out_bool
  |
  out_sc_int
  |
  out_sc_uint
  |
  sc_method
  |
  sensitive_pos
  |
  sensitive_neg
  |
  sensitive
  |
  sensible_word_colon
  |
  sensible_word_semicolon
  |
  sensible_par_colon
  |
  sensible_par_pos
  |
  sensible_par_neg
  |
  closekey
  |
  word_semicolon
  |
  word_colon
  |
  word_closekey
  |
  word_closekey_word
  |
  signal_bool
  |
  signal_uint
  |
  signal_int
  |
  instantation
  |
  port_binding
  |
  sc_ctor
  |
  void
  |
  inst_decl
  |
  closekey_semicolon
  |
  enumerates
  |
  enumerates_type
  |
  declaration
  |
  declaration_sc_signal
  |
  multiple_declaration
  | 
  multiple_sc_signal_declaration 
  | 
  translateoff 
  | 
  translateon;


module:
SC_MODULE OPENPAR WORD CLOSEPAR OPENKEY
{

  if (translate == 1)
    {

      if (module_name_found)

	{

	  fprintf (stderr, "error: two or more modules found in the file\n");

	  exit (1);

	}

      else

	{

	  module_name = (char *) malloc (256 * sizeof (char));

	  strcpy (module_name, (char *) $3);

	  module_name_found = 1;

	}
    }

}

;



in_sc_uint:
SC_IN MENOR SC_UINT MENOR NUMBER MAYOR MAYOR
{

  if (translate == 1)
    {

      activeport = 1;

      lastportsize = $5;

      lastportkind = (char *) "input";

    }

};



in_sc_int:
SC_IN MENOR SC_INT MENOR NUMBER MAYOR MAYOR
{

  if (translate == 1)
    {

      activeport = 1;

      lastportsize = $5;

      lastportkind = (char *) "input";

    }

};




in_bool:
SC_IN MENOR BOOL MAYOR
{

  if (translate == 1)
    {

      activeport = 1;

      lastportsize = 0;

      lastportkind = (char *) "input";

    }

};



signal_bool:
SC_SIGNAL MENOR BOOL MAYOR
{

  if (translate == 1)
    {

      signalactive = 1;

      lastsignalsize = 0;

    }

};



signal_uint:
SC_SIGNAL MENOR SC_UINT MENOR NUMBER MAYOR MAYOR
{

  if (translate == 1)
    {

      signalactive = 1;

      lastsignalsize = $5;

    }

};



signal_int:
SC_SIGNAL MENOR SC_INT MENOR NUMBER MAYOR MAYOR
{

  if (translate == 1)
    {

      signalactive = 1;

      lastsignalsize = $5;

    }

};



out_bool:
SC_OUT MENOR BOOL MAYOR
{

  if (translate == 1)
    {

      activeport = 1;

      lastportsize = 0;

      lastportkind = (char *) "output";

    }

};



out_sc_uint:
SC_OUT MENOR SC_UINT MENOR NUMBER MAYOR MAYOR
{

  if (translate == 1)
    {

      activeport = 1;

      lastportsize = $5;

      lastportkind = (char *) "output";

    }

};



out_sc_int:
SC_OUT MENOR SC_INT MENOR NUMBER MAYOR MAYOR
{

  if (translate == 1)
    {

      activeport = 1;

      lastportsize = $5;

      lastportkind = (char *) "output";

    }

};



sc_method:
SC_METHOD OPENPAR WORD CLOSEPAR SEMICOLON
{

  if (translate == 1)
    {

      if (method_found)

	{

	  processlist=InsertProcess (processlist, active_method, sensibilitylist,
			 active_method_type);
      
	}

      active_method = (char *) $3;

      method_found = 1;

      /* New sensitivity list */
      sensibilitylist = NULL;
      
    }

};



sensible_par_neg:
SENSITIVE_NEG OPENPAR WORD CLOSEPAR SEMICOLON
{

  if (translate == 1)
    {

      active_method_type = (char *) "seq";	//comb
      sensibilitylist=InsertSensibility (sensibilitylist, (char *) $3, "negedge");

    }

};



sensible_par_pos:
SENSITIVE_POS OPENPAR WORD CLOSEPAR SEMICOLON
{

  if (translate == 1)
    {

      active_method_type = (char *) "seq";	//comb
      sensibilitylist=InsertSensibility (sensibilitylist, (char *) $3, "posedge");

    }

};



sensitive_pos:
SENSITIVE_POS
{

  if (translate == 1)
    {

      last_sensibility = (char *) "posedge";

      active_method_type = (char *) "seq";	//seq
      sensibility_active = 1;

    }

};



sensitive_neg:
SENSITIVE_NEG
{

  if (translate == 1)
    {

      last_sensibility = (char *) "negedge";

      active_method_type = (char *) "seq";	//seq
      sensibility_active = 1;

    }

};



sensitive:
SENSITIVE
{

  if (translate == 1)
    {

      last_sensibility = (char *) " ";

      active_method_type = (char *) "comb";	//comb
      sensibility_active = 1;

    }

};



sensible_par_colon:
SENSITIVE OPENPAR WORD CLOSEPAR SEMICOLON
{

  if (translate == 1)
    {

      active_method_type = (char *) "comb";	//comb
      sensibilitylist=InsertSensibility (sensibilitylist, (char *) $3, " ");

    }

};




sensible_word_colon:
SENSIBLE WORD
{

  if (translate == 1)
    {

      sensibilitylist=InsertSensibility (sensibilitylist, (char *) $2,
			 (char *) last_sensibility);

    }

};



sensible_word_semicolon:
SENSIBLE WORD SEMICOLON
{

  if (translate == 1)
    {

      sensibilitylist=InsertSensibility (sensibilitylist, (char *) $2,
			 (char *) last_sensibility);

      if (sensibility_active)

	{

	  sensibility_active = 0;

	}

    }

};

closekey:
CLOSEKEY
{

  if (translate == 1)
    {

      if (method_found)

	{

	  method_found = 0;

	  processlist=InsertProcess (processlist, active_method, sensibilitylist,
			 active_method_type);

	}

    }

};



word_semicolon:
WORD SEMICOLON
{

  if (translate == 1)
    {

      if (activeport)

	{

	  portlist=InsertPort (portlist,(char *) $1, lastportkind, lastportsize);

	  activeport = 0;

	}

      else if (signalactive)

	{

	  signalslist=InsertSignal (signalslist,(char *) $1, lastsignalsize);

	  signalactive = 0;

	}
      else if (multipledec)
	{

	  int length, list_pos;

	  length = 0;

	  list_pos = 0;

	  //Look in the enumerated list if it was declared e.j state_t state;
	  list_pos = findEnumList (enumlistlist, storedtype);

	  if (list_pos > -1)
	    {

	      //Calculate the number of bits needed to represent the enumerate
	      length = findEnumerateLength (enumlistlist, list_pos);


	      signalslist=InsertSignal (signalslist,(char *) $1, length);

	      writeslist=InsertWrite (writeslist,(char *) $1);

	      free (storedtype);

	      multipledec = 0;

	    }
	  else
	    {

	      fprintf (stderr, "\nType %s unknow\n", (char *) $1);

	      return (1);

	    }

	}

    }

};



word_colon:
WORD COLON
{

  if (translate == 1)
    {

      if (activeport)

	{

	  portlist=InsertPort (portlist,(char *) $1, lastportkind, lastportsize);

	}

      else if (signalactive)

	{

	  signalslist=InsertSignal (signalslist,(char *) $1, lastsignalsize);

	}

      else if (reading_enumerates)

	{

	  enumerateslist=InsertEnumerates (enumerateslist, (char *) $1);


	}
      else if (multipledec)
	{

	  int length, list_pos;

	  length = 0;

	  list_pos = 0;

	  //Look in the enumerated list if it was declared e.j state_t state;
	  list_pos = findEnumList (enumlistlist, storedtype);

	  if (list_pos > -1)
	    {

	      //Calculate the number of bits needed to represent the enumerate
	      length = findEnumerateLength (enumlistlist, list_pos);


	      signalslist=InsertSignal (signalslist,(char *) $1, length);

	      writeslist=InsertWrite (writeslist,(char *) $1);

	      multipledec = 1;

	    }
	  else
	    {

	      fprintf (stderr, "\nType %s unknow\n", (char *) $1);

	      return (1);

	    }

	}

    }

};



word_closekey_word:
WORD CLOSEKEY WORD SEMICOLON
{

  if (translate == 1)
    {

      //Finish enumerate var declaration
      if (reading_enumerates)

	{

	  enumerateslist=InsertEnumerates (enumerateslist, (char *) $1);

	  enumlistlist=InsertEnumList (enumlistlist, enumerateslist, (char *) $4, 0);	//Insert also the variable name
	  reading_enumerates = 0;

	}

    }

};



word_closekey:
WORD CLOSEKEY SEMICOLON
{

  if (translate == 1)
    {

      //Finish enumerate type declaration
      if (reading_enumerates)

	{

	  enumerateslist=InsertEnumerates (enumerateslist, (char *) $1);

	  enumlistlist=InsertEnumList (enumlistlist, enumerateslist, enumname, 1);	//Insert also the variable name
	  reading_enumerates = 0;

	}

    }

};




instantation:
WORD EQUALS NEW WORD OPENPAR QUOTE WORD QUOTE CLOSEPAR SEMICOLON
{

  if (translate == 1)
    {

      instanceslist=InsertInstance (instanceslist, (char *) $1, (char *) $4);

    }

};



port_binding:
WORD ARROW WORD OPENPAR WORD CLOSEPAR SEMICOLON
{

  if (translate == 1)
    {

      if (instanceslist == NULL){
  	     fprintf (stderr, "error: no instances found\n");
  	  }else{
      
	    InstanceNode *ill;
        SGLIB_LIST_MAP_ON_ELEMENTS (InstanceNode, instanceslist, ill, next,
        {		
		    if (strcmp (ill->nameinstance, (char *) $1) == 0){
               ill->bindslist=InsertBind (ill->bindslist, (char *) $3, (char *) $5);
			   break;
			}
	    }
		);
    }

   }
};


sc_ctor:
SC_CTOR OPENPAR WORD CLOSEPAR OPENKEY
{


};


void:VOID WORD OPENPAR CLOSEPAR SEMICOLON
{


};


inst_decl:
WORD ASTERISCO WORD SEMICOLON
{


};



closekey_semicolon:CLOSEKEY SEMICOLON
{


};



enumerates:
ENUM OPENKEY
{

  if (translate == 1)
    {

      //New enumerate list
      enumerateslist = NULL;

      reading_enumerates = 1;

    }

};



enumerates_type:
ENUM WORD OPENKEY
{

  if (translate == 1)
    {

      //In this case we define type e.g. enum state_t {S0,S1,S2};
      enumerateslist = NULL;

      enumname = (char *)malloc (sizeof (char) * strlen ((char *) $2));

      strcpy (enumname, (char *) $2);

      reading_enumerates = 1;

    }

};



declaration:
WORD WORD SEMICOLON
{

  if (translate == 1)
    {

      int length, list_pos;

      length = 0;

      list_pos = 0;

      //Look in the enumerated list if it was declared e.j state_t state;
      list_pos = findEnumList (enumlistlist, (char *) $1);

      if (list_pos > -1)
	{

	  //Calculate the number of bits needed to represent the enumerate
	  length = findEnumerateLength (enumlistlist, list_pos);


	  signalslist=InsertSignal (signalslist,(char *) $2, length);

	  writeslist=InsertWrite (writeslist,(char *) $2);

	}
      else
	{

	  fprintf (stderr, "\nType %s unknow\n", (char *) $1);

	  return (1);

	}

    }

};



declaration_sc_signal:
SC_SIGNAL MENOR WORD MAYOR WORD SEMICOLON
{

  if (translate == 1)
    {

      int length, list_pos;

      length = 0;

      list_pos = 0;

      //Look in the enumerated list if it was declared e.j state_t state;
      list_pos = findEnumList (enumlistlist, (char *) $3);

      if (list_pos > -1)
	{

	  //Calculate the number of bits needed to represent the enumerate
	  length = findEnumerateLength (enumlistlist, list_pos);


	  signalslist=InsertSignal (signalslist,(char *) $5, length);

	  writeslist=InsertWrite (writeslist,(char *) $5);	  

	}
      else
	{

	  fprintf (stderr, "\nType %s unknow\n", (char *) $3);

	  return (1);

	}

    }

};



multiple_declaration:
WORD WORD COLON
{

  if (translate == 1)
    {

      int length, list_pos;

      length = 0;

      list_pos = 0;

      //Look in the enumerated list if it was declared e.j state_t state;
      list_pos = findEnumList (enumlistlist, (char *) $1);

      if (list_pos > -1)
	{

	  //Calculate the number of bits needed to represent the enumerate
	  length = findEnumerateLength (enumlistlist, list_pos);

	  storedtype = (char *)malloc (sizeof (char) * strlen ((char *) $1));

	  strcpy (storedtype, (char *) $1);

	  signalslist=InsertSignal (signalslist,(char *) $2, length);

	  writeslist=InsertWrite (writeslist,(char *) $2);

	  multipledec = 1;

	}
      else
	{

	  fprintf (stderr, "\nType %s unknow\n", (char *) $1);

	  return (1);

	}

    }

};



multiple_sc_signal_declaration:
SC_SIGNAL MENOR WORD MAYOR WORD COLON
{

  if (translate == 1)
    {
      int length, list_pos;
      length = 0;
      list_pos = 0;

      //Look in the enumerated list if it was declared e.j state_t state;
      list_pos = findEnumList (enumlistlist, (char *) $3);

      if (list_pos > -1)
  	  {

	  //Calculate the number of bits needed to represent the enumerate
	  length = findEnumerateLength (enumlistlist, list_pos);

	  storedtype = (char *)malloc (sizeof (char) * strlen ((char *) $3));

	  strcpy (storedtype, (char *) $3);

	  signalslist=InsertSignal (signalslist,(char *) $5, length);

	  writeslist=InsertWrite (writeslist,(char *) $5);

	  multipledec = 1;

	}
      else
	{

	  fprintf (stderr, "\nType %s unknow\n", (char *) $3);

	  return (1);

	}

    }

};



translateoff:
TRANSLATEOFF
{

  translate = 0;

  fprintf (stderr, "Found Translate off directive \n");

};



translateon:
TRANSLATEON
{

  translate = 1;

  fprintf (stderr, "Found Translate on directive \n");

};
