/*
Cleaning Data in SQL Queries
This script performs various data cleaning operations on the `nashville-housing` dataset.
*/

-- Select all columns from the table `nashville-housing`
SELECT * 
FROM 
    `nashville-housing`.`nashville-housing`;

/*
Standardize Date Format
Converts the `SaleDate` column to a standardized date format using STR_TO_DATE function.
*/
SELECT 
    STR_TO_DATE(SaleDate, '%M %d, %Y') AS saleDateConverted,
    SaleDate
FROM
    `nashville-housing`.`nashville-housing`;

/*
Update `SaleDate` to the standardized date format across the table.
*/
UPDATE `nashville-housing`.`nashville-housing`
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y');

-- Populate `PropertyAddress` data where multiple properties share the same `ParcelID`
/*
Identifies records with NULL or empty `PropertyAddress` and populates them by joining with another record having the same `ParcelID`.
*/
SELECT 
    a.ParcelID, 
    a.PropertyAddress AS PropertyAddress_a, 
    b.ParcelID AS ParcelID_b, 
    b.PropertyAddress AS PropertyAddress_b, 
    CASE 
        WHEN a.PropertyAddress = '' THEN b.PropertyAddress
        ELSE a.PropertyAddress
    END AS MergedPropertyAddress
FROM 
    `nashville-housing`.`nashville-housing` a
JOIN 
    `nashville-housing`.`nashville-housing` b
ON 
    a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE 
    a.PropertyAddress IS NULL
    OR a.PropertyAddress = '';

-- Update `PropertyAddress` across the table based on the merged values
UPDATE `nashville-housing`.`nashville-housing` a
JOIN `nashville-housing`.`nashville-housing` b
    ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = CASE 
                            WHEN a.PropertyAddress IS NULL OR a.PropertyAddress = '' THEN b.PropertyAddress
                            ELSE a.PropertyAddress
                        END;
                        
-- Extract Address, City, and State from `PropertyAddress` column

-- Select `PropertyAddress` column
SELECT 
    PropertyAddress
FROM 
    `nashville-housing`.`nashville-housing`;

/*
Extracts `Address` and `RestOfAddress` (City, State) from `PropertyAddress`.
*/
SELECT 
    PropertyAddress,
    SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) AS RestOfAddress
FROM   
    `nashville-housing`.`nashville-housing`;

-- Add new columns `PropertyAddressOnly` and `PropertyCity` to the table
ALTER TABLE 
    `nashville-housing`.`nashville-housing`
ADD 
    PropertyAddressOnly VARCHAR(255);    

-- Update `PropertyAddressOnly` column with the first part of `PropertyAddress`
UPDATE 
    `nashville-housing`.`nashville-housing`
SET 
    PropertyAddressOnly = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);

ALTER TABLE 
    `nashville-housing`.`nashville-housing`
ADD
    PropertyCity VARCHAR(255);
    
-- Update `PropertyCity` column with the city part of `PropertyAddress`
UPDATE 
    `nashville-housing`.`nashville-housing`
SET 
    PropertyCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1);

-- Extract `OwnerAddress`, `OwnerCity`, and `OwnerState` from `OwnerAddress` column

-- Select `OwnerAddress` column
SELECT 
    OwnerAddress
FROM 
    `nashville-housing`.`nashville-housing`;
    
/*
Extracts `Address`, `City`, and `State` from `OwnerAddress`.
*/
SELECT 
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1)) AS City,
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS State
FROM 
    `nashville-housing`.`nashville-housing`;

-- Add new columns `OwnerAddressOnly`, `OwnerCity`, and `OwnerState` to the table
ALTER TABLE 
    `nashville-housing`.`nashville-housing`
ADD
    OwnerAddressOnly VARCHAR(255);
    
-- Update `OwnerAddressOnly` column with the first part of `OwnerAddress`
UPDATE 
    `nashville-housing`.`nashville-housing`
SET 
    OwnerAddressOnly = SUBSTRING_INDEX(OwnerAddress, ',', 1);
    
ALTER TABLE 
    `nashville-housing`.`nashville-housing`
ADD
    OwnerCity VARCHAR(255);
    
-- Update `OwnerCity` column with the city part of `OwnerAddress`
UPDATE 
    `nashville-housing`.`nashville-housing`
SET 
    OwnerCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1));

ALTER TABLE 
    `nashville-housing`.`nashville-housing`
ADD
    OwnerState VARCHAR(255);
    
-- Update `OwnerState` column with the state part of `OwnerAddress`
UPDATE 
    `nashville-housing`.`nashville-housing`
SET 
    OwnerState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- Change 'Y' and 'N' values in `SoldAsVacant` column to 'Yes' and 'No'

-- Select distinct values of `SoldAsVacant` and their counts
SELECT DISTINCT
    SoldAsVacant, 
    COUNT(SoldAsVacant)
FROM 
    `nashville-housing`.`nashville-housing`
GROUP BY 
    SoldAsVacant
ORDER BY 
    2;

/*
Update `SoldAsVacant` column to 'Yes' for 'Y', 'No' for 'N', and keep other values as is.
*/
SELECT 
    SoldAsVacant, 
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant 
    END AS UpdatedSoldAsVacant
FROM 
    `nashville-housing`.`nashville-housing`;

UPDATE 
    `nashville-housing`.`nashville-housing`
SET 
    SoldAsVacant = CASE 
                        WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
                        ELSE SoldAsVacant 
                   END;
       
-- Delete unused columns `OwnerAddress`, `PropertyAddress`, and `SaleDate`

ALTER TABLE `nashville-housing`.`nashville-housing`
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;