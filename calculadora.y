%{
#include <iostream>
#include <stdio.h>
#include <math.h>
 

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;
extern bool real;
extern bool errSemantic;
extern int yylex();

//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
      if(errSemantic)
            cout << "Error semántico en la línea "<< n_lineas << ". ";
      else
            cout << "Error sintáctico en la línea "<< n_lineas << ". " <<endl;

} 

void iniciarParam(){
      real=false;
      errSemantic=false;
}

void prompt(){
      iniciarParam();
  	cout << "LISTO> ";     
}

%}

%start entrada

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

%token SALIR 
%type <c_real> expr
%token <c_entero> ENTERO 
%token <c_real> REAL
%token <c_cadena> ID

%type <c_bool> exprLog comp
%token <c_bool> BOOL

%token MENORI MAYORI IGUAL DISTINTO OR AND

%%
entrada: 		{prompt();}
      |entrada linea
      ;
linea: ID '=' expr '\n'	      {if (!errSemantic){
                                    cout << "La instruccion "<<n_lineas<< " hace que la variable "<< $1 <<", de tipo";
				            if(real){
					            cout<<" real,";
					            real = false;
				            }else{
					            cout<<" entero,";
				            }
                                    cout<<" tenga el valor "<<$3<<endl;
                                    prompt();
                                    }
                              else
                                    prompt();
                              }

      |ID '=' exprLog	'\n'	{cout << "La instruccion "<<n_lineas<< " hace que la variable "<< $1 <<", de tipo lógico, tenga el valor ";
			            if($3==0)
				            cout<<"falso."<<endl;
			            else
				            cout<<"verdadero."<<endl;
			            prompt();
			            }

      |error   '\n'           {yyerrok; prompt();} // pensar el lugar apropiado para colocarlo, controlar hasta donde tiene el error}
      
      |SALIR      '\n'        {return(0);	}    
     ;

expr: ENTERO 		      {$$=$1;}  
      | REAL                  {real=true; $$=$1; }
      | '-' expr %prec menos  {$$= -$2;}
      | '(' expr ')'          {$$=$2;}                  
      | expr '+' expr         {$$=$1+$3;}              
      | expr '-' expr         {$$=$1-$3;}            
      | expr '*' expr         {$$=$1*$3;} 
      | expr '/' expr         {if(real){
                                    $$=(float)($1/$3);
                                    real=false;
                              } 
                              else 
                                    $$=(int)($1/$3);
                              }
      | expr '%' expr         {if(!real){
                                    $$=(int)$1%(int)$3;
                              }else {
                                    errSemantic = true;
                                    yyerror(" ");
                                    cout<< "El operador % no se puede usar con datos de tipo real."<<endl;
                              }}
      | expr '^' expr         {$$=pow($1, $3);}
      ;

comp: expr '<' expr           {$$=$1<$3;}
      | expr MENORI expr      {$$=$1<=$3;}
      | expr '>' expr         {$$=$1>$3;}
      | expr MAYORI expr      {$$=$1>=$3;}
      | expr IGUAL expr       {$$=$1==$3;}
      | expr DISTINTO expr    {$$=$1!=$3;}
      ;

exprLog: BOOL                 {$$=$1;}
      | comp                  {$$=$1;}
      | '('exprLog ')'        {$$=$2;}                 
      | exprLog OR exprLog    {$$=$1||$3;}
      | exprLog AND exprLog   {$$=$1&&$3;}
      | '!' exprLog              {$$=!$2;}
      ;

%%

int main(){
     
     n_lineas = 0;
     real = false;
     errSemantic=false;
     
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
