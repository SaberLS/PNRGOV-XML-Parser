%{
#include "pnr.tab.h"
extern int yylineno;
void yyerror(char *);
%}


%%
"</"  {return CLOSING_TAG_O;};
"<" {return TAG_O;};

"/>" {return SELF_CLOSING_C;};
">" {return TAG_C;};

"="        { return SIGN_EQ; }
"\""       { return SIGN_DOUBLE_TICK; }

[^\" =<>\t\n]+         { yylval.str = strdup(yytext); return TEXT; }

[ \t]+				{/* Ignoruj białe znaki SPACE, TAB */};
\n				{yylineno++; /* Nowa linia */};

.   { /* TODO: nie rozpoznane znaki  */ };
