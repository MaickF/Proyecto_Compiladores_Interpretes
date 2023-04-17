import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import java_cup.internal_error;
import java_cup.runtime.Symbol;

import Proyecto.*;

public class MainProject {
    public void initLexerParser(String rutaLexer, String rutaParser) throws internal_error, Exception{
        generarLexer(rutaLexer);
        generarParser(rutaParser);
    }

    public void generarLexer(String rutaLexer) throws internal_error, Exception, IOException{
        String[] strArr = {rutaLexer};
        jflex.Main.main(strArr);
    }

    public void generarParser(String rutaParser) throws internal_error, Exception, IOException{
        String[] strArr = {rutaParser};
        java_cup.Main.main(strArr);
    }

    public void ejercicioLexer(String ruta)throws Exception{
        Reader reader = new BufferedReader(new FileReader(ruta));
        reader.read();
        Lexer lex = new Lexer(reader);
        int i = 0;
        Symbol token;
        //sym valor = new sym();
        while(true){
            System.out.println("---------------------------------------");
            token = lex.next_token();
            if(token.sym != 0)
                System.out.println("Token:" + sym.terminalNames[token.sym] + ", valor; " + lex.yytext());
            else{
                System.out.println("Cantidad de lexemas encontrados: " +i);
                return;
            }
            i++;
        }
    }

    public void ejercicioParser(String ruta)throws Exception{
        Reader reader = new FileReader(ruta);
        Lexer lex = new Lexer(reader);
        Parser parser = new Parser(lex);
        parser.parse(); 
    }
    
}
