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

[^\" =<>\t\n]+         { yylval.str = strdup(yytext); return TEXT; }

[ \t]+				{/* Ignoruj białe znaki SPACE, TAB */};
\n				{yylineno++; /* Nowa linia */};

.   { /* TODO: nie rozpoznane znaki  */ };
