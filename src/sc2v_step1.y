/* -----------------------------------------------------------------------------
 *
 *  SystemC to Verilog Translator v0.2
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

/* Global var to store Regs */
RegsList *regslist;
/* Global var to store Defines */
DefinesList *defineslist;


int processfound = 0;
int switchfound = 0;
int switchparenthesis = 0;
char *processname, *processname2;
char *fileregs;
char *filename ;
int openedkeys = 0;
int newline = 0;
int reg_found = 0;
int regs_end;
int i = 0; //for loops counter
FILE *file;
FILE *regs_file;
char *regname, *regname2;
char *lastword; // Stores last WORD for use it in WRITE
char *file_defines;
FILE *FILE_DEFINES;
char *file_writes;
FILE *FILE_WRITES; //FILE to store .write to know if it is a wire or reg
int definefound = 0;
int defineinvocationfound = 0;
int opencorchfound = 0; 

int openedcase = 0;

int default_break_found = 0;
int default_found;

//Directives variables
int translate;
int verilog;
int writemethod;

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
	regslist = (RegsList *)malloc(sizeof(RegsList));
	InitializeRegsList(regslist);
	defineslist = (DefinesList *)malloc(sizeof(DefinesList));
	InitializeDefinesList(defineslist);
		
	processname = (char *)malloc(256*sizeof(int));
	processname2 = (char *)malloc(256*sizeof(int));
	fileregs = (char *)malloc(256*sizeof(int));
	
	file_defines = (char *)malloc(256*sizeof(int));
	strcpy(file_defines, (char *)"file_defines.sc2v");
	FILE_DEFINES = fopen(file_defines,(char *)"w");
	
	file_writes = (char *)malloc(256*sizeof(int));
	strcpy(file_writes, (char *)"file_writes.sc2v");	
	FILE_WRITES = fopen(file_writes,(char *)"w");

        if(FILE_WRITES!=NULL)
	  printf("\nopening file => filename = %s\n",file_writes);
  
        lastword=malloc(sizeof(char)*256);

        translate=1;
	verilog=0;
	writemethod=0;
	
	yyparse();
	fclose(FILE_WRITES);
	fclose(FILE_DEFINES);
}

%}

%token NUMBER WORD SC_INT SC_UINT BOOL BIGGER LOWER OPENKEY CLOSEKEY WRITE WORD SYMBOL NEWLINE ENUM INCLUDE
%token COLON SEMICOLON RANGE OPENPAR CLOSEPAR TWODOUBLEPOINTS OPENCORCH CLOSECORCH SWITCH CASE DEFAULT BREAK
%token SC_BIGINT SC_BIGUINT HEXA DEFINE READ TRANSLATEOFF TRANSLATEON VERILOGBEGIN VERILOGEND TAB DOLLAR INTCONV
%token VOID TTRUE TFALSE
%token PIFDEF PENDDEF PELSE

%%

commands: /* empty */
	| commands command
	;


command:
    voidword
	|
    include
	|
    dollar
	|
	intconv
	|
	tab
	|
	read
	|
	sc_int
	|
	sc_uint
	|
	sc_bigint
	|
	sc_biguint
	|
	number
	|
	bool
	|
	word
	|
	symbol
	|
	write
	|
	newline
	|
	openkey
	|
	closekey
	|
	colon
	|
	semicolon
	|
	range
	|
	openpar
	|
	closepar
	|
	void
	|
	opencorch
	|
	closecorch
	|
	bigger
	|
	lower
	|
	switch
	|
	case_only
	|
    case_number
	|
	case_word
	|
	case_default
	|
	break
	|
	hexa
	|
	define
	|
	translateoff
	|
	translateon
	|
	verilogbegin
	|
	verilogend
	|
	ifdef
	|
	endif
	|
	pelse
	|
	ttrue
	|
	tfalse
	;

 

voidword:
    VOID
	{
	if(verilog==1)
	  fprintf(file," void");
	};

	
include:
    INCLUDE
	{
	if(verilog==1)
	  fprintf(file," #include");
	};


