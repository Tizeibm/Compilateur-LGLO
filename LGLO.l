%{
  #include <stdlib.h>
  #include "LGLO.tab.h"

  void yyerror(char *s);
%}

%option noyywrap
%option yylineno

%%
"var"   {return VAR; }
"const"   { return CONST; }
"lire"    { return LIRE; }
"ecrire"  { return ECRIRE; }
"si"      { return SI; }
"alors"   { return ALORS; }
"sinon"   { return SINON; }
"sinonsi" { return SINONSI; }
"finsi"   { return FINSI; }
"tantque" { return TANTQUE; }
"faire"   { return FAIRE; }
"fintantque"  { return FINTANTQUE; }
"pour"    { return POUR; }
"finpour" { return FINPOUR; }
"fonction"  { return FONCTION; }
"finfon"    { return FINFON; }
"procedure" { return PROCEDURE; }
"finproc"   { return FINPROC; }
"retourner" { return RETOURNER; }

"<--"   { return FLECHE; }
"<>"    { return PASEGAL; }
"=="    { return EQUIVAL; }
">"     { return SUP; }
">="    { return SUPEGAL; }
"<"     { return INF; }
"<="    { return INFEGAL; }
"#"     { return DIEZE; }
"'"     { return APOS; }
"("     { return PAROUV; }
")"     { return PARFERM; }

[0-9]+  { return NOMBRE; }
[a-zA-Z][a-zA-Z0-9_]*    { return IDENTI; }  

[ \t\n] {               } 
.   { printf("Erreur lexical : '%s' ligne %d\n", yytext, yylineno); }
%%
