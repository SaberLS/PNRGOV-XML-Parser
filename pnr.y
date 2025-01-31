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

%type <str> attributeName attributeValue attribute tag_name tag self_closing_tag str
%%


tag:
    self_closing_tag {
        printf("self_closing_tag\n");
    }
    |   opening_tag tag_content closing_tag {
            printf("OPEN  CONTENT CLOSE");
        }
    ;

tags:
    tag tags
    |   tag
    ;

tag_content:
    tags
    |   TEXT
    |   /* pusty */
    ;

self_closing_tag:
    open_tag attributes SELF_CLOSING_C {
        printf("Samo Zamykający tag\n");
    }
    ;

opening_tag:
    open_tag attributes TAG_C {
        printf("OPENING TAG!!\n");
    }
    ;

closing_tag:
    CLOSING_TAG_O tag_name TAG_C {
        printf("CLOSING TAG!!!\n");
    }
    ;

open_tag:
    TAG_O tag_name {
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
    str {
        printf("attributeValue: %s\n", $1);
    }
    ;

str:
    SIGN_DOUBLE_TICK TEXT SIGN_DOUBLE_TICK {
        $$ = $2;  /* Przekazuje wartość do attribute*/
    }
    ;

attribute:
    attributeName SIGN_EQ attributeValue {
        printf("ATTRIBUTE %s: %s\n", $1, $3);
    }
    ;
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