dollar:
    DOLLAR
	{
	if(verilog==1)
	  fprintf(file," $");
	};

intconv:
    INTCONV
	{
	if(verilog==1)
	  fprintf(file," (int)");
	};

tab:
    TAB
	{
	if(verilog==1)
	  fprintf(file," \t");
	};
	
read:
	READ OPENPAR CLOSEPAR
		{
		if(verilog==1)
		  fprintf(file,".read()");
		
		}

define: 
	DEFINE WORD OPENPAR CLOSEPAR
		{
		  if(translate==1 && verilog==0){
			InsertDefine(defineslist, (char *)$2);
			definefound = 1;
			fprintf(FILE_DEFINES,"`define %s ",(char *)$2);
		  }else if(verilog==1)
		    fprintf(file,"#define %s ()",(char *)$2);
		}
void:
	WORD TWODOUBLEPOINTS WORD OPENPAR CLOSEPAR
		{
		if(translate==1&& verilog==0){
			strcpy(processname ,(char *)$4);
			strcpy(processname2 ,(char *)$4);
			strcat(processname2, (char *)".sc2v");
			strcpy(fileregs ,(char *)$4);
			strcat(fileregs, (char *)"_regs.sc2v");
			/*
			strcpy(file_writes, (char *)$4);
			strcat(file_writes, (char *)"_writes.sc2v");
			*/					
		}else if(verilog==1)
		  fprintf(file," %s::%s()",(char *)$1,(char *)$3);
		  
		}
sc_int:
	SC_INT LOWER NUMBER BIGGER
		{
        if(translate==1&& verilog==0){		
			if(processfound)
			{
				fprintf(regs_file,"reg[%d:0] ",(-1 + $3));
				reg_found = 1;				
			}
		}else if(verilog==1)
		  fprintf(file,"sc_int<%d>",$3);
		  
		}
		;

sc_uint:
	SC_UINT LOWER NUMBER BIGGER
		{
		if(translate==1&& verilog==0){
			if(processfound)
			{
				fprintf(regs_file,"reg[%d:0] ",(-1 + $3));
				reg_found = 1;
			}
		}else if(verilog==1)
		  fprintf(file,"sc_uint<%d>",$3);
		}
		;
		
sc_bigint:
	SC_BIGINT LOWER NUMBER BIGGER
		{
		if(translate==1&& verilog==0){
			if(processfound)
			{
				fprintf(regs_file,"reg[%d:0] ",(-1 + $3));
				reg_found = 1;
			}
		}else if(verilog==1)
		 fprintf(file,"sc_bigint<%d> ",$3);
		}
		;

sc_biguint:
	SC_BIGUINT LOWER NUMBER BIGGER
		{
		if(translate==1&& verilog==0){
			if(processfound)
			{
				fprintf(regs_file,"reg[%d:0] ",(-1 + $3));
				reg_found = 1;
			}
		}else if(verilog==1)
		  fprintf(file,"sc_biguint<%d> ",$3);
		}
		;

bool:
		BOOL
			{
		    if(translate==1&& verilog==0){			
				if(processfound)
				{
					fprintf(regs_file,"reg ");
					reg_found = 1;
				}
			}else if(verilog==1)
		       fprintf(file,"bool");
			}
			;

range:
		RANGE OPENPAR NUMBER COLON NUMBER CLOSEPAR
			{
		    if(translate==1&& verilog==0){			
				if(processfound)
					fprintf(file,"[%d:%d]",$3,$5);
				else if(definefound)
					fprintf(FILE_DEFINES,"[%d:%d]",$3,$5);					
			}else if(verilog==1)
		      fprintf(file,".range(%d,%d)",$3,$5);
			}
			;
			
number:
		NUMBER
			{
			if(translate==1&& verilog==0){
				if(processfound)
					if(reg_found)
					{
					    if(opencorchfound)
						fprintf(regs_file,"%d:0", -1 + $1);
					    else
						fprintf(regs_file,"%d",$1);
					}
				  	else
				     		fprintf(file,"%d",$1);
				else if(definefound)
					fprintf(FILE_DEFINES,"%d",$1);				   
			}else if(verilog==1)
		       fprintf(file,"%d",$1);
			}
			;
