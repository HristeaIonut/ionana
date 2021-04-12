%{
#include <stdio.h>
#include "functions.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
int errors = 0;
int isFloat = 0;
char signature[100];
char fctprm[100];
int scop;
%}
%union {int intval; char *nume; char *tip; char *caracter; char *boo; char *strval; float floatval;}
%token <tip> TIP START END IF EGAL2 WHILE <boo> BOO <nume> ID ELSE <floatval> RATIONAL EVAL EGAL NE L G LE GE ASSIGN CLASS FUNCTION <intval> NR <caracter> CHAR <strval> STR
%type <intval> e
%type <strval> sir
%left '(' ')'
%left ';'
%left ASSIGN
%left '+' '-' EGAL
%left '*' '/'

%start progr
%%
progr: declaratii bloc {if(errors == 0) printf("program corect sintactic\n"); else printf("Am gasit %d erori\n", errors); print();}
     ;

declaratii:  declaratie ';'
	      | declaratii declaratie ';'
	      ;

declaratie: TIP ID {if(check($2, 1)==1) declare($1, $2, 1); else yyerror();}
		  | TIP ID ASSIGN NR {if(check($2, 1)==1 && intreg($1)==1) initialize($1 ,$2, $4, 1); else yyerror();}
		  | TIP ID ASSIGN RATIONAL {if(flot($1)==0) yyerror(); else if(check($2, 1)==1) initializef($1, $2, $4, 1); else yyerror();}
		  | TIP ID ASSIGN CHAR {if(caracter($1)==0) yyerror(); else if(check($2, 1)==1) initializec($1, $2, $4, 1); else yyerror();}
		  | TIP ID '[' NR ']' {if(check($2, 1)==1) declareArr($2, $4, 1);}
		  | TIP ID ASSIGN BOO {if(boolean($1)==0) yyerror(); else if(check($2, 1)==1) initializeb($1, $2, $4, 1); else yyerror();}
		  |	TIP ID ASSIGN STR {if(str($1)==0) yyerror(); else if(check($2, 1)==1) initializes($1, $2, $4, 1); else yyerror();}
		  ;

declaratie_clasa: TIP ID ';' {if(check($2, 2)==1) declare($1, $2, 2); else yyerror();}
		  		| TIP ID ASSIGN NR ';' {if(check($2, 2)==1 && intreg($1)==1) initialize($1 ,$2, $4, 2); else yyerror();}
		  		| TIP ID ASSIGN RATIONAL ';'{if(flot($1)==0) yyerror(); else if(check($2, 2)==1) initializef($1, $2, $4, 2); else yyerror();}
		  		| TIP ID ASSIGN CHAR ';' {if(caracter($1)==0) yyerror(); else if(check($2, 2)==1) initializec($1, $2, $4, 2); else yyerror();}
		  		| TIP ID '[' NR ']' ';' {if(check($2, 2)==1) declareArr($2, $4, 2);}
		 		| TIP ID ASSIGN BOO ';' {if(boolean($1)==0) yyerror(); else if(check($2, 2)==1) initializeb($1, $2, $4, 2); else yyerror();}
		 		|	TIP ID ASSIGN STR ';' {if(str($1)==0) yyerror(); else if(check($2, 2)==1) initializes($1, $2, $4, 2); else yyerror();}
		 		;

declaratie_functie: TIP ID ';' {if(check($2, 3)==1) declare($1, $2, 3); else yyerror();}
		  		  | TIP ID ASSIGN NR ';' {if(check($2, 3)==1 && intreg($1)==1) initialize($1 ,$2, $4, 3); else yyerror();}
		  		  | TIP ID ASSIGN RATIONAL ';'{if(flot($1)==0) yyerror(); else if(check($2, 3)==1) initializef($1, $2, $4, 3); else yyerror();}
		 		  | TIP ID ASSIGN CHAR ';' {if(caracter($1)==0) yyerror(); else if(check($2, 3)==1) initializec($1, $2, $4, 3); else yyerror();}
				  | TIP ID '[' NR ']' ';' {if(check($2, 3)==1) declareArr($2, $4, 3);}
				  | TIP ID ASSIGN BOO ';' {if(boolean($1)==0) yyerror(); else if(check($2, 3)==1) initializeb($1, $2, $4, 3); else yyerror();}
				  |	TIP ID ASSIGN STR ';' {if(str($1)==0) yyerror(); else if(check($2, 3)==1) initializes($1, $2, $4, 3); else yyerror();}
		 		  ;
