# CsvConverter

## Build

You need JDK.

```bash
javac CsvConverter.java
```

## Running

```bash
java CsvConverter <option> <input_file> <output_file>
```

### Quoting fields

**Option**: `-q` or `--quote`

This will quote all fields that contain whitespace or a single-quote (with
double-quotes).

```bash
java CsvConverter -q "Individual Assistance/HousingAssistanceRenters.csv" quoted.csv
```

### Dropping inconsistent rows

**Option**: `-d` or `--drop`

This will write all the rows to the output file, dropping the ones that have
different number of fields than the heading (first row).

```bash
java CsvConverter -d "Individual Assistance/IndividualsAndHouseholdsProgramValidRegistrations.csv" trimmed.csv
```
