import java.io.*;
import java.util.*;

public class CsvSampler {
  private char fieldSep;
  private char quoteChar;

  public CsvSampler(char fieldSep, char quoteChar) {
    this.fieldSep = fieldSep;
    this.quoteChar = quoteChar;
  }

  public CsvSampler() {
    this(',', '"');
  }

  private List<String> rowToFieldList(String line) {
    List<String> fields = new ArrayList<>();
    int lastSepIndex = -1;
    boolean quoted = false;

    line = line + fieldSep; // cheat code to add last field in a row
    for (int i = 0; i < line.length(); ++i) {
      char c = line.charAt(i);

      if (c == quoteChar)
        quoted = !quoted;
      else if (c == fieldSep && !quoted) {
        String field = line.substring(lastSepIndex + 1, i);

        // remove the quotes if any
        if (field.startsWith(String.valueOf(quoteChar)) && field.endsWith(String.valueOf(quoteChar)))
          field = field.substring(1, field.length() - 1);

        fields.add(field);

        lastSepIndex = i;
      }
    }

    return fields;
  }

  private String getField(String row, int fieldNum) {
    return rowToFieldList(row).get(fieldNum - 1);
  }

  private Map<String, Long> countClassInstances(String inputFile, int colNum) throws IOException {
    Map<String, Long> classCounts = new HashMap<>();

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
      String line = reader.readLine(); // skip the header
      while ((line = reader.readLine()) != null) {
        String field = getField(line, colNum);

        // increment the counter for that class
        classCounts.put(field, classCounts.getOrDefault(field, 0L) + 1);
      }
    }

    return classCounts;
  }

  private Set<String> getColumnValues(String inputFile, int colNum) throws IOException {
    return countClassInstances(inputFile, colNum).keySet();
  }

  public int columnNameToNumber(String inputFile, String colName) {
    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
      String header = reader.readLine();
      return rowToFieldList(header).indexOf(colName) + 1;
    } catch (IOException ex) {
      return 0;
    }
  }

  public void printClassStats(String inputFile, int colNum) {
    Map<String, Long> classCounts;

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
      String header = reader.readLine();
      int colCount = rowToFieldList(header).size();
      if (colNum < 1 || colNum > colCount) {
        System.err.println("Column number has to be between 1 and " + colCount + "!");
        return;
      }
      String colName = getField(header, colNum);
      System.out.println("Collecting stats for field '" + colName + "'...");

      classCounts = countClassInstances(inputFile, colNum);
    } catch (FileNotFoundException ex) {
      System.err.println("File '" + inputFile + "' not found!");
      return;
    } catch (IOException ex) {
      System.err.println("I/O exception!");
      return;
    }

    String classNameH = "Class Name";
    String instanceCountH = "NO. of Instances";
    String percH = "Percentage";
    int classNameW = Math.max(
        classCounts.entrySet().stream().map(entry -> entry.getKey().length())
            .max(Comparator.naturalOrder()).orElse(0),
        classNameH.length()
    );
    int instanceCountW = Math.max(
        classCounts.entrySet().stream()
            .map(entry -> entry.getValue().toString().length()).max(Comparator.naturalOrder())
            .orElse(0),
        instanceCountH.length()
    );
    int percW = percH.length();

    long rowCount = classCounts.values().stream().reduce((x, y) -> x + y).get();
    String format = "%" + classNameW + "s | %" + instanceCountW + "s | %" + percW + "s%n";

    // print the result
    System.out.printf(format, classNameH, instanceCountH, percH);
    System.out.println("-".repeat(classNameW + 1) + "+" + "-".repeat(instanceCountW + 2)
        + "+" + "-".repeat(percW + 1));
    classCounts.forEach((className, count) -> {
      double perc = 100.0 * count / rowCount;
      System.out.printf(format, className, count, String.format("%.02f %%", perc));
    });
  }

  public void sample(String inputFile, String outputFile, int colNum, Optional<Integer> sampleCountOpt) {
    Map<String, List<Long>> instanceRows = new HashMap<>();
    List<Long> sampleRowNums = new ArrayList<>();

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
      long lineNum = 2;
      String line = reader.readLine(); // skip the header
      while ((line = reader.readLine()) != null) {
        String field = getField(line, colNum);
        
        if (instanceRows.containsKey(field))
          instanceRows.get(field).add(lineNum);
        else {
          List<Long> rowNums = new ArrayList<>();
          rowNums.add(lineNum);
          instanceRows.put(field, rowNums);
        }

        ++lineNum;
      }
    } catch (FileNotFoundException ex) {
      System.err.println("File '" + inputFile + "' not found!");
      return;
    } catch (IOException ex) {
      System.err.println("I/O exception!");
      return;
    }

    int sampleCount = sampleCountOpt.orElseGet(() ->
        instanceRows.entrySet().stream().map(e -> e.getValue().size())
        .min(Comparator.naturalOrder()).get());

    instanceRows.forEach((className, rowNums) -> {
      Collections.shuffle(rowNums);
      List<Long> rowsSubset = rowNums.subList(0, Math.min(sampleCount, rowNums.size()));
      sampleRowNums.addAll(rowsSubset);
    });
    Collections.sort(sampleRowNums);

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
        PrintWriter writer = new PrintWriter(new FileWriter(outputFile))) {
      // copy the header
      String line = reader.readLine();
      writer.println(line);

      long lineNum = 1;
      for (long sampleRowNum : sampleRowNums) {
        while (lineNum < sampleRowNum) {
          line = reader.readLine();
          ++lineNum;
        }

        writer.println(line);
      }
    } catch (IOException ex) {
      System.err.println("I/O exception!");
      return;
    }
  }

  public static void main(String[] args) {
    CsvSampler sampler = new CsvSampler();

    if (args[0].equals("info")) {
      if (args.length != 4) {
        System.err.println("Exactly 4 arguments expected!");
        return;
      }

      String inputFile = args[3];
      int colNum;
      if (args[1].equals("-o") || args[1].equals("--col-num"))
        colNum = Integer.parseInt(args[2]);
      else if (args[1].equals("-n") || args[1].equals("--col-name"))
        colNum = sampler.columnNameToNumber(inputFile, args[2]);
      else {
        System.err.println("Column name or number expected!");
        return;
      }

      sampler.printClassStats(inputFile, colNum);
    } else if (args[0].equals("sample")) {
      if (args.length < 6 || args.length > 7) {
        System.err.println("6-7 arguments expected!");
        return;
      }

      String inputFile = args[args.length - 2];
      String outputFile = args[args.length - 1];
      
      int colNum;
      if (args[1].equals("-o") || args[1].equals("--col-num"))
        colNum = Integer.parseInt(args[2]);
      else if (args[1].equals("-n") || args[1].equals("--col-name"))
        colNum = sampler.columnNameToNumber(inputFile, args[2]);
      else {
        System.err.println("Column name or number expected!");
        return;
      }

      if (args[3].equals("-s") || args[3].equals("--smallest-class")) {
        sampler.sample(inputFile, outputFile, colNum, Optional.empty());
      } else if (args[3].equals("-c") || args[3].equals("--count")) {
        int sampleCount = Integer.parseInt(args[4]);
        sampler.sample(inputFile, outputFile, colNum, Optional.of(sampleCount));
      } else
        System.err.println("Sample count expected!");
    } else {
      System.err.println("Expected command name as first argument!");
    }
  }
}
 



