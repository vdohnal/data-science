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

# CsvSampler

## Build

```bash
javac CsvSampler.java
```

## Running

```bash
java CsvSampler <command> <options>... <input_file> [output_file]
```

Selecting an attribute:
- **By name**: `-n <column_name>` or `--col-name <column_name>`
- **By number**: `-o <column_number>` or `--col-num <column_number>`

### Info about a class

**Command**: `info`

This command prints the number of instances and the percentage for each class
indicated by the specified column.

```bash
java CsvSampler info -n ihpEligible IndividualsAndHouseholdsProgramValidRegistrations.csv
```

### Sampling by a class

**Command**: `sample`

This command picks a certain amount of random samples from each class
and writes them to another file.

Selecting the number of samples:
- **Fixed amount**: `-c <count>` or `--count <count>`
- **Size of the smallest class**: `-s` or `--smallest-class`

```bash
java CsvSampler sample -n ihpEligible -c 10000 IndividualsAndHouseholdsProgramValidRegistrations.csv sample-10000.csv
java CsvSampler sample -n ihpEligible -s IndividualsAndHouseholdsProgramValidRegistrations.csv sample-smallest.csv
```
