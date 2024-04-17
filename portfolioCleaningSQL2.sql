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
  FROM [Project2].[dbo].[HousingOrg2]

  -------------------------------------------------------
  -- Cleaning Data in SQL Query

  ALTER TABLE HousingOrg2
  ADD DateToConverted Date;

  Update HousingOrg2
  SET DateToConverted = CONVERT(Date,SaleDate)

  Select DateToConverted, SaleDate
  From Project2..HousingOrg2

    --Populate PropertyAddress Address data
  Select *
  from Project2..HousingOrg2
  --where PropertyAddress is null
  order by ParcelID

  --Find same ParcelId of missing PropertyAddress in case repeated of parcelId

Select a.ParcelID, a.PropertyAddress,b.ParcelID,  b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  from Project2..HousingOrg2 a
  join Project2..HousingOrg2 b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Project2..HousingOrg2 a
  join Project2..HousingOrg2 b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from Project2..HousingOrg2
where PropertyAddress is null

--------------------------------------------------
--Breaking out Address into Individual Columns (Address, Cit, State)

Select PropertyAddress
  from Project2..HousingOrg2


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address2
--,CHARINDEX(',',PropertyAddress)-1
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address3
from HousingOrg2

ALTER TABLE HousingOrg2
  ADD PropertyAddress1 Nvarchar(225);

  Update HousingOrg2
  SET PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE HousingOrg2
  ADD PropertyCity1 Nvarchar(225);

  Update HousingOrg2
  SET PropertyCity1 = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

  Select *
  From HousingOrg2

  -----------------------------------------
   Select *
  From HousingOrg2

   Select OwnerAddress
  From HousingOrg2

  Select
  PARSENAME(REPLACE(OwnerAddress,',','.'),3)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  from HousingOrg2


 ALTER TABLE HousingORG2
  ADD OwnerSplitAddress Nvarchar(225);

  Update HousingOrg2
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

  ALTER TABLE HousingOrg2
  ADD OwnerSplitCity Nvarchar(225);

  Update HousingOrg2
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  ALTER TABLE HousingOrg2
  ADD OwnerSplitState Nvarchar(225);

  Update HousingOrg2
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

  select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
  From HousingOrg2

  --------------------------------------------------------
  --Change Y and N to Yes and No in "Sold as Vacant" field

  Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
  From HousingOrg2
  Group by SoldAsVacant
  order by 2

  Select  UniqueID,SoldAsVacant
  ,CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
  END as Isvacantsold
  from HousingOrg2
  order by [UniqueID ]

  Update HousingOrg2
  set SoldAsVacant = CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
  END
  

select *
from HousingOrg2

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
from HousingOrg2
)
--Select *
--From RowSpecCTE2
--where rowSpecNum > 1
--Order by PropertyAddress

Delete 
From RowSpecCTE2
where rowSpecNum > 1


-------------------------------------------------------------
/*--Delete Unused Columns

Select *
From Housing

ALTER TABLE Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Housing
Drop column SaleDate*/







































