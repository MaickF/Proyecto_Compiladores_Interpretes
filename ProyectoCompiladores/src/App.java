import java.nio.file.Files;
import java.nio.file.Paths;

public class App {
    public static void generarParserLexer() throws Exception{
        System.out.println("Inicio");
        String basepath, scannerPath, parserPath;
        MainProject mp;
        basepath = System.getProperty("user.dir");
        System.out.println("antes");
        System.out.println(basepath);
        scannerPath = basepath+"\\src\\Proyecto\\gramatica.jflex";
        parserPath = basepath+"\\src\\Proyecto\\parser.cup";
        mp = new MainProject();
        Files.deleteIfExists(Paths.get(basepath+"\\src\\Proyecto\\Lexer.java"));
        Files.deleteIfExists(Paths.get(basepath+"\\src\\Proyecto\\sym.java"));
        Files.deleteIfExists(Paths.get(basepath+"\\src\\Proyecto\\Parser.java"));
        mp.initLexerParser(scannerPath, parserPath);
        Files.move(Paths.get(basepath+"\\sym.java"), Paths.get(basepath+"\\src\\Proyecto\\sym.java"));
        Files.move(Paths.get(basepath+"\\Parser.java"), Paths.get(basepath+"\\src\\Proyecto\\Parser.java"));
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
        pruebas();
    }
}