word:
		WORD
			{
		    if(translate==1&& verilog==0){			
			  if(processfound)
			  {
			     if(openedcase)
			     {	
			     	fprintf(file," :\n");
				    
		  		    for(i = 0; i < openedkeys; i++)
					    fprintf(file,"   ");
										  
				    fprintf(file,"begin\n");
				    openedcase = 0;
			     }	
		
                      	     strcpy(lastword, (char *)$1);
			     
			     if(reg_found)
			     {
			
			      regname=malloc(sizeof(char)*(strlen((char *)$1)+1));
      			      regname2=malloc(sizeof(char)*(strlen((char *)$1)+strlen(processname))+1);
		      
			      strcpy(regname ,(char *)$1);
 	                      strcpy(regname2 ,(char *)$1);
			      strcat(regname2, processname);
			      fprintf(regs_file,"%s",regname2);
			      InsertReg(regslist, regname, regname2);			      
			      free(regname);
			      free(regname2);
			     }
			     else 
			     {
			       if(newline)
				   {
				   for(i = 0; i < openedkeys; i++)
					 fprintf(file,"   ");
			 	   }
				   regname2 = IsReg(regslist, (char *)$1);
				   if(regname2 == NULL)
				   {
					 if(IsDefine(defineslist, (char *)$1))
					 {
					   fprintf(file,"`%s", (char *)$1);
					   defineinvocationfound = 1;
					 }
					 else
					 {
					   fprintf(file,"%s ",(char *)$1);
					 }
				   }
				   else
					 fprintf(file,"%s",regname2);
					 
				   newline = 0;
			     }
			     
			  }
			  else if(definefound)
			  {
			  	if(IsDefine(defineslist, (char *)$1))
				{
					fprintf(FILE_DEFINES,"`%s",(char *)$1);
				}
				else
				{
					fprintf(FILE_DEFINES,"%s ",(char *)$1);
				}
			  }
			}else if(verilog==1)
		       fprintf(file," %s",(char *)$1);
		    };

symbol:
		SYMBOL
			{
			if(translate==1&& verilog==0){
				if(processfound)
				{
				   if(reg_found)
				   	fprintf(regs_file,"%s",(char *)$1);
				   else
					fprintf(file,"%s",(char *)$1);
				}
				else if(definefound)
				{
				   fprintf(FILE_DEFINES,"%s",(char *)$1);
				}
			}else if(verilog==1)
		       fprintf(file,"%s",(char *)$1);
			};

			
write:
		WRITE
			{
			if(translate==1&& verilog==0){
                                writemethod=1;			
				if(processfound)
				{
					fprintf(file," = ");
					fprintf(FILE_WRITES, "%s\n", lastword);
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES," = ");
				}
				
			}else if(verilog==1){
			    fprintf(file,".write");
			 }
			};

newline:
		NEWLINE
			{
		    if(translate==1&& verilog==0){
				if(processfound & !reg_found & !openedcase)
				{
					fprintf(file,"\n");
					newline = 1;
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"\n");
				}
		
			}else if(verilog==1)
		       fprintf(file,"\n");
			};

colon:
		COLON 
			{
			if(translate==1&& verilog==0){
				if(processfound)
				{  
				  if(reg_found)
				  {
				  	fprintf(regs_file,",");					
				  }
				  else
				  	fprintf(file,",");					
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,",");
				}
			}else if(verilog==1)
		       fprintf(file,",");
			};

semicolon:
		SEMICOLON
			{
		    if(translate==1&& verilog==0){
				if(processfound)
				{  
				  if(reg_found)
				  {
				  	fprintf(regs_file,";\n");
					reg_found = 0;
				  }
				  else if(defineinvocationfound)
				  {
				  	defineinvocationfound = 0;
				  }
				  else
				  {
				  	fprintf(file,";");
				  }					
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,";");
				}
			}else if(verilog==1)
		       fprintf(file,";");
			};

