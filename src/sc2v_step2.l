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
#include "y.tab.h"

extern int yylval;

int includefound = 0;
int linecomment = 0;
int multilinecomment = 0;
%}

%%
"\t"                    /* ignore whitespace */
" "                     /* ignore whitespace */
[0-9]+                  if(!includefound & !linecomment & !multilinecomment) {
                           yylval=atoi(yytext); 
                           return NUMBER;
                         }	
SC_MODULE               if(!includefound & !linecomment & !multilinecomment) return SC_MODULE;
SC_METHOD               if(!includefound & !linecomment & !multilinecomment) return SC_METHOD;
SC_CTOR	                if(!includefound & !linecomment & !multilinecomment) return SC_CTOR;
"void"                  if(!includefound & !linecomment & !multilinecomment) return VOID;
sensitive_pos           if(!includefound & !linecomment & !multilinecomment) return SENSITIVE_POS;
sensitive_neg           if(!includefound & !linecomment & !multilinecomment) return SENSITIVE_NEG;
sensitive               if(!includefound & !linecomment & !multilinecomment) return SENSITIVE;
"<<"                    if(!includefound & !linecomment & !multilinecomment) return SENSIBLE;
sc_in                   if(!includefound & !linecomment & !multilinecomment) return SC_IN;
sc_out                  if(!includefound & !linecomment & !multilinecomment) return SC_OUT;
sc_signal               if(!includefound & !linecomment & !multilinecomment) return SC_SIGNAL;
"bool"                  if(!includefound & !linecomment & !multilinecomment) return BOOL;
"<"                     if(!includefound & !linecomment & !multilinecomment) return MENOR;
">"                     if(!includefound & !linecomment & !multilinecomment) return MAYOR;
sc_int                  if(!includefound & !linecomment & !multilinecomment) return SC_INT;
sc_uint	                if(!includefound & !linecomment & !multilinecomment) return SC_UINT;
sc_bigint               if(!includefound & !linecomment & !multilinecomment) return SC_INT;
sc_biguint              if(!includefound & !linecomment & !multilinecomment) return SC_UINT;
\(                      if(!includefound & !linecomment & !multilinecomment) return OPENPAR;
\)                      if(!includefound & !linecomment & !multilinecomment) return CLOSEPAR;
;                       if(!includefound & !linecomment & !multilinecomment) return SEMICOLON;
"enum"                  if(!includefound & !linecomment & !multilinecomment) return ENUM;
","                     if(!includefound & !linecomment & !multilinecomment) return COLON;
"{"                     if(!includefound & !linecomment & !multilinecomment) return OPENKEY;
"}"                     if(!includefound & !linecomment & !multilinecomment) return CLOSEKEY;
"->"                    if(!includefound & !linecomment & !multilinecomment) return ARROW;
"="                     if(!includefound & !linecomment & !multilinecomment) return EQUALS;
"new"                   if(!includefound & !linecomment & !multilinecomment) return NEW;
"\""                    if(!includefound & !linecomment & !multilinecomment) return QUOTE;
[a-zA-Z][a-z_A-Z0-9]*   if(!includefound & !linecomment & !multilinecomment) {
                           yylval=(int)strdup(yytext); 
                           return WORD;
                        }
"*"                     if(!includefound & !linecomment & !multilinecomment) return ASTERISCO;
"\n"                    includefound = 0; linecomment = 0;
"$"                     /* ignore */
"."                     /* ignore */
":"                     /* ignore */
"#include"              includefound = 1;
"//"                    linecomment = 1;
"/*"                    multilinecomment = 1;
"*/"                    multilinecomment = 0;
"/"                     /* ignore */
"-"
"#"                   
"@"
"|"
"~"

"//"[ ]*[tT][rR][aA][nN][sS][lL][aA][tT][eE][ ]*[oO][fF][fF]  return TRANSLATEOFF;  /*Translate directive*/
"//"[ ]*[tT][rR][aA][nN][sS][lL][aA][tT][eE][ ]*[oO][nN]      return TRANSLATEON;  /*Translate directive*/
%%
