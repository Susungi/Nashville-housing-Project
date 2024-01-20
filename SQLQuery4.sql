SELECT 
  FROM [PORTFOLIO].[dbo].[Housing]

SELECT SaleDateConverted, CONVERT(Date, SaleDate) 
FROM [PORTFOLIO].[dbo].[Housing]


Alter Table [PORTFOLIO].[dbo].[Housing]
Add SaleDateConverted Date;

Update [PORTFOLIO].[dbo].[Housing]
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- looking for NULL values 

select * 
from [PORTFOLIO].[dbo].[Housing]
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [PORTFOLIO].[dbo].[Housing] a 
Join [PORTFOLIO].[dbo].[Housing] b 
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [PORTFOLIO].[dbo].[Housing] a 
Join [PORTFOLIO].[dbo].[Housing] b  
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null
   
  

-- Breaking down adresses into Induvidual Columns (Address, City, State)


 Select PropertyAddress 
 from [PORTFOLIO].[dbo].[Housing]


 Select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
 , SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
 from  [PORTFOLIO].[dbo].[Housing]

 Alter Table [PORTFOLIO].[dbo].[Housing]
Add PropertySplitAddress Nvarchar(255);

Update [PORTFOLIO].[dbo].[Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table [PORTFOLIO].[dbo].[Housing]
Add PropertySplitCity Nvarchar(255);

Update [PORTFOLIO].[dbo].[Housing]
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
from [PORTFOLIO].[dbo].[Housing]

------

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from [PORTFOLIO].[dbo].[Housing]

 Alter Table [PORTFOLIO].[dbo].[Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [PORTFOLIO].[dbo].[Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Alter Table [PORTFOLIO].[dbo].[Housing]
Add OwnerSplitCity Nvarchar(255);

Update [PORTFOLIO].[dbo].[Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Alter Table [PORTFOLIO].[dbo].[Housing]
Add OwnerSplitState Nvarchar(255);

Update [PORTFOLIO].[dbo].[Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


 Select * 
 from [PORTFOLIO].[dbo].[Housing]

 --change Y and N to Yes and No "Sold as Vacant" field

 Select Distinct (SoldAsVacant), Count (SoldAsVacant)
  from [PORTFOLIO].[dbo].[Housing]
  group by SoldAsVacant
  order by 2

  Select SoldAsVacant 
  , CASE when SoldAsVacant = 'Y' then 'Yes'
         when SoldAsVacant = 'N' then 'No'
		 ELSE SoldAsVacant
		 END
from [PORTFOLIO].[dbo].[Housing]

Update  [PORTFOLIO].[dbo].[Housing]
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
         when SoldAsVacant = 'N' then 'No'
		 ELSE SoldAsVacant
		 END



		----- Removing Duplicates and unused Columns 

With RowNumCTE as(
Select *, 
		Row_NUMBER () OVER ( 
	    PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
			 Order by UniqueID
			 ) row_num

From [PORTFOLIO].[dbo].[Housing]
) 
Select * 
from RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select * 
From [PORTFOLIO].[dbo].[Housing]

---
Alter Table [PORTFOLIO].[dbo].[Housing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