openpar:
		OPENPAR 
			{
            if(translate==1 && verilog==0){
				if(processfound)
				{
					fprintf(file,"(");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"(");
				}
			}else if(verilog==1)
		       fprintf(file,"(");
			};
			
closepar:
		CLOSEPAR
			{
		    if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,")");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,")");
				}
			}else if(verilog==1)
		       fprintf(file,")");
			};

opencorch:
		OPENCORCH
			{
			if(translate==1&& verilog==0){
				if(processfound)
				{
				  if(reg_found)
				  {
				  	fprintf(regs_file,"[");
					opencorchfound = 1;
				  }
				  else
					fprintf(file,"[");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"[");
					
				}
			}else if(verilog==1)
		       fprintf(file,"[");
			};
			
closecorch:
		CLOSECORCH
			{
		    if(translate==1&& verilog==0){
				if(processfound)
				{
				  if(reg_found)
				  {
				  	fprintf(regs_file,"]");
					opencorchfound = 0;
				  }
				  else
					fprintf(file,"]");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"]");
				}
			}else if(verilog==1)
		       fprintf(file,"]");
			};
			
			
openkey:
		OPENKEY
			{
		    if(translate==1 && verilog==0){
				openedkeys++;
				if(openedkeys==1 & !definefound)
				{
					printf("opening file => filename = %s\n",processname2);
					file = fopen(processname2,(char *)"w");
					printf("opening file => filename = %s\n",fileregs);
					regs_file = fopen(fileregs,(char *)"w");					
					processfound = 1;
					regslist = (RegsList *)malloc(sizeof(RegsList));
					InitializeRegsList(regslist);
			/*		regname = (char *)malloc(256*sizeof(int));
					regname2 = (char *)malloc(256*sizeof(int));*/
				}
				if(processfound)
					if(openedkeys != switchparenthesis)
					{	
					    fprintf(file,"\n");
						for(i = 0; i < openedkeys; i++)
							fprintf(file,"   ");
						fprintf(file,"begin\n");
						newline = 1;
					}
			
			}else if(verilog==1)
		       fprintf(file,"{");
			}
			;

closekey:
		CLOSEKEY
			{
            if(translate==1&& verilog==0){
				if(processfound)
				{
					if(openedkeys==switchparenthesis & switchfound == 1)
					{
						fprintf(file,"\n");
						if(default_found & !default_break_found)
						{
						for(i = 0; i < openedkeys; i++)
							fprintf(file,"   ");
						fprintf(file,"end\n");
						default_found = 0;
						}
						for(i = 0; i < openedkeys; i++)
							fprintf(file,"   ");
						fprintf(file,"endcase\n");
						newline = 1;
						switchfound = 0;
						switchparenthesis = 0;
					}
					else
					{
						fprintf(file,"\n");
						for(i = 0; i < openedkeys; i++)
							fprintf(file,"   ");
						fprintf(file,"end\n");
						newline = 1;
					}	
				}
				
				openedkeys--;
				if(definefound)
				{
					definefound = 0;
					fprintf(FILE_DEFINES,"\n//Dummy Comment\n");
				}
				else if(openedkeys==0)
				{
					fclose(file);
					fclose(regs_file);
					free(regslist);
/*					free(regname);
					free(regname2);*/
					processfound = 0;
				}
			}else if(verilog==1)
		       fprintf(file,"}");
			};


bigger:
		BIGGER
			{
            if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,">");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,">");
				}
			}else if(verilog==1)
		       fprintf(file,">");
			};

lower:
		LOWER
			{
			if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,"<");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"<");
				}
			}else if(verilog==1)
		       fprintf(file,"<");
			};
			

switch:
		SWITCH
			{
			if(translate==1&& verilog==0){
			  if(processfound)
				{
					fprintf(file,"\n");
					for(i = 0; i < openedkeys; i++)
						fprintf(file,"   ");
					fprintf(file,"case");
					switchfound = 1;
					switchparenthesis = openedkeys + 1;
				}
			}else if(verilog==1)
		       fprintf(file,"switch");
			};
		
