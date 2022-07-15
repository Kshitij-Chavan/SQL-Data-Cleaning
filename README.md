# SQL-Data-Cleaning
In this project I'll be cleaning data in SQL. Using various functions, CTE and Windows function. 

## Steps that I took to clean up the data :

### Standerdize the Dates :
1. In this particular step I've seperated the date and time
2. Basically converted Date-Time into Date using function CONVERT(Date,Column name)
3. And updated the repective column with the new date format


### Populate Property Address Data :
1. In this step I've generated property address where the field is NULL.
2. First of all I've done SELF-JOIN table using the ParcelID and PropertyAddress.
3. So that I can compare the ParcelId and PropertyAddress
4. Because there are some entries with both same parcelId but one of them missing the PropertyAddress.
5. So copying the data of in another table is done by using ISNULL().


### Breaking out Address into Individual columns : 
1. Breaking out the address in seprated column such Address, City, State.
2. Using ',' to seperate the data.
3. There are two ways to that first one is SUBSTRING() this is tricky method.
4. And another one using PARSNAME().


### Change Y and N to Yes and No in the Sold as Vaccant field :
1. There are four entires in the Sold as Vaccant column field in the form of Y, N, Yes, NO.
2. To view unique entries in the column I use Distinct() or you can use count(), GROUP BY.
3. So using the case statement I've Alter the values.


### Removing Duplicates :
1. To have the good insights of the data we should the remove the duplicates.
2. Use ROW_NUMBER() function in Partion by to get the row numbers.
3. If the ROW_NUMBER = 1 then it is legit and otherwise delete the row if you are getting ROW_NUMBER value greater than 1.


### Delete Unused Column (Not Neeeded) :
1. To maintain the for further use delete unused column.
