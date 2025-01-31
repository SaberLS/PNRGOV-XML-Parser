%{
#include "pnr.tab.h"
extern int yylineno;
void yyerror(char *);
%}


%%
"<" {return TAG_O;};
"/>" {return TAG_C;};

"="        { return '='; }
"\""       { return '"'; }

[A-Za-z0-9]+         { yylval.str = strdup(yytext); return TEXT; }
[ \t]+				{/* Ignoruj białe znaki SPACE, TAB */};
\n				{yylineno++; /* Nowa linia */};

<<EOF>>    { /* koniec pliku */ return 0; };
.   { /* TODO: nie rozpoznane znaki  */ };
