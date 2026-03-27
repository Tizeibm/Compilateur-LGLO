%{
  #include <stdlib.h>
  #include "LGLO.tab.h"

  void yyerror(char *s);
%}

%option noyywrap
%option yylineno

%%
[0-9]*  { return NOMBRE; }
[a-zA-Z][a-zA-Z0-9_]*    { return IDENTI; }  
"<--"   { return FLECHE; }
"#"     { return DIEZE; }
"'"     { return APOS; }
[ \t\n] {               }
.   { printf("Erreur lexical : %s ligne %d\n", yytext, yylineno); }

%%