bloc: START instructiuni END  
    ;
instructiuni: instructiuni {scop=1;} instructiune
			| {scop=1;} instructiune
			;

instructiuni_clasa: instructiuni_clasa {scop=2;} instructiune_clasa {scop=1;}
				  | instructiuni_clasa declaratie_clasa
				  | {scop=2;} instructiune_clasa {scop=1;}
				  | declaratie_clasa
				  ;
instructiuni_functie: instructiuni_functie {scop=3;} instructiune_functie {scop=2;}
					| instructiuni_functie declaratie_functie
				    | {scop=3;} instructiune_functie {scop=2;}
					| declaratie_functie
				    ;

e: e '+' e {$$=$1+$3;}
 | e '*' e {$$=$1*$3;}
 | e '/' e {$$=$1/$3;}
 | e '-' e {$$=$1-$3;}
 | NR {$$=$1;}
 | ID {if(check($1, scop)==0 && (intType($1)==1 || floatType($1)==1) && initialized($1, scop)) $$=value($1, scop); else yyerror(); if(floatType($1)==1) isFloat = 1;}
 | RATIONAL {$$=$1; isFloat = 1;}
 ;
sir : sir '*' NR {multiply($1, $3);}
	| sir '+' sir {concat($1,$3);}
	| '!' STR {strrev($2);}
	| STR
	| ID {if(check($1,scop)==0 && strcmp(getType($1),"string")==0) $$=values($1,scop);}
	;
boolean: NR EGAL NR {if($1==$3) printf("equal\n");}
	   | NR NE NR {if($1!=$3) printf("not equal\n");}
	   | NR L NR {if($1<$3) printf("less\n");}
	   | NR G NR {if($1>$3) printf("greater\n");}
	   | NR LE NR {if($1<=$3) printf("less or equal\n");}
	   | NR GE NR {if($1>=$3) printf("greater or equal\n");}
	   | ID EGAL ID {if(strcmp(getType($1), getType($3))==0) {if(value($1, scop)==value($3, scop)) printf("equal\n");} else yyerror();}
	   | ID NE ID {if(strcmp(getType($1), getType($3))==0) {if(value($1, scop)!=value($3, scop)) printf("not equal\n");} else yyerror();}
	   | ID L ID {if(strcmp(getType($1), getType($3))==0) {if(value($1, scop)<value($3, scop)) printf("less\n");} else yyerror();}
	   | ID G ID {if(strcmp(getType($1), getType($3))==0) {if(value($1, scop)>value($3, scop)) printf("greater\n");} else yyerror();}	   ;
	   | ID LE ID {if(strcmp(getType($1), getType($3))==0) {if(value($1, scop)<=value($3, scop)) printf("less or equal\n");} else yyerror();}
	   | ID GE ID {if(strcmp(getType($1), getType($3))==0) {if(value($1, scop)>=value($3, scop)) printf("greater or equal\n");} else yyerror();}

daca: IF '(' conditie ')' '{' instructiuni '}'
	| IF '(' conditie ')' '{' instructiuni '}' ELSE '{' instructiuni '}'
	;

cat_timp: WHILE '(' conditie ')' '{' instructiuni '}'
		;

conditie: ID EGAL ID {if(!(check($1, 1)==0 && check($3, 1)==0) || strcmp(getType($1), getType($3))) yyerror();}
		| ID EGAL NR {if(check($1, 1)==1 || strcmp(getType($1),"int")) yyerror();}
		| ID EGAL RATIONAL {if(check($1, 1)==1 || strcmp(getType($1),"float")) yyerror();}
		| NR EGAL NR
		;
eval_f: EVAL '(' e ')' ';' {if(!isFloat && errors==0) printf("%d\n", $3); else yyerror();}

