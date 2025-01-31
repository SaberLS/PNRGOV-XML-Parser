%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex();
int yyerror(const char*);

extern int yylineno;
extern int yyparse();

int licznik_bledow=0;
%}

%union {
    char *str;
}

%define parse.error verbose
%token TAG_O TAG_C
%token <str> TEXT
%left '='
%left '"'

%type <str> attributeName attributeValue attribute tag_name tag self_closing_tag
%%
tag:
    self_closing_tag {printf("self_closing_tag\n");}
    ;

self_closing_tag:
    open_tag attributes TAG_C {
        printf("Samo Zamykający tag\n");
    }
    ;

open_tag:
    TAG_O tag_name{
        printf("Open tag: <%s\n", $2);
        }
    ;

tag_name:
    TEXT {
        printf("tag_name: %s\n", $1);
        }
    ;

attributeName:
    TEXT {
        printf("attributeName: %s\n", $1);
        $$ = $1;  /* Przekazuje wartość do attribute */
    }
    ;

attributeValue:
    '"' TEXT '"' {
        printf("attributeValue: %s\n", $2);
        $$ = $2;  /* Przekazuje wartość do attribute*/
        }
    ;

attribute:
    attributeName '=' attributeValue {
        printf("ATTRIBUTE %s: %s\n", $1, $3);
        }

attributes:
    attribute attributes
    | /* pusty - pozwala na brak atrybutów */
    ;

%%
int main() {
   yyparse();
}

int yyerror(const char* msg) {
   printf("Blad skladniowy w linii %d: %s\n", yylineno, msg);
   licznik_bledow++;
}
