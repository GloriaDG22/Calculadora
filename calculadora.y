//**********************************************************************************************
//****************   Francisco Javier Melchor González & Gloria Díaz González   ****************
//**********************************************************************************************

%{
#include <iostream>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "tablaSimbolos.h"

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;
extern bool real;
extern bool errSemantic;
extern int yylex();
extern FILE *yyin;
int tipoDato = 0;
/* VARIABLE TIPODATO
* entero (variable) 0
* real (variable) 1
* lógico (variable) 2
* cadena de caracteres (variable) 3
* procedimiento 4
*  clase 5
*/
tablaSimbolos *t = new tablaSimbolos();

//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
      if(errSemantic)
            cout << "Error semántico en la línea "<< n_lineas;
      else{
            cout << "Error sintáctico en la línea "<< n_lineas << ". " <<endl;
            n_lineas++;
      }

} 

void iniciarParam(){
      real=false;
      errSemantic=false; //0=false, 1=true
}

void salida(FILE *yyout){
      t->pintarTabla(yyout);
}

string tipoVar(int tipo){
      string tipoAux;
      switch(tipo){
            case 0:
                  tipoAux = "entero";
                  break;
            case 1:
                  tipoAux = "real";
                  break;
            case 2:
                  tipoAux = "bool";
                  break;
            case 3:
                  tipoAux = "cadena";
                  break;
      }
      return tipoAux;
}

%}

//Prioridad lógica
%left '|' '&'
%right '!'

//Prioridad aritmética
%left '+' '-'   /* asociativo por la izquierda, misma prioridad */
%left '*' '/' '%'   /* asociativo por la izquierda, prioridad alta */
%right '^'        /* asociativo por la derecha, prioridad superior */

%left menos

%union{
int c_entero;
float c_real;
char c_cadena[20];
bool c_bool;
}

%start entrada
%type <c_real> exprArit expresion
%token <c_entero> ENTERO 
%token <c_real> REAL
%token <c_cadena> ID

%type <c_bool> exprLog comp
%token <c_bool> BOOL

%token MENORI MAYORI IGUAL DISTINTO OR AND

%%
entrada: 		            { iniciarParam();}
      | entrada linea         { iniciarParam();}
      | entrada linea '\n'    {n_lineas++; iniciarParam();}
      | error entrada '\n'    {yyerrok; iniciarParam();} 
      ;

linea: ID '=' expresion       {if (!errSemantic){
                                    simbolo s;
                                    if(!t->buscar($1,s)){ //Se añadide una nueva variable
                                          s.nombre = $1;
                                          s.tipo = tipoDato;
                                    }
                                    if(tipoDato != s.tipo){ //ERROR se ha cambiado el tipo de la variable
                                          errSemantic = true;
                                          yyerror(" ");
                                          cout<<", la variable "<<$1<<" es de tipo "<< tipoVar(s.tipo) <<" y no se le puede asignar un valor "<< tipoVar(tipoDato) <<endl;
                                    } else{ // Se cambiambia el valor de la variable
                                          if(tipoDato == 0){             //entero
                                                s.valor.valor_entero = $3;
                                          }else if(tipoDato == 1){        //real
                                                s.valor.valor_real = $3;
                                          }else {
                                                if ($3 == 0){             //logico
                                                      s.valor.valor_boolean = false;
                                                }else{
                                                      s.valor.valor_boolean = true;  
                                                }
                                          }          
                                    }
                                    t->insertar(s);
                                    } 
                                    iniciarParam();
                                    }
      ;

expresion: exprArit	      {$$=$1;}
            | exprLog	      {$$=$1; tipoDato=2;}
            ;

exprArit: '-' exprArit %prec menos    {$$= -$2;}
      | '(' exprArit ')'            {$$=$2;}                  
      | exprArit '+' exprArit       {$$=$1+$3;}              
      | exprArit '-' exprArit       {$$=$1-$3;}            
      | exprArit '*' exprArit       {$$=$1*$3;} 
      | exprArit '/' exprArit       {if(real){
                                          $$=(float)($1/$3);
                                          real=false;
                                    } 
                                    else 
                                          $$=(int)($1/$3);
                                    }
      | exprArit '%' exprArit       {if(!real){
                                          $$=(int)$1%(int)$3;
                                    }else {
                                          errSemantic = true;
                                          yyerror(" ");
                                          cout<< ", el operador % no se puede usar con datos de tipo real."<<endl;
                                    }}
      | exprArit '^' exprArit       {$$=pow($1, $3);}
      | ENTERO 		            {$$=$1; tipoDato = 0;}  
      | REAL                        {real=true; tipoDato=1; $$=$1; }
      | ID                          {simbolo s;
                                    if(t->buscar ($1,s)){
                                          if(s.tipo == 0){
                                                $$ = s.valor.valor_entero;
                                                tipoDato = 0;
                                          } else if (s.tipo == 1){
                                                $$ = s.valor.valor_real;
                                                real = true;
                                                tipoDato = 1;
                                          } else{//ERROR: variable logica en op aritmeticas
                                                errSemantic = true;
                                                yyerror(" ");
                                                cout<<", no se pueden realizar operaciones aritméticas con variables de tipo lógico"<<endl;
                                          }
                                          } else{//ERROR: variable no definida
                                                errSemantic = true; 
                                                yyerror(" ");
                                                cout<<", la variable con nombre " << $1 << " no ha sido definida"<<endl;
                                          } 
                                    }
      ;

comp: exprArit '<' exprArit           {$$=$1<$3;}
      | exprArit MENORI exprArit      {$$=$1<=$3;}
      | exprArit '>' exprArit         {$$=$1>$3;}
      | exprArit MAYORI exprArit      {$$=$1>=$3;}
      | exprArit IGUAL exprArit       {$$=$1==$3;}
      | exprArit DISTINTO exprArit    {$$=$1!=$3;}
      ;

exprLog: comp                  {$$=$1;}
      | '('exprLog ')'        {$$=$2;}                 
      | exprLog OR exprLog    {$$=$1||$3;}
      | exprLog AND exprLog   {$$=$1&&$3;}
      | '!' exprLog           {$$=!$2;}
      | BOOL                  {$$=$1;}
      ;

%%

int main(int argc, char *argv[] ){     
	if (argc != 3) 
		cout <<"Error: debe introducir el fichero de entrada.y salida"<<endl;
	else {
            FILE *yyout;
     		yyin=fopen(argv[1],"r");
            yyout=fopen(argv[2],"wt");

            n_lineas = 1;
            iniciarParam();
            yyparse();
            salida(yyout);

            fclose (yyin);
            fclose (yyout);
         	return 0;
	}
}
