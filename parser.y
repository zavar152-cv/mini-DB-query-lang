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
  long number;
  double decimal;
}
%error-verbose

%token ADD DELETE UPDATE FIND JOIN PARENT
%token INT DBL STR BOOL
%token ABSOLUTE RELATIVE LBRAC RBRAC LROBRAC RROBRAC COMMA COLON END
%token EQ NOT_EQ LS GR GR_EQ LS_EQ CONT
%token AND_SYM OR_SYM NOT_SYM
%token <number, decimal> NUMBER;
%token <string> STRING;
%token <key> KEY;

%start zpath

%%

zpath: ADD STRING schema path
     | UPDATE STRING STRING path
     | DELETE path
     | FIND path
     | JOIN path
     | PARENT path

schema: LROBRAC elements RROBRAC

elements: element COMMA elements
        | element

element: intschema
       | dblschema
       | boolschema
       | strschema

intschema: INT COLON KEY COLON NUMBER
dblschema: DBL COLON KEY COLON NUMBER
boolschema: BOOL COLON KEY COLON STRING
strschema: STR COLON KEY COLON STRING

path: entry terminal
    | entry path

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