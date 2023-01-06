#define YYDEBUG 1

#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
#include "zgdbAst.h"

extern FILE* yyin;

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            printf("syntax: %s filename\n", argv[0]);
        }
    }
    yyparse();
    ast tree = getAst();
    printAst(&tree);

    printf("%zu", getSize());

    return 0;
}
