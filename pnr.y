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

%token <str> NAME SURNAME FLIGHT_NO DEPARTURE_TIME ARRIVAL_TIME DEPARTURE_LOCATION ARRIVAL_LOCATION AIRLINE

%%
flights:
    flights flight
    | flight
    ;

flight:
    flight_informations passenger_informations
    ;

flight_info:
    DEPARTURE_TIME {
        printf("\n\n------------------LOT----------------------------\n");
        printf("\n%d|\t", yylineno);
        printf("Data Odlotu:\t%s", $1);
    }
    | ARRIVAL_TIME {
        printf("\n%d|\t", yylineno);
        printf("Data Przylotu:\t%s", $1);
    }
    | FLIGHT_NO {
        printf("\n%d|\t", yylineno);
        printf("Numer Lotu:\t%s", $1);
    }
    | DEPARTURE_LOCATION {
        printf("\n%d|\t", yylineno);
        printf("Lotnisko Odlotu:\t%s", $1);
    }
    | ARRIVAL_LOCATION {
        printf("\n%d|\t", yylineno);
        printf("Lotnisko Przylotu:\t%s", $1);
    }
    | AIRLINE {
        printf("\n%d|\t", yylineno);
        printf("Linia Lotnicza:\t%s", $1);
    }
    ;
flight_informations:
    flight_informations flight_info
    | flight_info
;
passenger_info:
    NAME {
        printf("\n\n------------------PASAZEROWIE----------------------------\n");
        printf("\n%d|\t", yylineno);
        printf("Imie:\t%s", $1);
    }
    | SURNAME {
        printf("\n%d|\t", yylineno);
        printf("Nazwisko:\t%s", $1);
        printf("\n\n-----------------------------------------------------");
    }
;
passenger_informations:
    passenger_informations passenger_info
    | passenger_info
    ;
%%
int main() {
   yyparse();
   printf("\n");
}

int yyerror(const char* msg) {
   printf("Blad skladniowy w linii %d: %s\n", yylineno, msg);
   licznik_bledow++;
}
