

contador : lex.yy.c
	g++ lex.yy.c   

lex.yy.c : contador.l 
	flex  contador.l
