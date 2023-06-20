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


//Símbolos terminales para la gramática

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
True = "0" | “true”
False = "1" | “false”

conjuncion = "^"
disyuncion = "#"
igual = "=="

mainC = "main"
forC = "for"
doC = "do"
whileC = "while"
ifC = "if"
elseC = "else"
elifC = "elif"
inputC = "input"
printC = "print"
returnC = "return"

letra  = [a-zA-Z_]
ident  = {letra} ({letra}|\d)*
caracter  = '[^']'
string  = "string"
digito  = [0-9]
digitoN  = [1-9]
bool  = {True} | {False}

menor  = "<"
mayor  = ">"
menorIgual  = "<="
mayorIgual  = ">="
diferente  = "!="
numeroE = /*{resta}?*/ ("0" | {digitoN} {digito}*)
numeroF = /*{resta}?*/ ("0" "." {digito}* | {digitoN} {digito}*"."{digito}*)
coma = ","
punto = "."

%state STRING

%%

//Definición de tokens

/* keywords */
<YYINITIAL> "bool"            { return symbol(sym.BOOLEAN); }
<YYINITIAL> "int"                { return symbol(sym.INT); }
<YYINITIAL> "char"               { return symbol(sym.CHAR); }
<YYINITIAL> {string}             { return symbol(sym.STRING); }
<YYINITIAL> "float"              { return symbol(sym.FLOAT); }
<YYINITIAL> "break$"              { return symbol(sym.BREAK); }

<YYINITIAL> {

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
{caracter}              {return symbol(sym.caracter, yytext());}
{coma}                  {return symbol(sym.coma);}
{punto}                 {return symbol(sym.punto);}
{mainC}                 {return symbol(sym.mainC);}
{ifC}                   {return symbol(sym.ifC);}
{elseC}                 {return symbol(sym.elseC);}
{whileC}                {return symbol(sym.whileC);}
{doC}                   {return symbol(sym.doC);}
{forC}                  {return symbol(sym.forC);}
{inputC}                {return symbol(sym.inputC);}
{returnC}               {return symbol(sym.returnC);}
{elifC}                 {return symbol(sym.elifC);}
{printC}                 {return symbol(sym.printC);}
"in"                    {return symbol(sym.inC);}
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
{numeroE}                {return symbol(sym.INTEGER_LITERAL, yytext());}
{numeroF}                {return symbol(sym.FLOAT_LITERAL, yytext());}
{bool}                  {return symbol(sym.bool, yytext());}

/* identifiers */ 
{ident}                   { return symbol(sym.ident, yytext()); }
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