//**********************************************************************************************
//****************   Francisco Javier Melchor González & Gloria Díaz González   ****************
//**********************************************************************************************

#ifndef  TABLASIMBOLOS_H_
#define TABLASIMBOLOS_H_

#include "listapi.h"
#include <cstring>
#include <iostream>
#include <stdio.h>

using namespace std;

typedef char * tipo_cadena;

union tipo_valor{
    int valor_entero;
    float valor_real;
    bool valor_boolean;
    tipo_cadena valor_cad;
};

struct simbolo {
    string nombre;
    int tipo;
    tipo_valor valor;
};

class tablaSimbolos {
private:
    ListaPI<simbolo> *tabla;
    int tam;
public:
    tablaSimbolos();
    void insertar (simbolo s);
    int getSize ();
    bool buscar (tipo_cadena nombreSimbolo, simbolo &s);
    simbolo get(int i);
    void pintarTabla(FILE *yyout);
    virtual ~tablaSimbolos();
};

#endif /* TABLASIMBOLOS_H_ */
