/* lexer */
%{
#include "parser.h"
#include <string.h>

extern void yyerror(const char * message);
#define ECHO fwrite(yytext, yyleng, 1, yyout)
%}

%option noyywrap


DIGIT    [0-9]

%%

"/"            {return ABSOLUTE;}
"//"           {return RELATIVE;}
"["            {return LBRAC;}
"]"            {return RBRAC;}

"="            {return EQ;}
"!="           {return NOT_EQ;}
"<"            {return LS;}
">"            {return GR;}
">="           {return GR_EQ;}
"<="           {return LS_EQ;}
"contains"     {return CONT;}

"&"            {return AND_SYM;}
"|"            {return OR_SYM;}
"!"            {return NOT_SYM;}

";"            {return END;}

(\.{DIGIT}+)|({DIGIT}+(\.{DIGIT}*)?([eE][+-]?[DIGIT]+)?)   {yylval.decimal = atof(yytext); return NUMBER;}

\"[^"]*\"      {yylval.string = strdup(yytext); ECHO; return STRING;}
@\"[^"]*\"     {yylval.string = strdup(yytext); ECHO; return KEY;}

[ \t\r\n]+     {/* ignore spaces */}


.              {yyerror(yytext); yyterminate();}

%%