#fichero Makefile

OBJ = calculadora.o lexico.o tablaSimbolos.o

calculadora : $(OBJ)     #segunda fase de la tradicción. Generación del código ejecutable 
	g++ -ocalculadora $(OBJ)

calculadora.o : calculadora.c        #primera fase de la traducción del analizador sintáctico
	g++ -c -ocalculadora.o  calculadora.c 
	
lexico.o : lex.yy.c		#primera fase de la traducción del analizador léxico
	g++ -c -olexico.o  lex.yy.c 	

calculadora.c : calculadora.y       #obtenemos el analizador sintáctico en C
	bison -d -ocalculadora.c calculadora.y

lex.yy.c: lexico.l	#obtenemos el analizador léxico en C
	flex lexico.l

clean : 
	rm  -f  *.c *.o 
