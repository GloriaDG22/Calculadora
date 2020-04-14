%{
#include "expresiones.h"
#include <math.h>
int n_lineas;
%}

%option noyywrap
 

digito [0-9]
entero {digito}+
real {entero}[.]{entero}

%%
[Ss][Aa][Ll][Ii][Rr]	return SALIR;
[a-zA-Z_][a-zA-Z0-9_]* strcpy(yylval.c_cadena, yytext);return ID;
{real}              yylval.c_real = atof(yytext);return REAL;
{entero}			yylval.c_entero = atoi(yytext);return ENTERO;
\n				n_lineas++; return (yytext[0]);
[\t =]			;	 //no quitar nada más 
. 				return (yytext[0]);
%%

