/* simplest version of calculator */
%{
#include <stdio.h>
#include <stdlib.h>

typedef int datatype;
typedef struct node node;
struct node{
	datatype data;
	node *next;
};

extern int yylex();
extern int yyparse();

int acc , top;
int size , element;
int reg[26];
node *h = NULL;

void yyerror(const char* s);
void push(node **h, datatype data);
datatype pop(node **h);
%}

%union {
	int ival;
}

/* declare tokens */
%token <ival> T_INT
%token <ival> T_REG T_ACC T_TOP T_SIZE
%token <ival> T_AND T_OR T_NOT
%token <ival> T_ADD T_SUB T_MUL T_DIV T_MOD
%token <ival> T_LEFT T_RIGHT
%token <ival> T_PUSH T_POP T_LOAD T_SHOW
%token <ival> T_NEWLINE

%left T_PUSH T_POP T_LOAD T_SHOW
%left T_ADD T_SUB
%left T_MUL T_DIV T_MOD

%type<ival> line
%type<ival> single_exp
%type<ival> multi_exp
%type<ival> term
%type<ival> stack_operation
%type<ival> stack_show

%start calclist

%%

calclist:
 | calclist line T_NEWLINE { acc = $2; printf("= %d\n", $2); }
 | calclist stack_show T_NEWLINE { printf("= %d\n", $2); }
 | calclist stack_operation T_NEWLINE { /*do nothing*/ }
 ;

line: multi_exp
  | single_exp
  ;

stack_show: T_SHOW multi_exp { $$ = $2; }
;

stack_operation: T_PUSH multi_exp { push(&h,$2); }
  | T_POP T_REG { reg[$2] = pop(&h); }
	| T_LOAD multi_exp T_REG { reg[$3] = $2; }
  ;

multi_exp: term
	| multi_exp T_AND multi_exp	 { $$ = $1 & $3; }
	| multi_exp T_OR multi_exp	 { $$ = $1 | $3; }
	| multi_exp T_ADD multi_exp	 { $$ = $1 + $3; }
	| multi_exp T_SUB multi_exp	 { $$ = $1 - $3; }
	| multi_exp T_MUL multi_exp  { $$ = $1 * $3; }
	| multi_exp T_DIV multi_exp	 { $$ = $1 / $3; }
	| multi_exp T_MOD multi_exp	 { $$ = $1 % $3; }

	| single_exp T_AND multi_exp	{ $$ = $1 & $3; }
	| single_exp T_OR multi_exp	  { $$ = $1 | $3; }
	| single_exp T_ADD multi_exp	{ $$ = $1 + $3; }
	| single_exp T_SUB multi_exp	{ $$ = $1 - $3; }
	| single_exp T_MUL multi_exp  { $$ = $1 * $3; }
	| single_exp T_DIV multi_exp  { $$ = $1 / $3; }
	| single_exp T_MOD multi_exp  { $$ = $1 % $3; }

	| multi_exp T_AND single_exp	{ $$ = $1 & $3; }
	| multi_exp T_OR single_exp	  { $$ = $1 | $3; }
	| multi_exp T_ADD single_exp	{ $$ = $1 + $3; }
	| multi_exp T_SUB single_exp	{ $$ = $1 - $3; }
	| multi_exp T_MUL single_exp  { $$ = $1 * $3; }
	| multi_exp T_DIV single_exp	{ $$ = $1 / $3; }
	| multi_exp T_MOD single_exp	{ $$ = $1 % $3; }

  | T_LEFT multi_exp T_RIGHT		{ $$ = $2; }
;

single_exp: term
 | single_exp T_AND single_exp	{ $$ = $1 & $3; }
 | single_exp T_OR single_exp	  { $$ = $1 | $3; }
 | single_exp T_ADD single_exp	{ $$ = $1 + $3; }
 | single_exp T_SUB single_exp	{ $$ = $1 - $3; }
 | single_exp T_MUL single_exp	{ $$ = $1 * $3; }
 | single_exp T_DIV single_exp	{ $$ = $1 / $3; }
 | single_exp T_MOD single_exp	{ $$ = $1 % $3; }

 | T_LEFT single_exp T_RIGHT { $$ = $2; }
;

term: T_INT
  | T_NOT T_INT { $$ = ~2; }
  | T_SUB T_INT  { $$ =  ~$2 + 1; }
	| T_REG { $$ = reg[$1]; }
	| T_ACC { $$ = acc; }
	| T_TOP { $$ = h->data; }
	| T_SIZE { $$ = size; }
;

%%

main(int argc, char **argv)
{
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}

void push(node **h, datatype data){
    node* tmp = *h;
    *h = (node*)malloc(sizeof(node));
    (*h)->data = data;
    (*h)->next = tmp;
		size++;
}

datatype pop(node **h){
  if(size > 0){
    node *tmp = *h;
    datatype data = (*h)->data;
    *h = (*h)->next;
    free(tmp);
		size--;
  	return data;
  }
  return 0;
}
