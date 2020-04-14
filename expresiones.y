%{
#include <iostream>
 

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;
extern int yylex();

//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
	cout << "Error en la línea "<< n_lineas<<endl;	
} 

void prompt(){
  	cout << "LISTO> ";
}

%}

%start entrada

%left '+' '-'   /* asociativo por la izquierda, misma prioridad */
%left '*' '/'   /* asociativo por la izquierda, prioridad alta */
 
%left menos

%union{
int c_entero;
float c_real;
char c_cadena[20];
}

%type <c_real> expr
%token SALIR 
%token <c_entero> ENTERO 
%token <c_real> REAL
%token <c_cadena> ID

%%
entrada: 		{prompt();}
      |entrada linea
      ;
linea: ID expr '\n'	       {cout << "A la variable " << $1 <<" se le ha asignado el valor "<< $2 <<endl; prompt();}	
      |expr    '\n'        {cout << "El resultado es " << $1 <<endl; prompt();}	
      |error   '\n'        {yyerrok; prompt();} // pensar el lugar apropiado para colocarlo,
      // controlar hasta donde tiene el error
      |SALIR 	'\n'        {return(0);	}    
     ;

expr:    ENTERO 		     {$$=$1;}  
       | REAL                 {$$=$1;}                  
       | expr '+' expr 		{$$=$1+$3;}              
       | expr '-' expr    	{$$=$1-$3;}            
       | expr '*' expr        {$$=$1*$3;} 
       | expr '/' expr        {$$=$1/$3;} 
       |'-' expr %prec menos  {$$= -$2;}
       | '(' expr ')'         {$$=$2;}
       ;

%%

int main(){
     
     n_lineas = 0;
     
     cout <<endl<<"******************************************************"<<endl;
     cout <<"*      Calculadora de expresiones aritméticas        *"<<endl;
     cout <<"*                                                    *"<<endl;
     cout <<"*      1)con el prompt LISTO>                        *"<<endl;
     cout <<"*        teclea una expresión, por ej. 1+2<ENTER>    *"<<endl;
     cout <<"*        Este programa indicará                      *"<<endl;
     cout <<"*        si es gramaticalmente correcto              *"<<endl;
     cout <<"*      2)para terminar el programa                   *"<<endl;
     cout <<"*        teclear SALIR<ENTER>                        *"<<endl;
     cout <<"*      3)si se comete algun error en la expresión    *"<<endl;
     cout <<"*        se mostrará un mensaje y la ejecución       *"<<endl;
     cout <<"*        del programa finaliza                       *"<<endl;
     cout <<"******************************************************"<<endl<<endl<<endl;
     yyparse();
     cout <<"****************************************************"<<endl;
     cout <<"*                 ADIOS!!!!                        *"<<endl;
     cout <<"****************************************************"<<endl;
     return 0;
}
