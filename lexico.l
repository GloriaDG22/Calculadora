%{
#include "expresiones.h"
#include <math.h>
int n_lineas;
%}

%option noyywrap
 
%%
[Ss][Aa][Ll][Ii][Rr]	return SALIR;
[a-zA-Z_][a-zA-Z0-9_]* ;
[0-9]+			yylval = atoi(yytext);return NUMERO;
\n				n_lineas++; return (yytext[0]);
[\t =]			;	 //no quitar nada más 
. 				return (yytext[0]);
%%

