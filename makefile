FILE_LEX = lexico.l
EXE_LEX = lexico
PARAM = entrada.txt salida.txt
G_COMP = g++
LEX = flex

ejecucion: $(EXE_LEX)
	@./$(EXE_LEX) $(PARAM)
	@echo El fichero de salida se ha creado correctamente

$(EXE_LEX): lex.yy.c
	$(G_COMP) -o$(EXE_LEX) lex.yy.c

lex.yy.c: $(FILE_LEX)
	$(LEX) $(FILE_LEX)


