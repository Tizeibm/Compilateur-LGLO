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
%token CROUV CROFERM LIST DICT DEUX_POINTS

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
     | ACCES_ELEMENT 
     | APPEL_SANS_DIEZE DIEZE
     | DECL_LIST
     | DEC_DICT
     | LIST_ELEMENT_DIEZE
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

//LIST_NOMBRE : IDENTI 
//            | IDENTI VIRGULE LIST_NOMBRE
//            ;
//LIST_STRING : STRING 
//            | STRING VIRGULE LIST_STRING
//            ;
//LIST_IDENTI : IDENTI 
//            | IDENTI VIRGULE LIST_IDENTI
//
//            ;
LIST_COMBI : EXPR
           | STRING 
           | EXPR VIRGULE LIST_COMBI 
           | STRING VIRGULE LIST_COMBI
           ;

LISTE : IDENTI FLECHE CROUV LIST_COMBI CROFERM 
      | STRING FLECHE CROUV LIST_COMBI CROFERM 
      | IDENTI FLECHE CROUV CROFERM 
      | STRING FLECHE CROUV CROFERM 
      ;

LISTE_OF_LISTE : LIST_DICT
               | LIST_DICT VIRGULE LISTE_OF_LISTE
               ;
MULTI_LIST : IDENTI FLECHE CROUV LISTE_OF_LISTE CROFERM
           ;

DECL_LIST : LIST LISTE DIEZE 
          | LIST MULTI_LIST DIEZE
          ;

LIST_DICT : CROUV CROFERM
          | CROUV LIST_COMBI CROFERM
          ;

CLE_VALEUR : IDENTI FLECHE EXPR 
           | IDENTI FLECHE STRING 
           | IDENTI FLECHE LIST_DICT
           ;

LISTE_CLE_VALEUR : CLE_VALEUR 
                 | CLE_VALEUR VIRGULE LISTE_CLE_VALEUR
                 ;

DEC_DICT : DICT IDENTI FLECHE ACCOUV ACCFERM DIEZE
         | DICT IDENTI FLECHE ACCOUV  LISTE_CLE_VALEUR ACCFERM DIEZE 
         ;

LIST_ELEMENT : IDENTI CROUV NOMBRE CROFERM 
             | IDENTI CROUV NOMBRE CROFERM CROUV NOMBRE CROFERM ;

LIST_ELEMENT_DIEZE : LIST_ELEMENT DIEZE

ACCES_ELEMENT : IDENTI FLECHE LIST_ELEMENT DIEZE ;

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
