# Nashville Housing Data Cleaning

## Table of Contents
1. [Overview](#overview)
2. [Repository Contents](#repository-contents)
3. [SQL Script](#sql-script)

---

## Overview
This repository showcases various data cleaning techniques applied to the Nashville Housing dataset. The SQL script `nashville-housing-data-cleaning.sql` demonstrates how to clean and transform data to ensure consistency and prepare it for analysis.

---

## Repository Contents
- **Nashville Housing Data for Data Cleaning**
  - Original dataset file containing raw data before cleaning.

- **nashville-housing-data-cleaning.sql**
  - SQL script file containing data cleaning operations.

---

## SQL Script
The `nashville-housing-data-cleaning.sql` script performs the following data cleaning operations:
- Standardizes date formats.
- Populates missing `PropertyAddress` data based on shared `ParcelID`.
- Extracts `Address` and `City` from `PropertyAddress`.
- Extracts `Address`, `City`, and `State` from `OwnerAddress`.
- Converts 'Y' and 'N' values in `SoldAsVacant` to 'Yes' and 'No'.
- Removes unused columns `OwnerAddress`, `PropertyAddress`, and `SaleDate`.
