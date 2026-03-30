%{
  #include <stdlib.h>
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
"&&"    { return ET; }
"||"    { return OU; }
"," { return VIRGULE; }

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
"{"     { return ACCOUV; }
"}"     { return ACCFERM; }

"+"     { return PLUS; }
"-"     { return MOINS; }
"*"     { return FOIS; }
"/"     { return DIVISE; }
"%"     { return MODULO; }
"^"     { return PUISSANCE; }

"++"  { return INCR; }
"--"  { return DECR; }



[0-9]+(\.[0-9]+)?  { yylval.num = atof(yytext); return NOMBRE; }
[a-zA-Z][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTI; } 

[ \t] {               } 

\n  {
      line_number++;
      column_number = 1;
  }

. { printf("Caractere suspect trouve : '%s' (ASCII: %d)\n", yytext, yytext[0]); }
%%