case_number:
		CASE NUMBER SYMBOL
			{
			if(translate==1&& verilog==0){
			  if(processfound)
			  {
			  	for(i = 0; i < openedkeys; i++)
					fprintf(file,"   ");
				if(openedcase)
					fprintf(file,", %d",$2);
				else
					fprintf(file,"%d",$2);

				newline = 1;
				openedcase = 1;
				
			  }
			}else if(verilog==1)
		       fprintf(file,"case %d %s",$2,(char *)$3);
			};
case_word:
		CASE WORD SYMBOL
			{
			if(translate==1&& verilog==0){
			  if(processfound)
			  {
			  	for(i = 0; i < openedkeys; i++)
					fprintf(file,"   ");
				if(openedcase)
					fprintf(file,", %s",(char *)$2);
				else
					fprintf(file,"%s",(char *)$2);
				
				newline = 1;
				openedcase = 1;
				
			  }
			}else if(verilog==1)
		       fprintf(file,"case %s %s",(char *)$2,(char *)$3);
			};
		
case_default:
		DEFAULT SYMBOL
			{
			if(translate==1&& verilog==0){
			  if(processfound)
			  {
				for(i = 0; i < openedkeys; i++)
					fprintf(file,"   ");
				fprintf(file,"default:\n");
				for(i = 0; i < openedkeys; i++)
					fprintf(file,"   ");
				fprintf(file,"begin\n");
				newline = 1;
				default_found = 1;
			  }
			}else if(verilog==1)
		       fprintf(file,"default %s",(char *)$2);
			};			

case_only:
        CASE OPENPAR
		{
		//This rule occurs when in Verilog mode a case appears
		if(verilog==1)
		  fprintf(file,"case(");
        };

break:
		BREAK SEMICOLON
			{
			if(translate==1&& verilog==0){
			 if(processfound)
			 {
				if(newline == 0)
					fprintf(file,"\n");
				for(i = 0; i < openedkeys; i++)
					fprintf(file,"   ");
				fprintf(file,"end\n");
				if(default_found)
					{
						default_break_found = 1;
					}
			 }
			}else if(verilog==1)
		       fprintf(file,"break;");
			};

hexa:
		HEXA
			{
		    if(translate==1&& verilog==0){
			if(processfound)
			{
				fprintf(file,"'h");
			}
			else if(definefound)
			{
				fprintf(FILE_DEFINES,"'h");
			}
			}else if(verilog==1)
		       fprintf(file,"0x");
			};
			
translateoff:
        TRANSLATEOFF
		{
		  translate=0;
		  fprintf(stderr,"Found Translate off directive \n");
        };

translateon:
        TRANSLATEON
		{
		  translate=1;
		  fprintf(stderr,"Found Translate on directive \n");
        };
		
verilogbegin:
        VERILOGBEGIN
		{
		  verilog=1;
 		  fprintf(stderr,"Found Verilog Begin directive \n");
        };

verilogend:
        VERILOGEND
		{
		  verilog=0;
		  fprintf(stderr,"Found Verilog End directive \n");
        };

ifdef:
       PIFDEF
	   {
            if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,"`ifdef");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"`ifdef");
				}
			}else if(verilog==1)
		       fprintf(file,"#ifdef");
			};
endif:
       PENDDEF
	   {
            if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,"`endif");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"`endif");
				}
			}else if(verilog==1)
		       fprintf(file,"#endif");
			};
pelse:
       PELSE
	   {
            if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,"`else");
				}
				else if(definefound)
				{
					fprintf(FILE_DEFINES,"`else");
				}
			}else if(verilog==1)
		       fprintf(file,"#else");
			};
ttrue:
      TTRUE
	  {
	        if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,"1");
				}
			}else if(verilog==1)
		       fprintf(file,"1");
			};


tfalse:
      TFALSE
	  {
	        if(translate==1&& verilog==0){
				if(processfound)
				{
					fprintf(file,"0");
				}
			}else if(verilog==1)
		       fprintf(file,"0");
			};
