SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


-- STANDERDIZE DATE FORMAT

SELECT SaleDateConverted ,CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.DBO.NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)
 
ALTER TABLE PortfolioProject.DBO.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject.DBO.NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

---------------------------------------------------------------------------------


--POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

------------------------------------------------------------------------------------------


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing


ALTER TABLE PortfolioProject.DBO.NashvilleHousing
ADD PropertySpiltAddress nvarchar(255);

UPDATE PortfolioProject.DBO.NashvilleHousing
SET PropertySpiltAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE PortfolioProject.DBO.NashvilleHousing
ADD PropertySpiltCity nvarchar(255);

UPDATE PortfolioProject.DBO.NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

ALTER TABLE PortfolioProject.DBO.NashvilleHousing
ADD OwnerSpiltAddress nvarchar(255);

UPDATE PortfolioProject.DBO.NashvilleHousing
SET OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject.DBO.NashvilleHousing
ADD OwnerSpiltCity nvarchar(255);

UPDATE PortfolioProject.DBO.NashvilleHousing
SET OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject.DBO.NashvilleHousing
ADD OwnerSpiltState nvarchar(255);

UPDATE PortfolioProject.DBO.NashvilleHousing
SET OwnerSpiltState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM NashvilleHousing


--------------------------------------------------------------------------------------

-- CHANGE Y AND N TO YES AND NO IN "Sold as Vaccant" FIELD

SELECT DISTINCT(SoldAsVacant)
FROM NashvilleHousing


SELECT SoldAsVacant,
CASE	
	WHEN SoldAsVacant = 'Y'	THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END
FROM NashvilleHousing


UPDATE NashvilleHousing
SET 
SoldAsVacant = CASE	
					WHEN SoldAsVacant = 'Y'	THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'NO'
					ELSE SoldAsVacant
				END

SELECT SoldAsVacant
FROM NashvilleHousing 
--WHERE SoldAsVacant = 'Y' AND SoldAsVacant = 'N' 

-------------------------------------------------------------------------------------------------


-- REMOVING DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------

-- DELETE UNUSED COLUMNS


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

