/* -----------------------------------------------------------------------------
 *
 *  SystemC to Verilog Translator v0.1
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

#include "list.h"


/*Global var to read from file_writes.sc2v*/
WritesList *writeslist;

/*Global var to store ports*/
PortList *portlist;

/* Global var to store signals*/
SignalsList *signalslist;

/* Global var to store sensitivity list*/
SensibilityList *sensibilitylist;

/* Global var to store instantiated modules*/
InstancesList *instanceslist;

/* Global var to store process list*/
ProcessList *processlist;


/* Global var to store process module name*/
char *module_name;
int module_name_found = 0;

/* Global var to store last port type*/
char *lastportkind;
int lastportsize;
int activeport = 0;	// 1 -> reading port list

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




	
void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
	return 1;
}

main()
{	
	writeslist = (WritesList *)malloc(sizeof(WritesList));
	InitializeWritesList(writeslist);
	portlist = (PortList *)malloc(sizeof(PortList));
	InitializePortList(portlist);
	signalslist = (SignalsList *)malloc(sizeof(SignalsList));
	InitializeSignalsList(signalslist);
	sensibilitylist = (SensibilityList *)malloc(sizeof(SensibilityList));
	InitializeSensibilityList(sensibilitylist);
	instanceslist = (InstancesList *)malloc(sizeof(InstancesList));
	InitializeInstancesList(instanceslist);
	processlist = (ProcessList *)malloc(sizeof(ProcessList));
	InitializeProcessList(processlist);
	
			
	yyparse();
	printf("module %s(",module_name);
	EnumeratePorts(portlist);
	printf(");\n");
	
	ShowPortList(portlist);
	printf("\n");
	RegOutputs(portlist);
	printf("\n");
		
	ReadWritesFile(writeslist, (char *)"file_writes.sc2v");
			
	ShowSignalsList(signalslist, writeslist);
	printf("\n");
	
	ShowInstancedModules(instanceslist);
	printf("\n");
	
	ShowDefines((char *)"file_defines.sc2v");
	
	ShowProcessCode(processlist);
	printf("\n");
	
	printf("endmodule\n");
}

%}

%token NUMBER SC_MODULE WORD OPENPAR CLOSEPAR SC_IN SC_OUT SEMICOLON BOOL 
%token MENOR MAYOR SC_INT SC_UINT SC_METHOD SENSITIVE_POS SENSITIVE_NEG SENSITIVE 
%token SENSIBLE CLOSEKEY OPENKEY SEMICOLON COLON SC_SIGNAL ARROW EQUALS NEW QUOTE
%token SC_CTOR VOID ASTERISCO

%%

commands: /* empty */
	| commands command
	;


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
	closekey
	|
	word_semicolon
	|
	word_colon
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
	;

module:
	SC_MODULE OPENPAR WORD CLOSEPAR OPENKEY
	{	
		if(module_name_found)
			{
			fprintf(stderr,"error: two or more modules found in the file\n");
			exit(1);
			}
		else
			{
			module_name = (char *)malloc(256*sizeof(char));
			strcpy(module_name, (char *)$3);
			module_name_found = 1;
			}
	}
	;

in_sc_uint:
	SC_IN MENOR SC_UINT MENOR NUMBER MAYOR MAYOR
	{
		activeport = 1;
		lastportsize = $5;
		lastportkind = (char *)"input";
	}
	;

in_sc_int:
	SC_IN MENOR SC_INT MENOR NUMBER MAYOR MAYOR
	{
		activeport = 1;
		lastportsize = $5;
		lastportkind = (char *)"input";
	}
	;


in_bool:
	SC_IN MENOR BOOL MAYOR
	{
		activeport = 1;
		lastportsize = 0;
		lastportkind = (char *)"input";		
	}
	;

signal_bool:
		SC_SIGNAL MENOR BOOL MAYOR
		{
			signalactive = 1;
			lastsignalsize = 0;
		}
		;
signal_uint:
		SC_SIGNAL MENOR SC_UINT MENOR NUMBER MAYOR MAYOR
		{
			signalactive = 1;
			lastsignalsize = $5;
		}
		;
signal_int:
		SC_SIGNAL MENOR SC_INT MENOR NUMBER MAYOR MAYOR
		{
			signalactive = 1;
			lastsignalsize = $5;
		}
		;
		
