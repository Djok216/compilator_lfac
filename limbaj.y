%{
#include <stdio.h>
#include "lgbt.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
int tip, ok = 0;
%}

%token ASSIGN NEQ EQ GR LE GREQ LEQ RANGE BEG END INCLUDE MYNAME CONST VAR CLASS FUNCT MAIN STR NRD NRI VNAME TYPE
%token IF FOR WHILE ELIF ELSE TRUE FALSE PLUS MINUS DIV MOD MUL PRINT AND OR PRIME MIN MAX GCD LCM
%left AND
%left OR
%left DIV
%left MUL
%left MOD 
%left PLUS 
%left MINUS
%left NEQ
%left EQ
%left GR
%left LE
%left GREQ
%left LEQ
%left ASSIGN
%start progr
%%
progr: MYNAME bib const vars class func main { printf("Program corect sintactic\n"); };

assign: VNAME dimens ASSIGN expresie { if(!ok && !checkVar($1, 1)) return 0 * printf("Variabila \"%s\" nu a fost declarata! linia: %d\n", $1, yylineno);
									   if(!eval($1, $4)) return 0 * printf("Expresie gresita la linia %d %s\n", yylineno, $4);
									 }
	  ;
dimens: dimens '[' NRI ']' {char *s = malloc(strlen($1) + strlen($3) + 5);
							 strcpy(s, $1); strcat(s, "["); strcat(s, $3); strcat(s, "]"); $$ = s;}
	  | dimens '[' VNAME ']' {char *s = malloc(strlen($1) + strlen($3) + 5);
							 strcpy(s, $1); strcat(s, "["); strcat(s, $3); strcat(s, "]"); $$ = s;}
	  | {$$ = "";}
	  ;
bib: bib INCLUDE STR ';'
   |
   ;

const: CONST BEG const1 END
	 |
	 ;
const1: const1 TYPE VNAME ASSIGN val ';' { int ans = addVar($3, $2, $5); 
										   if(!ans) return 0 * printf("Eroare: Se repeta numele de constanta la linia %d: \"%s\"\n", yylineno, $3);
										   if(ans == -1) return 0 * printf("Eroare: Tipul nu corespunde! linia %d\n", yylineno);
										 }
	  | 
	  ;

val: nr { char *s = malloc(strlen($1 + 5)); strcpy(s, $1); $$ = s;}
   | STR { char *s = malloc(strlen($1 + 5)); strcpy(s, $1); $$ = s;}
   ;

expresie: TRUE {$$ = "true";}
		| FALSE {$$ = "false";}
		| VNAME dimens { char *s = malloc(strlen($1) + strlen($2) + 5); strcpy(s, $1); strcat(s, $2); $$ = s; }
		| funCall {char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s;}
		| classOP {char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s;}
		| nr {char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s;}
		| STR {char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s;}
		| functie_definita { char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s; }
		| expresie NEQ expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3); $$ = s;}
		| expresie LEQ expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie GREQ expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie EQ expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie LE expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie GR expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie PLUS expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie MINUS expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie MUL expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie MOD expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie DIV expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie OR expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| expresie AND expresie {char *s = malloc(strlen($1) + strlen($2) + strlen($3) + 5); strcpy(s, $1); strcat(s, $2); strcat(s, $3);  $$ = s;}
		| '(' expresie ')' {char *s = malloc(1 + strlen($2) + 1 + 5); strcpy(s, "("); strcat(s, $2); strcat(s, ")");  $$ = s;}
 		;

