%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex();
%}

%token IDENTI NOMBRE FLECHE DIEZE APOS
%start AXI

%%
AXI : INST AXI | INST ;
INST : AFFECT DIEZE {return printf("=== Instruction recconue ===\n");}

AFFECT : IDENTI FLECHE NOMBRE | IDENTI FLECHE APOS IDENTI APOS ;
%%

void yyerror(char *s){
    printf("Erreur Syntaxique : %s \n", s);
}

int main (){
    printf("\n === Analyse terminee avec succes ! === \n");
    return yyparse();
}
