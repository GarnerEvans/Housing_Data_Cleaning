select * from housing

--standardize sale date format

alter table housing
alter column saledate type date using (saledate::date)

select saledate from housing

--Breaking out address into individual columns (Adress, City, State)

select PropertyAddress
from housing 

select
substring(
PropertyAddress, 0, STRPOS(PropertyAddress, ',') 
) as Address,
substring(
PropertyAddress, STRPOS(PropertyAddress, ',') +1, Length(propertyaddress)
) as Address
from housing

alter table housing 
add PropertySplitAddress VARCHAR(255)

update housing 
set PropertySplitAddress = substring(PropertyAddress, 0, STRPOS(PropertyAddress, ',') )

alter table housing 
add PropertySplitCity VARCHAR(255)

update housing 
set PropertySplitCity = substring(PropertyAddress, STRPOS(PropertyAddress, ',') +1, Length(propertyaddress)
)

select * from housing 

-- change y and n to yes and no in "Sold as Vacant" field

select Distinct(SoldasVacant), count(SoldasVacant)
from housing h 
group by soldasvacant 
order by 2

select soldasvacant
, 
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'no'
else soldasvacant
END
from housing

update housing 
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'no'
else soldasvacant
end

--Remove Duplicates

with RowNumCTE AS(
select *,
	row_number() over (
	partition by parcelid, propertyaddress, saleprice, saledate, legalreference
	) row_num
from housing)

delete from RowNumCTE
where row_num > 1

--Delete Unused Columuns

select * from housing

alter table housing 
drop column OwnerAddress

alter table housing 
drop column PropertyAddress

alter table housing 
drop column SaleDate







