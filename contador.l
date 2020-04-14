%{
/*
 *      Este programa cuenta el número de caracteres, palabras y líneas
 *      que hay en un texto
 */

#include <iostream>
using namespace std;

int n_caracteres, n_palabras, n_lineas, n_entero, n_real, palabra, n_cient, n_reserved, id, blanco;      /* variables globales: contadores */
int i;
void combertirMayus();
void contChar();
%}

%option noyywrap

digito [0-9]
letra [a-zA-Z]
caracter [a-zA-Z0-9]
identificador {letra}{caracter}*
entero {digito}+
real {entero}[.]{entero}

%%

\n   {n_lineas++;    //la primera regla detecta el fin de una línea e incrementa el contador de las líneas
		REJECT;}

["][^"]*["] {printf("CAD");
			contChar();} //cadenas de caracteres (texto encerrado entre dobles comillas)

 
{real}|{entero}[.]|[.]{entero}  {n_real++; 
		contChar();
		printf("REAL");} //números reales con notacioin clasica 5.5 y sin parte entera (.7) o parte decimal (5.)

 
{real}e[+]{entero} {n_cient++;
					contChar();}	//números reales con notación científica (5.7e+8)


 /*
 *PALABRAS RESEVADAS
 */
[gG][lL][oO][rR][iI][aA] {palabra++;
							contChar();}


[A-Za-z]+ {n_palabras++;  // detecta una palabra e incrementa 
			contChar();
			REJECT;}     //los contadores de palabras y caracteres


[m][a][i][n] {n_reserved++;
				combertirMayus();}

[i][n][t] {n_reserved++;
			combertirMayus();}

[f][l][o][a][t] {n_reserved++;
				combertirMayus();}

[f][o][r] {n_reserved++;
			combertirMayus();}

[c][o][u][t] {n_reserved++;
				combertirMayus();}

[e][n][d][l] {n_reserved++;
				combertirMayus();}

[a-zA-Z_][a-zA-Z0-9_]* {id++;
						printf("ID");}	//identificador más _ (palabras que pueden tener letras, dígitos y _, pero no pueden comenzar por un dígito)


{entero} {n_entero++;
		 contChar();
		 printf("ENTERO");}


 /*
 * //[] {} //líneas con información
 */


[ ]|\n|\t {blanco++;
			ECHO;}	 //lineas en blanco

 /*
*PARA EL PROYECTO!!!!! Los espacios en blanco puede ser cualquier combinacion entre espacio, tabulador, enter y comentarios
*/
 
%% 
int main(){
	n_caracteres = 0;   //inicialización de los contadores
	n_palabras = 0;
	n_lineas = 0;
  	
	yylex();    //llamada al analizador léxico
  	
	cout <<endl<<"Caracteres= "<< n_caracteres<<endl;    //se muestra el valor de los contadores tras el proceso
  	cout <<"Palabras= "<< n_palabras<<endl;
  	cout <<"Líneas= "<< n_lineas<<endl;
	cout <<"Enteros= "<< n_entero<<endl;
	cout <<"Real= "<< n_real<<endl;
	cout <<"Palabra 'Gloria'= "<< palabra<<endl;
	cout <<"Notaciones científicas= "<< n_cient<<endl;
	cout <<"Palabras reservadas= " << n_reserved<<endl;
	cout <<"Identificadores= " << id<<endl;
	cout <<"Espacios en blanco= "<< blanco<<endl;
  	
  	return 0;  
}

void combertirMayus(){
	for (i = 0; yytext[i]; i++)
    	yytext[i] = putchar(toupper(yytext[i]));
}

void contChar(){
	n_caracteres = n_caracteres + yyleng;
}