functie_definita: MIN '(' expresie ',' expresie ')' { char a[50], b[50]; memset(a, 0, sizeof(a)); memset(b, 0, sizeof(b)); strcpy(a, $3); strcpy(b, $5);
													  if(!ok_expr(a) || !ok_expr(b)) return 0 * printf("Eroare la expresie linia %d\n", yylineno);
													  int ans = min(get_val_expr(a), get_val_expr(b));
													  char* buff = malloc(64);
													  int Val = max(ans, -ans), lung = 0, j;
													  while(Val) buff[lung] = '0' + Val % 10, Val /= 10, ++lung;
													  if(ans < 0) buff[lung] = '-', ++lung;

													  for(j = 0; j < lung / 2; ++j) {
														char tmp = buff[j];
														buff[j] = buff[lung - j - 1];
														buff[lung - j - 1] = tmp;
													  }
													  $$ = buff;
													}
				| MAX '(' expresie ',' expresie ')' { char a[50], b[50]; memset(a, 0, sizeof(a)); memset(b, 0, sizeof(b)); strcpy(a, $3); strcpy(b, $5);
													  if(!ok_expr(a) || !ok_expr(b)) return 0 * printf("Eroare la expresie linia %d\n", yylineno);
													  int ans = max(get_val_expr(a), get_val_expr(b));
													  char* buff = malloc(64);
													  int Val = max(ans, -ans), lung = 0, j;
													  while(Val) buff[lung] = '0' + Val % 10, Val /= 10, ++lung;
													  if(ans < 0) buff[lung] = '-', ++lung;

													  for(j = 0; j < lung / 2; ++j) {
														char tmp = buff[j];
														buff[j] = buff[lung - j - 1];
														buff[lung - j - 1] = tmp;
													  }
													  $$ = buff;
													}
				| GCD '(' expresie ',' expresie ')' { char a[50], b[50]; memset(a, 0, sizeof(a)); memset(b, 0, sizeof(b)); strcpy(a, $3); strcpy(b, $5);
													  if(!ok_expr(a) || !ok_expr(b)) return 0 * printf("Eroare la expresie linia %d\n", yylineno);
													  int ans = cmmdc(get_val_expr(a), get_val_expr(b));
													  char* buff = malloc(64);
													  int Val = max(ans, -ans), lung = 0, j;
													  while(Val) buff[lung] = '0' + Val % 10, Val /= 10, ++lung;
													  if(ans < 0) buff[lung] = '-', ++lung;

													  for(j = 0; j < lung / 2; ++j) {
														char tmp = buff[j];
														buff[j] = buff[lung - j - 1];
														buff[lung - j - 1] = tmp;
													  }
													  $$ = buff;
													}
				| LCM '(' expresie ',' expresie ')' { char a[50], b[50]; memset(a, 0, sizeof(a)); memset(b, 0, sizeof(b)); strcpy(a, $3); strcpy(b, $5);
													  if(!ok_expr(a) || !ok_expr(b)) return 0 * printf("Eroare la expresie linia %d\n", yylineno);
													  int ans = cmmmc(get_val_expr(a), get_val_expr(b));
													  char* buff = malloc(64);
													  int Val = max(ans, -ans), lung = 0, j;
													  while(Val) buff[lung] = '0' + Val % 10, Val /= 10, ++lung;
													  if(ans < 0) buff[lung] = '-', ++lung;

													  for(j = 0; j < lung / 2; ++j) {
														char tmp = buff[j];
														buff[j] = buff[lung - j - 1];
														buff[lung - j - 1] = tmp;
													  }
													  $$ = buff;
													}
				;


nr:NRI {char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s;}
  |NRD {char *s = malloc(strlen($1) + 5); strcpy(s, $1); $$ = s;}
  ;

vars: VAR BEG vars1 END {ok = 1;}
	| {ok = 1;}
	;

varsfunc: VAR BEG vars1 END
		| 
		;
vars1: vars1 lista_var ':' TYPE ';' { tip = get_tip($4); if(tip == -1) return 0 * printf("Tip declarat gresit\n");
									  if(!Check_new_vars(tip)) return 0 * printf("Eroare, variabila declarata dublu la linia %d\n", yylineno);
									}
     |
     ;
lista_var: VNAME { qwen = 0; if(!ok) memset(qwe[qwen], 0, sizeof(qwe[qwen])), strcpy(qwe[qwen], $1), ++qwen; }
		 | lista_var ',' VNAME { if(!ok) memset(qwe[qwen], 0, sizeof(qwe[qwen])), strcpy(qwe[qwen], $3), ++qwen; }
		 ;

class: CLASS BEG class1 END {ok = 1;}
	 | {ok = 1;}
	 ;
class1:class1 VNAME BEG blockClass END
	  |
	  ;
blockClass: vars func;

func: FUNCT BEG fun END {ok = 0;}
	| {ok = 0;}
	;
fun: VNAME '(' param ')' BEG blockFun END fun
   | VNAME '(' ')' BEG blockFun END fun
   |
   ;
param: TYPE VNAME
	 | param ',' TYPE VNAME
	 ;
blockFun: varsfunc content;

content: content conditie
	   | content ciclu
	   | content whyl
	   | content assign ';'
	   | content funCall ';'
	   | content classOP ';'
	   | content ';'
	   | content printFunc ';'
	   |
	   ;

conditie: IF '(' expresie ')' BEG content END conditie1;
conditie1: ELIF '(' expresie ')' BEG content END conditie1
		 | ELSE BEG content END
		 |
		 ;

ciclu: FOR '(' assign ',' expresie ',' assign ')' BEG content END;

whyl: WHILE '(' expresie ')' BEG content END;
funCall: VNAME '(' lista_param ')'
	   | VNAME '(' ')'
	   ;
classOP: classCall classItem ;
classCall: VNAME '~';
classItem: VNAME
		 | VNAME '(' ')'
		 | VNAME '(' lista_param ')'
		 | classOP
		 ;
lista_param: expresie
		   | lista_param ',' expresie
		   ;

printFunc: PRINT '(' VNAME dimens ')' { char a[50], b[50]; memset(a, 0, sizeof(a)); memset(b, 0, sizeof(b)); strcpy(a, $3); strcpy(b, $5);if(checkVar($3, 0) && !ok) return 0 * printf("variabila nedeclarata \"%s\" linia : %d\n", $3, yylineno); add_buffer($3, get_val($3)); };

main: MAIN BEG content END { printf("%s\n", buff); }
	;

%%
int yyerror(char * s){
	printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main() {
	yyin = fopen("test.in", "r");

	yyparse();

	return 0;
} 