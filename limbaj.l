%{
#include <stdio.h>
#include "y.tab.h"
extern int yylval;
%}
NR_ [0-9]+
NRI_ "-"?{NR_}
NRD_ "-"?{NR_}"."{NR_}+
VNAME_ [a-zA-Z][_a-zA-Z0-9]*
RANGE_ "["[1-9]{NR_}*"]"
TYPE_ "bit"|"googol"|"love"|"book"
IF_ "elf"
ELIF_ "rudolf"
ELSE_ "santa"
FOR_ "rep"
WHILE_ "uail"
BEGIN_ "{"
END_ "}"
INCLUDE_ "1.09.1939 "
STRING_ \"[^\"\n]*\"
_MYNAME "##plamea"
_CONST "const:"
_VAR "var:" 
_CLASS "furnicuta<3"
_FUNCT "fun:"
_MAIN "Kappa:"
%%

{_MYNAME} {  return MYNAME; }
{_MAIN} {  return MAIN; }
{INCLUDE_} {  return INCLUDE; }
{_CONST} {  return CONST; }
{_VAR} {  return VAR; }
{_CLASS} {  return CLASS; }
{_FUNCT} {  return FUNCT; }
{IF_} {  return IF; }
{ELIF_} {  return ELIF; }
{ELSE_} {  return ELSE; }
{FOR_} {  return FOR; }
{WHILE_} {  return WHILE; }
{TYPE_}{RANGE_}* {  yylval = strdup(yytext); return TYPE; }
"true" {  yylval = strdup(yytext);return TRUE; }
"false" {  yylval = strdup(yytext);return FALSE; }
"voice" {  yylval = strdup(yytext);return PRINT; }

{BEGIN_} {  return BEG; }
{END_} {  return END; }

"||" {  yylval = strdup(yytext); return OR; }
"&&" {  yylval = strdup(yytext); return AND; }
"<>" {  yylval = strdup(yytext); return NEQ; }
"<#" {  yylval = strdup(yytext); return ASSIGN; }
"==" {  yylval = strdup(yytext);return EQ; }
">=" {  yylval = strdup(yytext); return GREQ; }
"<=" {  yylval = strdup(yytext); return LEQ; }
">" {  yylval = strdup(yytext);return GR; }
"<" {  yylval = strdup(yytext); return LE; }
"+" {  yylval = strdup(yytext);return PLUS; }
"-" {  yylval = strdup(yytext); return MINUS; }
"*" {  yylval = strdup(yytext);return MUL; }
"/" {  yylval = strdup(yytext);return DIV; }
"%" {  yylval = strdup(yytext);return MOD; }

{STRING_} {  yylval = strdup(yytext); return STR; }
"min" {  yylval = strdup(yytext); return MIN; }
"max" {  yylval = strdup(yytext); return MAX; }
"gcd" {  yylval = strdup(yytext); return GCD; }
"lcm" {  yylval = strdup(yytext); return LCM; }
"prime" {  yylval = strdup(yytext); return PRIME; }
{VNAME_} {  yylval = strdup(yytext); return VNAME; }
{NRI_} {  yylval = strdup(yytext); return NRI; }
{NRD_} {  yylval = strdup(yytext); return NRD; }
[ \t] ;
\n {  yylineno++; }
. {  return yytext[0]; }
