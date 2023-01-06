#define YYDEBUG 1

#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
#include "zgdbAst.h"

extern FILE* yyin;

int main(int argc, char **argv) {
    printf("> ");
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            printf("syntax: %s filename\n", argv[0]);
        }
    }
    yyparse();
    ast ast1 = getAst();
    printf("\n%d\n", ast1.type);
    printf("%s\n", ast1.docName);
    return 0;
}