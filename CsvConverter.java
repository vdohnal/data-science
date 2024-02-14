import java.io.*;
import java.util.List;
import java.util.ArrayList;

public class CsvConverter {
  private char fieldSep;
  private char quoteChar;

  public CsvConverter(char fieldSep, char quoteChar) {
    this.fieldSep = fieldSep;
    this.quoteChar = quoteChar;
  }

  public CsvConverter() {
    this(',', '"');
  }

  private boolean needsQuoting(char character) {
    return Character.isWhitespace(character) || character == '\'';
  }

  private int countFields(String row) {
    int count = 0;
    boolean quoted = false;

    for (char c : row.toCharArray()) {
      if (c == quoteChar)
        quoted = !quoted;
      else if (c == fieldSep && !quoted)
        ++count;
    }

    return count + 1;
  }

  // returns whether all the rows in a file have the same number of fields
  public boolean hasInconsistentRows(String inputFile) {
    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
      String line = reader.readLine();
      int fieldCount = countFields(line);

      while ((line = reader.readLine()) != null) {
        if (countFields(line) != fieldCount)
          return true;
      }

      return false;
    } catch (FileNotFoundException e) {
      System.err.println("Could not find file '" + inputFile + "'!");
    } catch (IOException e) {
      System.err.println("I/O exception!");
    }

    return true;
  }

  // write rows from one file to another, excluding the ones that have
  // a different number of fields than the header
  public void removeInconsistentRows(String inputFile, String outputFile) {
    System.out.println("Writing valid rows from '" + inputFile + "' to '" + outputFile + "'...");
    long rowsTotal = 0, rowsRemoved = 0;

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
        PrintWriter writer = new PrintWriter(new FileWriter(outputFile))) {
      String line = reader.readLine();
      int fieldCount = countFields(line); // count the fields in the header

      writer.println(line); // copy the header to the output file
      while ((line = reader.readLine()) != null) {
        if (countFields(line) == fieldCount)
          writer.println(line);
        else
          ++rowsRemoved;

        ++rowsTotal;
      }
    } catch (FileNotFoundException e) {
      System.err.println("Could not find file '" + inputFile + "'!");
    } catch (IOException e) {
      System.err.println("I/O exception!");
    }

    double removePerc = 100.0 * rowsRemoved / rowsTotal;
    System.out.printf("Removed %d/%d (%.2f %%) rows%n", rowsRemoved, rowsTotal, removePerc);
  }

  public void quoteFields(String inputFile, String outputFile) {
    System.out.println("Writing quoted fields from '" + inputFile + "' to '" + outputFile + "'...");

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
        PrintWriter writer = new PrintWriter(new FileWriter(outputFile))) {
      String line;

      while ((line = reader.readLine()) != null) {
        List<String> fields = new ArrayList<>();
        int lastSepIndex = -1;
        boolean quoted = false;
        boolean needsQuote = false;

        line = line + fieldSep; // cheat code to add last field in a row
        for (int i = 0; i < line.length(); ++i) {
          char c = line.charAt(i);

          if (c == quoteChar)
            quoted = !quoted;
          else if (needsQuoting(c) && !quoted)
            needsQuote = true;
          else if (c == fieldSep && !quoted) {
            String field = line.substring(lastSepIndex + 1, i);
            if (needsQuote)
              field = quoteChar + field + quoteChar;
            fields.add(field);

            lastSepIndex = i;
            needsQuote = false;
          }
        }

        writer.println(String.join(String.valueOf(fieldSep), fields.toArray(new String[0])));
      }
    } catch (FileNotFoundException e) {
      System.err.println("Could not find file '" + inputFile + "'!");
    } catch (IOException e) {
      System.err.println("I/O exception!");
    }
  }

  public static void main(String[] args) {
    if (args.length != 3) {
      System.err.println("Exactly 3 arguments expected!");
      return;
    }
    String command = args[0];
    String inputFile = args[1];
    String outputFile = args[2];

    CsvConverter conv = new CsvConverter();

    switch (command) {
      case "-d":
      case "--drop":
        conv.removeInconsistentRows(inputFile, outputFile);
        break;
      case "-q":
      case "--quote":
        if (conv.hasInconsistentRows(inputFile))
          System.err.println("Illegal number of fields!");
        else
          conv.quoteFields(inputFile, outputFile);
        break;
    }
  }
}
  
