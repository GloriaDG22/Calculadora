%{

#include <iostream>
using namespace std;

 //variables
int contLinea = 1;

 //funciones
void combertirMayus();

%}

%option noyywrap

digito [0-9]
entero {digito}+
real {entero}[.]{entero}

%x COMMENT1 COMMENT2

%%
"//"				BEGIN(COMMENT1);
<COMMENT1>"\n" 		{BEGIN(0); ECHO; contLinea++; fprintf(yyout, "%d", contLinea);}
"/*"				BEGIN(COMMENT2);
<COMMENT2>[*/][\t ]*\n		BEGIN(0);
<COMMENT1,COMMENT2>.	;
<COMMENT1>"\n"		ECHO;
<COMMENT2>"\n"		;	
		

["][^"]*["] {fprintf(yyout, "TEXTO");}

^[\t ]*\n ;

\n   {contLinea++;
		fprintf(yyout, "\n%d", contLinea);
		REJECT;
		}
		
 /*
 *PALABRAS RESEVADAS
 */
main {combertirMayus();} 

int {combertirMayus();}

float {combertirMayus();}

for {combertirMayus();}

cout {combertirMayus();}

endl {combertirMayus();}

return {combertirMayus();}

[a-zA-Z_][a-zA-Z0-9_]* {fprintf(yyout, "ID");}	//identificador más _ (palabras que pueden tener letras, dígitos y _, pero no pueden comenzar por un dígito)


{entero} {fprintf(yyout, "ENTERO");}


{real}e[+]{entero} {fprintf(yyout, "CIENTIFICO");					}	//números reales con notación científica (5.7e+8)


{real}|{entero}[.]|[.]{entero}  {fprintf(yyout, "REAL");} //números reales con notacioin clasica 5.5 y sin parte entera (.7) o parte decimal (5.)

\n ;

%%
int main(int argc, char *argv[]){

	if(argc > 2){
		yyin = fopen(argv[1], "rt");
 		yyout = fopen(argv[2], "wt");
		
		fprintf(yyout, "%d", contLinea);

		yylex();    //llamada al analizador léxico
	}else{
		printf("Debes añadir los ficheros de entrada y salida.\n");
	}
	fclose(yyin);
	fclose(yyout);
  	return 0;  
}

void combertirMayus(){
	int i;
	for (i = 0; yytext[i]; i++)
    	yytext[i] = toupper(yytext[i]);
	
	fprintf(yyout, "%s", yytext);
}