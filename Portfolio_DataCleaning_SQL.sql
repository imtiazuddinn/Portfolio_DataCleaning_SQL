/* cleaning data  in Sql queries */

select * from nashvillehousing

--Standardize Date fromat 

ALter table nashvillehousing Add SaleDateConverted date;

update  nashvillehousing set SaleDateConverted = Convert(date,SaleDate)

select SaleDateConverted from nashvillehousing

--impute missing data in property address columns 
select  * from nashvillehousing

select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashvillehousing a 
join nashvillehousing b 
On a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID  where a.PropertyAddress is Null

update a 
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashvillehousing a 
join nashvillehousing b 
On a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID  where a.PropertyAddress is Null

select * from nashvillehousing 

--Breaking out address into individual columns (Address, city , state )
select * from nashvillehousing

select PropertyAddress, SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1,LEN(PropertyAddress)) As city 
from nashvillehousing


ALter table nashvillehousing Add PropertysplitAddress varchar(250);
ALter table nashvillehousing Add Propertsplitcity varchar(250);

update  nashvillehousing set PropertysplitAddress = SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1)
update  nashvillehousing set Propertsplitcity = SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1,LEN(PropertyAddress))

select OwnerAddress from nashvillehousing

select PARSENAME(replace(OwnerAddress,',','.'),1)  As state,
PARSENAME(replace(OwnerAddress,',','.'),2) As city,
PARSENAME(replace(OwnerAddress,',','.'),3) As Address from nashvillehousing



ALter table nashvillehousing Add ownersplitAddress varchar(250);
ALter table nashvillehousing Add ownersplitcity varchar(250);
ALter table nashvillehousing Add ownersplitstate varchar(250);


update  nashvillehousing set ownersplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3) 
update  nashvillehousing set ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'),2) 
update  nashvillehousing set ownersplitstate=PARSENAME(replace(OwnerAddress,',','.'),1) 



-- Change Y and No to Yes and No in SoldAsVacant Columns 

select DISTINCT(SoldAsVacant) from nashvillehousing

select SoldAsVacant,
CASE 
	when SoldAsVacant='Y' then 'yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	ENd
from nashvillehousing

update nashvillehousing 
set SoldAsVacant=CASE 
	when SoldAsVacant='Y' then 'yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	ENd


select distinct(SoldAsVacant) from nashvillehousing


--Removing Duplicate rows

select * from nashvillehousing

with temp_row_num as  (select *, 
	ROW_NUMBER() over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference order by 
				 UniqueID) As row_num from nashvillehousing ) 
delete from temp_row_num where row_num>1

select * from (select *, 
	ROW_NUMBER() over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference order by 
				 UniqueID) As row_num from nashvillehousing) x where x.row_num>1


-- Deleting unused columns 

 

ALter table nashvillehousing 
drop column PropertyAddress,OwnerAddress,TaxDistrict,SaleDate



