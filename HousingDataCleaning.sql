SELECT * from [Portfolio Project]..NashvilleHousingData

Select SaleDateConverted from [Portfolio Project]..NashvilleHousingData

Update NashvilleHousingData
SET SaleDate = CONVERT(Date, SaleDate)

ALTER Table NashvilleHousingData
Add SaleDateConverted Date;

Update NashvilleHousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)

ALTER Table NashvilleHousingData
DROP COLUMN SaleDate

-- Populate Address Property Data

SELECT * from [Portfolio Project]..NashvilleHousingData
-- where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,  b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousingData a
JOIN [Portfolio Project]..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.F1 <> b.F1
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousingData a
JOIN [Portfolio Project]..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.F1 <> b.F1
Where a.PropertyAddress is null

-- Breaking address into multiple columns

Select PropertyAddress
From [Portfolio Project]..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio Project]..NashvilleHousingData


ALTER TABLE NashvilleHousingData
Add Address Nvarchar(255);

Update NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousingData
Add City Nvarchar(255);

Update NashvilleHousingData
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From [Portfolio Project]..NashvilleHousingData


Select Address
From [PortfolioProject]..NashvilleHousingData


Select
PARSENAME(REPLACE(Address, ',', '.') , 3)
,PARSENAME(REPLACE(Address, ',', '.') , 2)
,PARSENAME(REPLACE(Address, ',', '.') , 1)
From [Portfolio Project]..NashvilleHousingData



ALTER TABLE NashvilleHousingData
Add Address Nvarchar(255);

Update NashvilleHousingData
SET Address = PARSENAME(REPLACE(Address, ',', '.') , 3)


ALTER TABLE NashvilleHousingData
Add City Nvarchar(255);

Update NashvilleHousingData
SET City = PARSENAME(REPLACE(City, ',', '.') , 2)



ALTER TABLE NashvilleHousingData
Add State Nvarchar(255);

Update NashvilleHousingData
SET State = PARSENAME(REPLACE(Address, ',', '.') , 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field
Select *
From [Portfolio Project]..NashvilleHousingData


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PortfolioProject]..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project]..NashvilleHousingData


Update NashvilleHousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					F1
					) row_num

From [Portfolio Project]..NashvilleHousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio Project]..NashvilleHousingData



-- Delete Unused Columns



Select *
From [Portfolio Project]..NashvilleHousingData


ALTER TABLE [Portfolio Project]..NashvilleHousingData
DROP COLUMN TaxDistrict, Grade, Bedrooms, [Full Bath], [Half Bath]

