%{
  #include <stdlib.h>
  #include <string.h> 
  #include "LGLO.tab.h"

  int line_number = 1;           
  int column_number = 1;         

  #define YY_USER_ACTION \
    yylloc.first_line = line_number; \
    yylloc.first_column = column_number; \
    yylloc.last_line = line_number; \
    yylloc.last_column = column_number + yyleng - 1; \
    column_number += yyleng;

  void yyerror(const char *msg);
%}

%option noyywrap
%option yylineno

%%
"var"   {return VAR; }
"list"   { return LIST; }
"dict"   { return DICT; }
"const"   { return CONST; }
"lire"    { return LIRE; }
"ecrire"  { return ECRIRE; }
"si"      { return SI; }
"sinon"   { return SINON; }
"tantque" { return TANTQUE; }
"pour"    { return POUR; }
"sinonsi" { return SINONSI; }
"fonction"  { return FONCTION; }
"procedure" { return PROCEDURE; }
"retourner" { return RETOURNER; }
"," { return VIRGULE; }

"&&"    { return ET; }
"||"    { return OU; }
"et"    { return ET; }
"ou"    { return OU; }


"<--"   { return FLECHE; }
"<>"    { return PASEGAL; }
"=="    { return EQUIVAL; }
"="     { return EGAL; }
">"     { return SUP; }
">="    { return SUPEGAL; }
"<"     { return INF; }
"<="    { return INFEGAL; }
"#"     { return DIEZE; }
"'"     { return APOS; }
"("     { return PAROUV; }
")"     { return PARFERM; }
"{"     { return ACCOUV; }
"}"     { return ACCFERM; }
"["     { return CROUV; }
"]"     { return CROFERM; }
":"     { return DEUX_POINTS; }

"+"     { return PLUS; }
"-"     { return MOINS; }
"*"     { return FOIS; }
"/"     { return DIVISE; }
"%"     { return MODULO; }
"^"     { return PUISSANCE; }

"++"  { return INCR; }
"--"  { return DECR; }



[0-9]+(\.[0-9]+)?  { yylval.num = atof(yytext); return NOMBRE; }
"'"[^"'"\n]*"'" { yylval.str = strdup(yytext); return STRING; }
[a-zA-Z][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTI; } 

[//].*  { } 

[ \t] { } 

\n  {
      line_number++;
      column_number = 1;
  }

. { fprintf(stderr, "   ERREUR LEXICAL\n");
    fprintf(stderr, "   Ligne: %d\n", line_number);
    fprintf(stderr, "   Colonne: %d\n", column_number);
    fprintf(stderr, "   Token: '%s'\n", yytext); }
%%