out_bool:
	SC_OUT MENOR BOOL MAYOR
	{
		activeport = 1;
		lastportsize = 0;
		lastportkind = (char *)"output";
	}
	;

out_sc_uint:
	SC_OUT MENOR SC_UINT MENOR NUMBER MAYOR MAYOR
	{
		activeport = 1;
		lastportsize = $5;
		lastportkind = (char *)"output";
	}
	;

out_sc_int:
	SC_OUT MENOR SC_INT MENOR NUMBER MAYOR MAYOR
	{
		activeport = 1;
		lastportsize = $5;
		lastportkind = (char *)"output";
	}
	;

sc_method:
	SC_METHOD OPENPAR WORD CLOSEPAR SEMICOLON
	{
		if(method_found)
			{
			InsertProcess(processlist, active_method, sensibilitylist, active_method_type);			
			}
		active_method = (char *)$3;
		method_found = 1;
		/* New sensitivity list */
		sensibilitylist = (SensibilityList *)malloc(sizeof(SensibilityList));
		InitializeSensibilityList(sensibilitylist);
	}	
	;
	
sensitive_pos:
	SENSITIVE_POS
	{
		last_sensibility = (char *)"posedge";
		active_method_type = (char *)"seq"; //seq
		sensibility_active = 1;
	}
	;
	
sensitive_neg:
	SENSITIVE_NEG
	{
		last_sensibility = (char *)"negedge";
		active_method_type = (char *)"seq"; //seq
		sensibility_active = 1;	
	}
	;
	
sensitive:
	SENSITIVE
	{
		last_sensibility = (char *)" ";	
		active_method_type = (char *)"comb"; //comb
		sensibility_active = 1;
	}
	;
sensible_word_colon:
	SENSIBLE WORD
	{
		InsertSensibility(sensibilitylist, (char *)$2, (char *)last_sensibility);
	}
	;

sensible_word_semicolon:	
	SENSIBLE WORD SEMICOLON
	{
		InsertSensibility(sensibilitylist, (char *)$2, (char *)last_sensibility);
		if(sensibility_active)
			{
			sensibility_active = 0;
			}
	}
	;

closekey:
	CLOSEKEY
	{
		if(method_found)
			{
			method_found = 0;
			InsertProcess(processlist, active_method, sensibilitylist, active_method_type);
			}
	}
	;
word_semicolon:
	WORD SEMICOLON
	{
			if(activeport)
			{
				InsertPort(portlist, (char *)$1, lastportkind, lastportsize);
				activeport = 0;
			}
			else if(signalactive)
			{
				InsertSignal(signalslist, (char *)$1, lastsignalsize);
				signalactive = 0;
			}
	}
	;

word_colon:
		WORD COLON
		{
			if(activeport)
			{
				InsertPort(portlist, (char *)$1, lastportkind, lastportsize);
			}
			else if(signalactive)
			{
				InsertSignal(signalslist, (char *)$1, lastsignalsize);				
			}
		}
		;

instantation:
		WORD EQUALS NEW WORD OPENPAR QUOTE WORD QUOTE CLOSEPAR SEMICOLON
		{
			InsertInstance(instanceslist, (char *)$1, (char *)$4);
		}
		;
		
port_binding:
		WORD ARROW WORD OPENPAR WORD CLOSEPAR SEMICOLON
		{										
			if(instanceslist->last == NULL)
			{
				fprintf(stderr,"error: no instances found\n");
			}
			else
			{
				InstanceNode *aux;
				aux = instanceslist->first;
				while(1)
				{
					if(strcmp(aux->nameinstance, (char *)$1) == 0)
					{
						break;
					}
					else
					{
						if(aux->next == NULL)
						{
							fprintf(stderr,"error: instance %s not found\n",$1);
							exit(1);
						}
						else
						{
							aux = aux->next;
						}
					}
				}
				InsertBind(aux->bindslist, (char *)$3, (char *)$5);
			}
		}
		;

sc_ctor:
		SC_CTOR OPENPAR WORD CLOSEPAR OPENKEY
		{
		
		}
		;
		
void:
		VOID WORD OPENPAR CLOSEPAR SEMICOLON
		{
		
		}
		;
		
inst_decl:
		WORD ASTERISCO WORD SEMICOLON
		{
		
		}
		;
		
closekey_semicolon:	CLOSEKEY SEMICOLON
		{
		
		}
		;
