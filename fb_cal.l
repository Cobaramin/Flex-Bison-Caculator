%{
# include "fb_cal.tab.h"
# include <math.h>
# include <ctype.h>
int symlook(char c);
int hexToInt(char *hexadecimal);
%}

digit		[0-9]
alpha		[a-fA-F]
hextail		({digit}|{alpha}){1,8}
hex		{hextail}[hH]

%%
"+"             { return T_ADD; }
"-"             { return T_SUB; }
"*"             { return T_MUL; }
"/"             { return T_DIV; }
"\\"            { return T_MOD; }
"("		          { return T_LEFT; }
")"		          { return T_RIGHT; }
[0-9]+          { yylval.ival = atoi(yytext); return T_INT; }
{hex}	          { yylval.ival = hexToInt(yytext); return T_INT; }
$r[A-Z]      { yylval.ival = symlook(yytext[2]); return T_REG; }
"$acc"          { return T_ACC; }
"$top"          { return T_TOP; }
"$size"          { return T_SIZE; }
"PUSH"          { return T_PUSH; }
"POP"           { return T_POP; }
"LOAD"          { return T_LOAD; }
"SHOW"          { return T_SHOW; }
"AND"           { return T_AND; }
"OR"            { return T_OR; }
"NOT"           { return T_NOT; }
[\n]            { return T_NEWLINE; }
[\t]            { /* ignore whitespace */ }
.               { /*do noting*/ }

%%

int hexToInt(char *hexadecimal){
  int decimalNumber = 0;
  int power = 0;
  for (int j = strlen(hexadecimal)-2; j >= 0; j-- ) {
    if (hexadecimal[j] > 57)
		  decimalNumber +=  (toupper(hexadecimal[j]) - 55) * (int)pow((double)16, power);
	  else
		  decimalNumber +=  (toupper(hexadecimal[j]) - 48) * (int)pow((double)16, power);
	  power++;
  }
  return decimalNumber;
}

int symlook(char c){
  return (int)(c - 'A');
}
