%{
#include "calculadora.h"
#include <math.h>
int n_lineas;
bool real;
bool errSemantic;
%}

%option noyywrap
 

digito [0-9]
entero {digito}+
real {entero}[.]{entero}

true [Tt][Rr][Uu][Ee]
false [Ff][Aa][Ll][Ss][Ee]

%%
[Ss][Aa][Ll][Ii][Rr]	return SALIR;
{true}              yylval.c_bool = true; return BOOL;
{false}             yylval.c_bool = false; return BOOL;

[<][=]              return MENORI;
[>][=]              return MAYORI;
[=][=]              return IGUAL;
[!][=]              return DISTINTO;
[|][|]              return OR;
[&][&]              return AND;

[a-zA-Z_][a-zA-Z0-9_]* strcpy(yylval.c_cadena, yytext);return ID;
{real}              yylval.c_real = atof(yytext);return REAL;
{entero}			yylval.c_entero = atoi(yytext);return ENTERO;



\n				    n_lineas++; return (yytext[0]);
[\t ]			    ;	 //no quitar nada más 
. 				    return (yytext[0]);
%%

