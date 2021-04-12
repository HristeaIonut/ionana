%{
#include <stdio.h>
#include "ionana.tab.h"
%}
%option noyywrap
%%
"int"|"float"|"char"|"bool"|"string" {yylval.tip=strdup(yytext);return TIP;}
"SANCEPEM" {return START;}
"GATAPA" {return END;}
"if" {return IF;}
"while" {return WHILE;}
"else" {return ELSE;}
"true"|"false" {yylval.boo = strdup(yytext); return BOO;}
":=" {return EGAL2;}
"=" {return ASSIGN;}
"Eval" {return EVAL;}
"->class" {return CLASS;}
"->functie" {return FUNCTION;}
\"[0-9a-zA-Z]\" {yylval.caracter = strdup(yytext); return CHAR;}
\"[0-9a-zA-Z]+\" {yylval.strval = strdup(yytext); return STR;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval.nume=strdup(yytext);return ID;}
"==" {return EGAL;}
"<" {return L;}
">" {return G;}
"<=" {return LE;}
">=" {return GE;}
"!=" {return NE;}
0|"-"?([1-9][0-9]*) {yylval.intval=atoi(yytext);return NR;}
([0-9]|[1-9][0-9]+)"."[0-9]*|"-"([0-9]|[1-9][0-9]+)"."[0-9]* {yylval.floatval=atof(yytext); return RATIONAL;}

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 