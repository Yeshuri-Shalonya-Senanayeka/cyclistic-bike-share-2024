# Excel Power Query – Data Cleaning & Preparation

## Overview
The raw Cyclistic dataset consisted of **12 monthly Excel files**, each containing trip-level ride data.
Excel Power Query was used to perform **initial cleaning and standardization on each file individually** before loading the data into SQL Server.

This step focused on improving data consistency and preparing the files for reliable bulk import into a database.

---

## Files Processed
- 12 monthly Excel files (January–December 2024)
- Each file was cleaned separately using the same Power Query steps

---

## Cleaning & Preparation Steps

### 1. Column Standardization
- Verified column names were consistent across all files
- Renamed columns where needed to ensure uniform naming
- Ensured consistent column order across files

---

### 2. Duplicate Handling
- Checked for duplicate ride records within each monthly file
- Removed exact duplicate rows to avoid double-counting

---

### 3. Text Cleaning
- Trimmed leading and trailing spaces from text columns such as:
  - Station names
  - Rider type
  - Bike type
- Replaced empty strings with null values where applicable

---

### 4. Datetime Formatting
- Converted `started_at` and `ended_at` columns to proper datetime format
- Standardized datetime formats to ensure SQL Server compatibility
- Verified that datetime fields were correctly parsed after export

---

### 5. Data Consistency Checks
- Reviewed null values in key columns (ride ID, rider type, timestamps)
- Ensured schema consistency across all monthly files
- Confirmed all files were ready for bulk import

---

## Output
- Each cleaned monthly file was exported as an individual CSV
- These CSV files were later combined in **SQL Server** using a staging table

---

## Why Power Query Was Used
Power Query was used to:
- Apply the same cleaning logic consistently across multiple files
- Reduce ingestion errors during SQL bulk imports
- Handle basic formatting and standardization efficiently

All file consolidation, validation rules, and business logic were intentionally handled in SQL Server.


