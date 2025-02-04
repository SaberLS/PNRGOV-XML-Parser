%{
#include "pnr.tab.h"
#include <string.h>
#include <stdlib.h>
extern int yylineno;
void yyerror(char *);
// printf("\n%d|\t%s\n", yylineno, yytext);
%}

%x SURNAME_T NAME_T FLIGHT_T TEXT_T


%option noyywrap

%%
<INITIAL>"<Flight " {
    //printf("\n%d|\t%s\n", yylineno, yytext);
    BEGIN(FLIGHT_T);
 }
<INITIAL>\n  {yylineno++; /* Nowa linia */}
<INITIAL>.   {/* ignorujemy */ }

<FLIGHT_T>"<Surname>" {
    BEGIN(SURNAME_T);
}

<FLIGHT_T>"<Text>/"[a-zA-Z0-9]+"/"[a-zA-Z0-9]+"/"[a-zA-Z0-9]+"/"[a-zA-Z0-9]+"/"[a-zA-Z0-9]+"/"[a-zA-Z0-9]+"/"[a-zA-Z0-9]+"/" {
    // printf("\n%d|\tBEGIN(TEXT_T);|%s\n", yylineno, yytext);
    BEGIN(TEXT_T);
}

<TEXT_T>[A-Z]+ {
    yylval.str = strdup(yytext); return SURNAME;
}

<TEXT_T>[A-Z]+"<" {
    int len = strlen(yytext);
    char *copy = (char *)malloc(len - 1);
    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }
    strncpy(copy, yytext, len-1);
    copy[len - 1] = '\0';

    yylval.str = copy;
    return NAME;
}

<TEXT_T>\n  {yylineno++; /* Nowa linia */}
<TEXT_T>.   {/* ignorujemy */ }
<TEXT_T>"/Text>" {
    // printf("\n%d|\tBEGIN(FLIGHT_T);|%s\n", yylineno, yytext);
    BEGIN(FLIGHT_T);
}

<SURNAME_T>[a-zA-Z]+ {yylval.str = strdup(yytext); return SURNAME;}

<SURNAME_T>\n  {yylineno++; /* Nowa linia */}
<SURNAME_T>.   {/* ignorujemy */ }

<SURNAME_T>"</Surname>" { BEGIN(FLIGHT_T);}


<FLIGHT_T>"<GivenName>" {BEGIN(NAME_T);}
<NAME_T>[a-zA-Z]+ {yylval.str = strdup(yytext); return NAME;}

<NAME_T>\n  {yylineno++; /* Nowa linia */}
<NAME_T>.   {/* ignorujemy */ }
<NAME_T>"</GivenName>" { BEGIN(FLIGHT_T);}


<FLIGHT_T>"FlightNumber=\""[0-9]+"\"" {
    int len = strlen(yytext);
    char *copy = (char *)malloc(len - 14 + 1);
    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }
    strncpy(copy, yytext+14, len-15);
    copy[len - 15] = '\0';

    yylval.str = copy;
    return FLIGHT_NO;
}

<FLIGHT_T>"DepartureDateTime=\""[0-9A-Z:\-]+"\"" {
    int len = strlen(yytext);
    char *copy = (char *)malloc(len - 20 + 1);
    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }
    strncpy(copy, yytext+19, len-20);
    copy[len - 20] = '\0';

    yylval.str = copy;
    return DEPARTURE_TIME;
}

<FLIGHT_T>"ArrivalDateTime=\""[0-9A-Z\-:]+"\"" {
    int len = strlen(yytext);
    char *copy = (char *)malloc(len - 18 + 1);
    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }

    strncpy(copy, yytext+17, len-18);
    copy[len - 18] = '\0';

    yylval.str = copy;
    return ARRIVAL_TIME;
}

<FLIGHT_T>"<DepartureAirport LocationCode=\""[A-Z]+"\"/>" {
    int len = strlen(yytext);
    char *copy = (char *)malloc(len - 32 + 1);

    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }
    strncpy(copy, yytext+32, len-35);
    copy[len - 35] = '\0';
    yylval.str = copy;
    return DEPARTURE_LOCATION;
}


<FLIGHT_T>"<ArrivalAirport LocationCode=\""[A-Z]+"\"/>" {
        int len = strlen(yytext);
    char *copy = (char *)malloc(len - 30 + 1);

    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }
    strncpy(copy, yytext+30, len-33);
    copy[len - 33] = '\0';
    yylval.str = copy;
    return ARRIVAL_LOCATION;
}

<FLIGHT_T>"<MarketingAirline Code=\""[A-Z]+"\"/>" {
        int len = strlen(yytext);
    char *copy = (char *)malloc(len - 24 + 1);

    if(copy == NULL) {
        fprintf(stderr, "Błąd alokacji pamięci\n");
        exit(1);
    }
    strncpy(copy, yytext+24, len-27);
    copy[len - 24] = '\0';
    yylval.str = copy;
    return AIRLINE;
}

<FLIGHT_T>\n  {yylineno++; /* Nowa linia */}
<FLIGHT_T>.   {/* ignorujemy */ }

<FLIGHT_T>"</Flight>" { BEGIN(INITIAL);}
