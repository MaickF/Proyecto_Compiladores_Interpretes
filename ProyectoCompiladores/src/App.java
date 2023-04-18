import java.nio.file.Files;
import java.nio.file.Paths;

public class App {
    public static void generarParserLexer() throws Exception{
        String basepath, scannerPath, parserPath;
        MainProject mp;
        basepath = System.getProperty("user.dir");
        scannerPath = basepath+"\\src\\Proyecto\\gramatica.jflex";
        parserPath = basepath+"\\src\\Proyecto\\parser.cup";
        mp = new MainProject();
        Files.deleteIfExists(Paths.get(basepath+"\\src\\Proyecto\\Lexer.java"));
        Files.deleteIfExists(Paths.get(basepath+"\\src\\Proyecto\\sym.java"));
        Files.deleteIfExists(Paths.get(basepath+"\\src\\Proyecto\\parser.java"));
        mp.initLexerParser(scannerPath, parserPath);
        Files.move(Paths.get(basepath+"\\sym.java"), Paths.get(basepath+"\\src\\Proyecto\\sym.java"));
        Files.move(Paths.get(basepath+"\\parser.java"), Paths.get(basepath+"\\src\\Proyecto\\parser.java"));
    }

    public static void pruebas()throws Exception{
        String basepath, scannerPath, parserPath;
        MainProject mp;
        basepath = System.getProperty("user.dir");
        scannerPath = basepath+"\\src\\pruebas\\pruebaLexer.txt";
        parserPath = basepath+"\\src\\pruebas\\pruebaParser.txt";
        mp = new MainProject();
        mp.ejercicioLexer(scannerPath);
        //mp.ejercicioParser(parserPath);
    }

    public static void main(String[] args) throws Exception {
        generarParserLexer(); 
        //pruebas();
    }
}
