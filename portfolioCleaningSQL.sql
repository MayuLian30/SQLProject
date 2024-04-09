SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Project2].[dbo].[Housing]

  -------------------------------------------------------
  -- Cleaning Data in SQL Query
  Select DateConverted, CONVERT(Date, SaleDate)
  From Project2..Housing

  Update Housing
  SET SaleDate = CONVERT(Date,SaleDate)


  ALTER TABLE Housing
  ADD DateConverted Date;

  Update Housing
  SET DateConverted = CONVERT(date, SaleDate)

  --Populate PropertyAddress Address data
  Select *
  from Project2..Housing
  --where PropertyAddress is null
  order by ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID,  b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  from Project2..Housing a
  join Project2..Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Project2..Housing a
  join Project2..Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------
--Breaking out Address into Individual Columns (Address, Cit, State)

Select PropertyAddress
  from Project2..Housing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
--,CHARINDEX(',',PropertyAddress)-1
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from Housing

ALTER TABLE Housing
  ADD PropertyAddress1 Nvarchar(225);

  Update Housing
  SET PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE Housing
  ADD PropertyCity1 Nvarchar(225);

  Update Housing
  SET PropertyCity1 = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

  Select *
  From Housing

  -----------------------------------------
   Select *
  From Housing

   Select OwnerAddress
  From Housing

  Select
  PARSENAME(REPLACE(OwnerAddress,',','.'),3)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  from Housing


 ALTER TABLE Housing
  ADD OwnerSplitAddress Nvarchar(225);

  Update Housing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

  ALTER TABLE Housing
  ADD OwnerSplitCity Nvarchar(225);

  Update Housing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  ALTER TABLE Housing
  ADD OwnerSplitState Nvarchar(225);

  Update Housing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

  select *
  From Housing

  --------------------------------------------------------
  --Change Y and N to Yes and No in "Sold as Vacant" field

  Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
  From Housing
  Group by SoldAsVacant
  order by 2

  Select  UniqueID,SoldAsVacant
  ,CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
  END
  from Housing
  order by [UniqueID ]

  Update Housing
  set SoldAsVacant = CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
  END
  

select *
from Housing

----------------------------------------------------
--Romove Duplicate


;WITH RowSpecCTE2 AS 
(
select * ,
	Row_Number() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID ) rowSpecNum
from Housing
)
Select *
From RowSpecCTE2
where rowSpecNum > 1

--Order by PropertyAddress


-------------------------------------------------------------
--Delete Unused Columns

Select *
From Housing

ALTER TABLE Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Housing
Drop column SaleDate







































