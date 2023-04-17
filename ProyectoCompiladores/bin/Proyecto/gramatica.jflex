package Proyecto;

/* JFlex example: partial Java language lexer specification */
import java_cup.runtime.*;

/**
    * This class is a simple example lexer.
    */
%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();

    private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

aumento = "++"
decremento = "--"
multiplicacion = "*"
suma = "+"
resta = "-"
equivalente = "="
negacion = "!"
division = "/"
modulo = "~"
potencia = "**"

aperturaB = "{"
cerraduraB = "}"
aperturaC = "["
cerraduraC = "]"
aperturaP = "("
cerraduraP = ")"
comentarioL = "@"
comentApert = "/_"
comentCerrad = "_/"
finalExpre = "$"
True = 0 | “true”
False = 1 | “false”

conjuncion = "^"
disyuncion = "#"
igual = "=="

letra  = [a-zA-Z_]
ident  = {letra}({letra}|\d)*
//caracter  = '[^']'
//string  = "\"[^\"\n]*\""
digito  = [0-9]
digitoN  = [1-9]
bool  = {True} | {False}

menor  = "<"
mayor  = ">"
menorIgual  = "<="
mayorIgual  = ">="
diferente  = "!="
numeroE = {resta}? ("0" | {digitoN} {digito}*)


%state STRING

%%

/* keywords */
<YYINITIAL> "boolean"            { return symbol(sym.BOOL); }
<YYINITIAL> "int"                { return symbol(sym.INT); }
<YYINITIAL> "char"               { return symbol(sym.CHAR); }
<YYINITIAL> "string"             { return symbol(sym.string); }
<YYINITIAL> "float"              { return symbol(sym.FLOAT); }
<YYINITIAL> "break"              { return symbol(sym.BREAK); }

<YYINITIAL> {
/* identifiers */ 
{ident}                   { return symbol(sym.ident); }

/* literals */
{finalExpre}            {return symbol(sym.finalExpre);}
{aperturaB}             {return symbol(sym.aperturaB);}
{cerraduraB}            {return symbol(sym.cerraduraB);}
{aperturaC}             {return symbol(sym.aperturaC);}
{cerraduraC}            {return symbol(sym.cerraduraC);}
{aperturaP}             {return symbol(sym.aperturaP);}
{cerraduraP}            {return symbol(sym.cerraduraP);}
{comentarioL}           {return symbol(sym.comentarioL);}
{comentApert}           {return symbol(sym.comentApert);}
{comentCerrad}          {return symbol(sym.comentCerrad);}
//{caracter}              {return symbol(sym.caracter);}
//{string}                {return symbol(sym.STRING);}
\"                      { string.setLength(0); yybegin(STRING); }
/* operators */
{equivalente}           { return symbol(sym.equivalente); }
{igual}                 { return symbol(sym.igual); }
{suma}                  { return symbol(sym.suma); }
{aumento}               { return symbol(sym.aumento); }
{decremento}            { return symbol(sym.decremento); }
{multiplicacion}        { return symbol(sym.multiplicacion); }
{resta}                 { return symbol(sym.resta); }
{negacion}              { return symbol(sym.negacion); }
{division}              { return symbol(sym.division); }
{modulo}                { return symbol(sym.modulo); }
{potencia}              { return symbol(sym.potencia); }
{conjuncion}            { return symbol(sym.conjuncion); }
{disyuncion}            { return symbol(sym.disyuncion); }
{menor}                 { return symbol(sym.menor); }
{menorIgual}            { return symbol(sym.menorIgual); }
{mayorIgual}            { return symbol(sym.mayorIgual); }
{mayor}                 { return symbol(sym.mayor); }
{diferente}             { return symbol(sym.diferente); }
{letra}                 {return symbol(sym.letra);}
{numeroE}                {return symbol(sym.INTEGER_LITERAL);}
{bool}                  {return symbol(sym.bool);}

/* comments */
{Comment}                      { /* ignore */ }

/* whitespace */
{WhiteSpace}                   { /* ignore */ }
}

<STRING> {
\"                             { yybegin(YYINITIAL); 
                                return symbol(sym.STRING_LITERAL, 
                                string.toString()); }
[^\n\r\"\\]+                   { string.append( yytext() ); }
\\t                            { string.append('\t'); }
\\n                            { string.append('\n'); }

\\r                            { string.append('\r'); }
\\\"                           { string.append('\"'); }
\\                             { string.append('\\'); }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                yytext()+">"); }