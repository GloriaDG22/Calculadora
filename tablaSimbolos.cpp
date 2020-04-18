//**********************************************************************************************
//****************   Francisco Javier Melchor González & Gloria Díaz González   ****************
//**********************************************************************************************

#include <iostream>
#include "tablaSimbolos.h"
#include "listapi.h"

using namespace std;

tablaSimbolos::tablaSimbolos(){
    tabla = new ListaPI <simbolo>();
    tam = 0;
}

void tablaSimbolos::insertar(simbolo s){
    bool enc = false;
    simbolo saux;
    if (!tabla->estaVacia()){
        tabla->moverInicio();
        while(!tabla->finLista() && !enc){
            tabla->consultar(saux);
            //si encontramos un símbolo con el mismo nombre, significará que ya tenemos el símbolo almacenado y tendremos que cambiar solo el valor de este
            if(saux.nombre==s.nombre){
                enc = true;
                tabla->borrar();
                tabla->insertar(s);
            } else tabla->avanzar();
        } if (!enc){ //si no lo encontramos lo almacenamos al final de la lista
            tabla->insertar(s);
            tam++;
        }
    } else {
        tabla -> insertar(s);
        tam++;
    }
}

int tablaSimbolos::getSize(){
    return tam;
}

bool tablaSimbolos::buscar(tipo_cadena nombreSimbolo, simbolo &s){
    bool enc = false;
    simbolo saux;
    if (!tabla->estaVacia()){
        tabla->moverInicio();
        while(!tabla->finLista() && !enc){
            tabla->consultar(saux);
            if(saux.nombre == nombreSimbolo){
                enc = true;
                s = saux;
            } else tabla->avanzar();
        }
    }
    return enc;
}

simbolo tablaSimbolos::get(int i){
    int j = 0;
    simbolo saux;
    bool enc = false;
    if (!tabla->estaVacia()){
        tabla->moverInicio();
        for (int j=0; j < tam && !enc; j++){
            if (j == i){
                tabla->consultar(saux);
                enc = true;
            }
            tabla->avanzar();
        }
    }
    return saux;
}

void tablaSimbolos::pintarTabla(FILE *yyout){
    simbolo s;
    tabla->moverInicio();
    fprintf(yyout, " ___________________________\n");
    fprintf(yyout, "|Nombre	 |Tipo 	  |Valor    |\n");
    fprintf(yyout, "|---------------------------|\n");
    while(!tabla->finLista()){
		tabla->consultar(s);
        const char * nombre = s.nombre.c_str();
		if(s.tipo==0) fprintf(yyout, "|%s 	 |entero  |%d        |\n", nombre, s.valor.valor_entero);
		else if(s.tipo==1) fprintf(yyout, "|%s	 |real    |%f|\n", nombre, s.valor.valor_real);
        else if (s.tipo==3) fprintf(yyout, "|%s	 |cadena  |%s  |\n", nombre, s.valor.valor_cad);
        else if (s.tipo==2 && s.valor.valor_boolean==true)  fprintf(yyout, "|%s	 |bool    |True     |\n", nombre);
        else if (s.tipo==2 && s.valor.valor_boolean==false)  fprintf(yyout, "|%s	 |bool    |False    |\n", nombre);
        tabla->avanzar();
  	}
    fprintf(yyout, "|___________________________|\n" );
}
tablaSimbolos::~tablaSimbolos(){
}


