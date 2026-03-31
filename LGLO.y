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

%union {
  double num;
  char *str;   
}

%left PLUS MOINS
%left FOIS DIVISE MODULO
%right PUISSANCE
%left PAROUV PARFERM

%token <str> IDENTI STRING
%token <num> NOMBRE  

%token FLECHE DIEZE APOS PAROUV PARFERM 
%token PASEGAL EQUIVAL SUP SUPEGAL INF INFEGAL ACCOUV ACCFERM ET OU EGAL

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
BLOC : LISTE_INST 
     | LISTE_INST RETOURNER_VAL
     | RETOURNER_VAL
     ;

INST : AFFECT DIEZE
     | DECL_VAR 
     | DECL_CONST 
     | LECTURE 
     | ECRITURE 
     | COND 
     | STEP_EXPR
     | BOUCLEPOUR 
     | BOUCLETANTQUE 
     | FONC 
     | PROC 
     | APPEL_SANS_DIEZE DIEZE
     ;

EXPR : EXPR PLUS  TERME   
     | EXPR MOINS TERME   
     | TERME              
     ;

TERME : TERME FOIS    FACTEUR  
      | TERME DIVISE  FACTEUR  
      | TERME MODULO  FACTEUR  
      | FACTEUR                
      ;  

FACTEUR : FACTEUR PUISSANCE ATOME  
        | ATOME                    
        ;

ATOME : NOMBRE                       
      | IDENTI
      | APPEL_SANS_DIEZE                       
      | PAROUV EXPR PARFERM            
      ;

AFFECT : IDENTI FLECHE EXPR 
       | IDENTI FLECHE STRING 
       ;

DECL_VAR : VAR IDENTI DIEZE
         | VAR IDENTI FLECHE EXPR DIEZE
         | VAR IDENTI FLECHE STRING DIEZE
         ;

DECL_CONST : CONST IDENTI FLECHE NOMBRE DIEZE ;

LECTURE : LIRE IDENTI DIEZE 
         | LIRE PAROUV IDENTI PARFERM DIEZE 
         ;

ECRITURE : ECRIRE IDENTI DIEZE 
         | ECRIRE PAROUV IDENTI PARFERM DIEZE 
         | ECRIRE PAROUV APOS IDENTI APOS PARFERM DIEZE 
         | ECRIRE PAROUV STRING PARFERM DIEZE 
         ;


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
     | SI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM 
        SINON ACCOUV BLOC ACCFERM 
     | SI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM 
        SINONSI PAROUV COND_EXPR PARFERM ACCOUV BLOC ACCFERM 
        SINON ACCOUV BLOC ACCFERM 
     ; 

STEP_EXPR : IDENTI INCR DIEZE   
          | INCR IDENTI DIEZE   
          | IDENTI DECR DIEZE   
          | DECR IDENTI DIEZE   
          ;

STEP_IN_POUR : IDENTI INCR   
             | INCR IDENTI   
             | IDENTI DECR   
             | DECR IDENTI   
             ;
POUR_INIT : IDENTI FLECHE NOMBRE DIEZE   
          | IDENTI EGAL NOMBRE DIEZE 
          | VAR IDENTI FLECHE NOMBRE DIEZE   
          | VAR IDENTI EGAL NOMBRE DIEZE
          ;
BOUCLETANTQUE : TANTQUE PAROUV COND_SIMPLE PARFERM ACCOUV BLOC ACCFERM ;
  
BOUCLEPOUR : POUR PAROUV POUR_INIT COND_SIMPLE DIEZE STEP_IN_POUR PARFERM ACCOUV BLOC ACCFERM ;


LIST_ARG : ARG_PLUSIEURS
         | /* vide  pour les fonction et procedure sans argument */
         ;

ARG_PLUSIEURS : ARG_UN
              | ARG_UN VIRGULE ARG_PLUSIEURS
              ;

ARG_UN : EXPR
       | STRING
       | APOS IDENTI APOS
       ;

RETOURNER_VAL : RETOURNER EXPR DIEZE ;
FONC : FONCTION IDENTI PAROUV LIST_ARG PARFERM ACCOUV BLOC ACCFERM ;

PROC : PROCEDURE IDENTI PAROUV LIST_ARG PARFERM ACCOUV BLOC ACCFERM ;

//APPEL : IDENTI PAROUV LIST_ARG PARFERM DIEZE;
APPEL_SANS_DIEZE : IDENTI PAROUV LIST_ARG PARFERM ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "   ERREUR SYNTAXIQUE\n");
    fprintf(stderr, "   Ligne: %d\n", line_number);
    fprintf(stderr, "   Colonne: %d\n", column_number);
    fprintf(stderr, "   Message: %s\n", msg);
    fprintf(stderr, "   Token: '%s'\n", yytext);
}

int main(int argc, char *argv[]) {
    printf("=== Compilateur LGLo v1.0 ===\n\n");
    
    if (yyparse() == 0) {
        printf("\n=== Compilation réussie ===\n");
        return 0;
    } else {
        printf("\n=== Compilation échouée ===\n");
        return 1;
    }
}