instructiune: ID ASSIGN e ';' {if(check($1, 1)==1 || (intType($1)==1 && isFloat) || (floatType($1)==1 && !isFloat)) {yyerror();isFloat=0;} else if(atribuire($1, $3, 1)==0) yyerror();}
			| ID EGAL2 ID ';' {if(check($1,1) || check($3,1) || strcmp(getType($1),getType($3)) || !initialized($1, 1) || !initialized($3,1)) yyerror(); else{if(strcmp(getType($1),"int")==0) atribuire($1,value($3,1),1); else if(strcmp(getType($1),"float")==0) atribuiref($1, valuef($3,1),1); else if(strcmp(getType($1),"char")==0) atribuirec($1, valuec($3,1),1); else if(strcmp(getType($1),"string")==0) atribuires($1, values($3,1),1);}}
			| ID '[' NR ']' ASSIGN NR ';' {if(check($1,1)==1) yyerror(); else atribuireArr($1, $6, $3,1);}
			| sir ';'
			| daca
			| cat_timp
			| boolean ';'
			| CLASS corp_clasa ';'
			| FUNCTION corp_functie 
			| ID '(' param_func ')' ';' {if(checkFunc($1, scop)==0 || checkSignature($1, fctprm, scop)==0) yyerror(); bzero(fctprm, 100);}
			| eval_f
	        ;

instructiune_clasa: ID ASSIGN e ';' {if(check($1, 2)==1 || (intType($1)==1 && isFloat) || (floatType($1)==1 && !isFloat)) {yyerror();isFloat=0;} else if(atribuire($1, $3, 2)==0) yyerror();}
				  | ID EGAL2 ID ';' {if(check($1,2) || check($3,2) || strcmp(getType($1),getType($3)) || !initialized($1, 2) || !initialized($3,2)) yyerror(); else{if(strcmp(getType($1),"int")==0) atribuire($1,value($3,2),2); else if(strcmp(getType($1),"float")==0) atribuiref($1, valuef($3,2),2); else if(strcmp(getType($1),"char")==0) atribuirec($1, valuec($3,2),2); else if(strcmp(getType($1),"string")==0) atribuires($1, values($3,2),2);}}
				  | ID '[' NR ']' ASSIGN NR ';' {if(check($1,2)==1) yyerror(); else atribuireArr($1, $6, $3, 2);}
				  | daca
				  | sir ';'
				  | cat_timp
				  | boolean ';'
				  | FUNCTION corp_functie 
				  | ID '(' param_func ')' ';' {if(checkFunc($1, scop)==0 || checkSignature($1, fctprm, scop)==0) yyerror(); bzero(fctprm, 100);}
				  | eval_f
				  ;

instructiune_functie: ID ASSIGN e ';' {if(check($1, 3)==1 || (intType($1)==1 && isFloat) || (floatType($1)==1 && !isFloat)) {yyerror();isFloat=0;} else if(atribuire($1, $3, 3)==0) yyerror();}
				    | ID EGAL2 ID ';' {if(check($1,3) || check($3,3) || strcmp(getType($1),getType($3)) || !initialized($1, 3) || !initialized($3,3)) yyerror(); else{if(strcmp(getType($1),"int")==0) atribuire($1,value($3,3),3); else if(strcmp(getType($1),"float")==0) atribuiref($1, valuef($3,3),3); else if(strcmp(getType($1),"char")==0) atribuirec($1, valuec($3,3),3); else if(strcmp(getType($1),"string")==0) atribuires($1, values($3,3),3);}}
					| ID '[' NR ']' ASSIGN NR ';' {if(check($1,3)==1) yyerror(); else atribuireArr($1, $6, $3,3);}
					| boolean ';'
					| sir ';'
					| daca
					| cat_timp
					;

corp_clasa: ID '{' instructiuni_clasa '}'
		  ;

corp_functie: ID '(' lista_param ')' '{' instructiuni_functie '}' {if(funcDef($1, signature, scop)==0) yyerror(); bzero(signature, 100);}

lista_param: lista_param ',' parametru
		   | parametru
		   ;
param_func: param_func ',' ID {if(check($3, scop)==0) {strcat(fctprm, getType($3)); strcat(fctprm, " ");} else yyerror();}
		  | param_func ',' ID '(' param_func ')' {if(check($3, scop)==0) {strcat(fctprm, getType($3)); strcat(fctprm, " ");} else yyerror();}
		  | ID '(' param_func ')' {if(check($1, scop)==0) {strcat(fctprm, getType($1)); strcat(fctprm, " ");} else yyerror();}
		  | ID {if(check($1, scop)==0) {strcat(fctprm, getType($1)); strcat(fctprm, " ");} else yyerror();}

parametru: TIP ID {strcat(signature, $1); strcat(signature, " ");}

%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
errors++;
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 