# Project Instructions for Claude

## Generated Files

**DO NOT edit files in `./sql/gen/`** - these are generated and will be overwritten.

## Data Cleanup

Place all UPDATE statements for data cleanup in `runme.sql`, after the data is loaded but before the FK constraint validation block.

### UNKNOWN Values

Do not add 'UNKNOWN' as a valid code in any codes table. When the source data contains 'UNKNOWN' values:

1. Do NOT add an 'UNKNOWN' row to the codes table
2. Add an UPDATE statement in `runme.sql` to set the column to NULL where it equals 'UNKNOWN'

Example:
```sql
UPDATE tec.c_coversheet1data SET electionTypeCd = NULL WHERE electionTypeCd = 'UNKNOWN';
```

### Boolean Columns

Columns containing 'Y' and 'N' values should be converted to proper boolean types:

1. Define the column as `boolean` in the table schema
2. Use a CASE expression or type cast during data load if needed
3. Or add an UPDATE/ALTER to convert after load
