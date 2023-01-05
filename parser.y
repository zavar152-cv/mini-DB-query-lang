// bison file: parser.y
%{
 #include <stdio.h>
 #include <stdlib.h>

extern int yylineno;
extern char* yytext;
int yylex();
void yyerror(const char *s);

// gives good debug information
int yydebug=1;

%}

%union{
  char* key;
  char* string;
  double decimal;
}


%token ABSOLUTE RELATIVE LBRAC RBRAC END
%token EQ NOT_EQ LS GR GR_EQ LS_EQ CONT
%token AND_SYM OR_SYM NOT_SYM
%token <decimal> NUMBER;
%token <string> STRING;
%token <key> KEY;

%start zpath

%%

zpath: entry terminal
     | entry zpath

entry: ABSOLUTE base
     | ABSOLUTE KEY terminal
     | RELATIVE base
     | RELATIVE KEY terminal

terminal: END {exit(0);}

base: STRING
    | STRING predicates

predicates: predicate
          | predicate sym predicates

sym: AND_SYM
   | OR_SYM
   | AND_SYM NOT_SYM
   | OR_SYM NOT_SYM

predicate: LBRAC NUMBER RBRAC
         | LBRAC KEY op STRING RBRAC
         | LBRAC KEY op NUMBER RBRAC
         | LBRAC KEY op KEY RBRAC

op: EQ
  | NOT_EQ
  | LS
  | GR
  | GR_EQ
  | LS_EQ
  | CONT

%%

void yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
}