%{
#include <stdio.h>
#include <stdlib.h>

extern int line_number;
extern int column_number;
extern char *yytext;

void yyerror(const char *msg);

int yylex();
%}

%locations

%union
{
  double num;
  char *str;   
}

%token <str> IDENTI 
%token <num> NOMBRE  
%token FLECHE DIEZE APOS PAROUV PARFERM PASEGAL EQUIVAL SUP SUPEGAL INF INFEGAL ACCOUV ACCFERM ET OU
%token PLUS MOINS FOIS DIVISE MODULO PUISSANCE
%token INCR DECR

%token VAR CONST LIRE ECRIRE
%token SI SINON SINONSI
%token TANTQUE POUR VIRGULE

%token FONCTION PROCEDURE RETOURNER

%nonassoc SANS_SINON
%nonassoc SINON SINONSI

%start AXI

%%
AXI : LISTE_INST ;

LISTE_INST : INST LISTE_INST 
           | INST 
           ;
BLOC : LISTE_INST ;

INST  : AFFECT 
      | DECL_VAR 
      | DECL_CONST 
      | LECTURE 
      | ECRITURE 
      | COND 
      | STEP_EXPR
      | BOUCLEPOUR 
      | BOUCLETANTQUE 
      | APPEL
      | FONC 
      | PROC ;

EXPR : EXPR PLUS  TERME   { }
     | EXPR MOINS TERME   { }
     | TERME              { }
     ;

TERME : TERME FOIS    FACTEUR  { }
      | TERME DIVISE  FACTEUR  { }
      | TERME MODULO  FACTEUR  { }
      | FACTEUR                { }
      ;  

FACTEUR : FACTEUR PUISSANCE ATOME  { }
        | ATOME                    { }
        ;

ATOME : NOMBRE                        { }
      | IDENTI                        { }
      | PAROUV EXPR PARFERM           { }  
      ;

AFFECT : IDENTI FLECHE APOS IDENTI APOS DIEZE
       | IDENTI FLECHE EXPR DIEZE
       ;

DECL_VAR : VAR IDENTI DIEZE
         | VAR IDENTI FLECHE EXPR DIEZE
         ;

DECL_CONST : CONST IDENTI FLECHE NOMBRE DIEZE ;

LECTURE : LIRE IDENTI DIEZE
         | LIRE PAROUV IDENTI PARFERM DIEZE
         ;

ECRITURE : ECRIRE IDENTI DIEZE
         | ECRIRE PAROUV IDENTI PARFERM DIEZE
         | ECRIRE PAROUV APOS IDENTI APOS PARFERM DIEZE ;


COND_SIMPLE : IDENTI EQUIVAL IDENTI 
            | IDENTI EQUIVAL APOS IDENTI APOS 
            | IDENTI EQUIVAL NOMBRE 
            | IDENTI SUP NOMBRE 
            | IDENTI SUP IDENTI
            | IDENTI SUPEGAL NOMBRE 
            | IDENTI SUPEGAL IDENTI
            | IDENTI INF NOMBRE 
            | IDENTI INF IDENTI
            | IDENTI INFEGAL NOMBRE 
            | IDENTI INFEGAL IDENTI
            | IDENTI PASEGAL NOMBRE 
            | IDENTI PASEGAL IDENTI 
            | IDENTI PASEGAL APOS IDENTI APOS 
            ;

COND_EXPR : COND_EXPR OU COND_TERM  
          | COND_TERM               
          ;
          
COND_TERM : COND_TERM ET COND_SIMPLE
          | COND_SIMPLE
          ;

COND : SI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM 
      %prec SANS_SINON
     | SI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM SINON ACCOUV BLOC ACCFERM 
     | SI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM SINONSI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM SINON ACCOUV BLOC ACCFERM 
     ; 
INCREM_EXPR : INCR IDENTI | IDENTI INCR ;
DECREM_EXPR : DECR IDENTI | IDENTI DECR ;
STEP_EXPR   : INCREM_EXPR | DECREM_EXPR ;

BOUCLETANTQUE : TANTQUE PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM ;
  
BOUCLEPOUR : POUR PAROUV IDENTI FLECHE NOMBRE DIEZE IDENTI COND_SIMPLE  DIEZE STEP_EXPR PARFERM ACCOUV BLOC ACCFERM
           ;

LIST_ARG : IDENTI 
         | IDENTI VIRGULE LIST_ARG
         ;
FONC : FONCTION IDENTI PAROUV LIST_ARG PARFERM ACCOUV BLOC ACCFERM ;

PROC : PROCEDURE IDENTI PAROUV LIST_ARG PARFERM ACCOUV BLOC ACCFERM ;

APPEL : IDENTI PAROUV LIST_ARG PARFERM DIEZE ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "   ERREUR SYNTAXIQUE\n");
    fprintf(stderr, "   Ligne: %d\n", line_number);
    fprintf(stderr, "   Colonne: %d\n", column_number);
    fprintf(stderr, "   Message: %s\n", msg);
    fprintf(stderr, "   Token reçu: '%s'\n\n", yytext);
}

int main(int argc, char *argv[]) {
    printf("=== Compilateur LGLo v1.0 ===\n\n");
    
    if (yyparse() == 0) {
        printf("\nCompilation réussie\n");
        return 0;
    } else {
        printf("\nCompilation échouée.\n");
        return 1;
    }
}
