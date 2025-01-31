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
%token SIGN_EQ SIGN_DOUBLE_TICK
%token CLOSING_TAG_O TAG_O SELF_CLOSING_C TAG_C
%token <str> TEXT

%type <str> attributeName attributeValue attribute tag_name tag self_closing_tag open_tag attributes opening_tag closing_tag tags content
%%
document:
    tags {
        printf("FULL document:\n%s\n", $1);
        free($1);
    }
    | { printf("EMPTY DOCUMENT\n"); }  // Obsługa pustego pliku
    ;

tag:
    self_closing_tag {
        char *result = malloc(strlen($1)+3);
        sprintf(result, "%s", $1);

        free($1);
        $$ = result;
    }
    | opening_tag content closing_tag {
        char *result = malloc(strlen($1) + strlen($2) + strlen($3) + 5);
        sprintf(result, "%s%s%s", $1, $2, $3);

        free($1);
        free($2);
        free($3);
        $$ = result;
    }
    ;

tags:
    tags tag {
        char *result = malloc(strlen($1) + strlen($2) + 3);
        sprintf(result, "%s%s", $1, $2);

        // printf("tags tag: %s\n", result);

        free($1);
        free($2);
        $$ = result;
    }
    | tag {
        char *result = malloc(strlen($1) + 3);
        sprintf(result, "%s", $1);

        // printf("tag: %s\n", result);

        free($1);
        $$ = result;
    }
    ;

content:
    tags {
        char *result = malloc(strlen($1) + 2);
        // printf("result: %s\n", $1);
        sprintf(result, "\n\t%s", $1);

        free($1);
        $$ = result;
    }
    | TEXT { $$ = strdup($1); free($1);}
    | { $$ = strdup(""); }  // <-- Obsługa pustego contentu
    ;

self_closing_tag:
    open_tag attributes SELF_CLOSING_C {
        char *result = malloc(strlen($1) + strlen($2) + 4);
        sprintf(result, "\n%s%s/>", $1, $2);
        // printf("%s", result);

        free($1);
        free($2);

        $$ = result;
    }
    ;

opening_tag:
    open_tag attributes TAG_C {
        char *result = malloc(strlen($1) + strlen($2) + 3);
        sprintf(result, "\n%s%s>", $1, $2);

        // printf("OPENING TAG:\t%s\n", result);

        free($1);
        free($2);

        $$ = result;
    }
    ;

closing_tag:
    CLOSING_TAG_O tag_name TAG_C {
        char *result = malloc(strlen($2) + 5);
        sprintf(result, "\n</%s>", $2);
        // printf("CLOSING TAG:\t%s \n",result);

        free($2);
        $$ = result;
    }
    ;

open_tag:
    TAG_O tag_name {
        char *result = malloc(strlen($2) + 2);
        sprintf(result, "<%s", $2);

        // printf("%s", result);
        free($2);
        $$ = result;
    }
    ;

tag_name:
    TEXT {$$ = strdup($1); free($1);}
    ;

attributeName:
    TEXT { $$ = strdup($1); free($1);}
    ;

attributeValue:
    SIGN_DOUBLE_TICK TEXT SIGN_DOUBLE_TICK { $$ = strdup($2); free($2);}
    ;

attribute:
    attributeName SIGN_EQ attributeValue {
        char *result = malloc(strlen($1) + strlen($3) + 6);
        sprintf(result, "%s=\"%s\"", $1, $3);

        free($1);
        free($3);
        $$ = result;
    }
    ;

attributes:
    attributes attribute{
        char *result = malloc(strlen($1) + strlen($2) + 2);
        sprintf(result, "%s %s", $1, $2);

        free($1);
        free($2);
        $$ = result;
    }
    |   attribute {
        char *result = malloc(strlen($1) + 2);
        sprintf(result, " %s", $1);

        free($1);
        $$ = result;
    }
    | { $$ = strdup("");}
    ;

%%
int main() {
   yyparse();
}

int yyerror(const char* msg) {
   printf("Blad skladniowy w linii %d: %s\n", yylineno, msg);
   licznik_bledow++;
}
