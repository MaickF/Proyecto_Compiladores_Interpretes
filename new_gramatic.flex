/*
 * Copyright 2020, Gerwin Klein, Régis Décamps, Steve Rowe
 * SPDX-License-Identifier: BSD-3-Clause
 */

/* this is the scanner example from the JLex website
   (with small modifications to make it more readable) */

%%

%public

%{
  private int comment_count = 0;
%}

%line
%char
%state COMMENT
%unicode

%debug

// ALPHA=[A-Za-z]
// DIGIT=[0-9]
// NONNEWLINE_WHITE_SPACE_CHAR=[\ \t\b\012]
// NEWLINE=\r|\n|\r\n
// WHITE_SPACE_CHAR=[\n\r\ \t\b\012]
// STRING_TEXT=(\\\"|[^\n\r\"\\]|\\{WHITE_SPACE_CHAR}+\\)*
// COMMENT_TEXT=([^*/\n]|[^*\n]"/"[^*\n]|[^/\n]"*"[^/\n]|"*"[^/\n]|"/"[^*\n])+
// Ident = {ALPHA}({ALPHA}|{DIGIT}|_)*


/*Espresiones complejas*/
WHITE_SPACE_CHAR=[\n\r\ \t\b\012]
NUMEROE="-"{DIGITO}*|{DIGITO}*
NUMEROF={NUMEROE}"."{DIGITO}*
GRUPO_ARREGLO={NUMEROE}|{CARACTER}
LISTA={GRUPO_ARREGLO}{WHITE_SPACE_CHAR}("\\",{GRUPO_ARREGLO})*
ARREGLO_SIM={TIPO}{WHITE_SPACE_CHAR}{ID}{WHITE_SPACE_CHAR}"("{NUMEROE}")"
ARREGLO_ASIG={ARREGLO_SIM}"=""("({GRUPO_ARREGLO}|{LISTA})")"
ARREGLO_IND={ID}"("{NUMEROE}")""="{GRUPO_ARREGLO}
OPERANDO={NUMEROE}|{NUMEROF}|{ID}|{FUNCION_ASIG}
OPERACION_NUM_SIM={OPERANDO}{OPERACION_ARIT}{OPERANDO}
OPERACION_NUM={OPERACION_NUM_SIM}({OPERACION_ARIT}{OPERANDO})*
VARIABLE_NUM={TIPO_NUM}{WHITE_SPACE_CHAR}{ID}"="(({NUMEROE}|{NUMEROF})|{OPERACION_NUM}|{ID})
OPERACION_SUM_UNA="++"{OPERANDO}|"++"{VARIABLE_NUM}
OPERACION_RES_UNA="--"{OPERANDO}|"--"{VARIABLE_NUM}
OPERACION_RAC_SIM={OPERANDO}{OPERAION_RAC}{OPERANDO}
OPERACION_RAC_NUM={OPERACION_RAC_SIM}({OPERAION_RAC}{OPERANDO})*

OPERANDO_BOOL={EXP_NEGADA}|{BOOL}|{OPERACION_RAC_NUM}|{ID}|{FUNCION_ASIG}
CONDICION_SIM={OPERANDO_BOOL}{OPERACION_LOG}{OPERANDO_BOOL}
CONDICION={CONDICION_SIM}({OPERACION_LOG}{CONDICION_SIM})*
VARIABLE_B="bool"{WHITE_SPACE_CHAR}{ID}{WHITE_SPACE_CHAR}{CONDICION}
EXP_NEGADA="!"({CONDICION}|{VARIABLE_B}|{OPERANDO_BOOL})

VARIABLE={TIPO}{WHITE_SPACE_CHAR}({ID}|{ARREGLO_SIM})
VARIABLE_ASIG=´({VARIABLE}"="({FUNCION_ASIG}|{CARACTER}|{STRING}|{ID}))|{VARIABLE_NUM}|{VARIABLE_B}|{ARREGLO_ASIG}


%%
/*Signos y operandos*/
<SIGNOS_OPERANDOS> {
  "++" { return (new Yytoken(0,yytext(),yyline,yychar,yychar+2)); }
  "--" { return (new Yytoken(1,yytext(),yyline,yychar,yychar+2)); }
  "*" { return (new Yytoken(2,yytext(),yyline,yychar,yychar+1)); }
  "+" { return (new Yytoken(3,yytext(),yyline,yychar,yychar+1)); }
  "-" { return (new Yytoken(4,yytext(),yyline,yychar,yychar+1)); }
  "=" { return (new Yytoken(5,yytext(),yyline,yychar,yychar+1)); }
  "!" { return (new Yytoken(6,yytext(),yyline,yychar,yychar+1)); }
  "$" { return (new Yytoken(7,yytext(),yyline,yychar,yychar+1)); }
  "/" { return (new Yytoken(8,yytext(),yyline,yychar,yychar+1)); }
  "~" { return (new Yytoken(9,yytext(),yyline,yychar,yychar+1)); }
  "**" { return (new Yytoken(10,yytext(),yyline,yychar,yychar+2)); }
  "{" { return (new Yytoken(11,yytext(),yyline,yychar,yychar+1)); }
  "}" { return (new Yytoken(12,yytext(),yyline,yychar,yychar+1)); }
  "[" { return (new Yytoken(13,yytext(),yyline,yychar,yychar+1)); }
  "]" { return (new Yytoken(14,yytext(),yyline,yychar,yychar+1)); }
  "(" { return (new Yytoken(15,yytext(),yyline,yychar,yychar+1)); }
  ")"  { return (new Yytoken(16,yytext(),yyline,yychar,yychar+1)); }
  "^" { return (new Yytoken(19,yytext(),yyline,yychar,yychar+1)); }
  "#"  { return (new Yytoken(20,yytext(),yyline,yychar,yychar+1)); }
  "."  { return (new Yytoken(20,yytext(),yyline,yychar,yychar+1)); }
  "0"  { return (new Yytoken(21,yytext(),yyline,yychar,yychar+1)); }
  "1" { return (new Yytoken(22,yytext(),yyline,yychar,yychar+1)); }

  {NONNEWLINE_WHITE_SPACE_CHAR}+ { }

  "/_" { yybegin(COMMENT); comment_count++; }

  \"{STRING_TEXT}\" {
    String str =  yytext().substring(1,yylength()-1);
    return (new Yytoken(40,str,yyline,yychar,yychar+yylength()));
  }

  \"{STRING_TEXT} {
    String str =  yytext().substring(1,yytext().length());
    Utility.error(Utility.E_UNCLOSEDSTR);
    return (new Yytoken(41,str,yyline,yychar,yychar + str.length()));
  }

  {DIGIT}+ { return (new Yytoken(42,yytext(),yyline,yychar,yychar+yylength())); }

  {Ident} { return (new Yytoken(43,yytext(),yyline,yychar,yychar+yylength())); }
}

<COMMENT> {
  "/_" { comment_count++; }
  "_/" { if (--comment_count == 0) yybegin(YYINITIAL); }
  {COMMENT_TEXT} { }
}


{NEWLINE} { }

. {
  System.out.println("Illegal character: <" + yytext() + ">");
	Utility.error(Utility.E_UNMATCHED);
}

