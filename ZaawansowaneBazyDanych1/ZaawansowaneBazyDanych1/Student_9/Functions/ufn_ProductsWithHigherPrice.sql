CREATE FUNCTION Student_9.ufn_ProductsWithHigherPrice()
RETURNS table
AS
RETURN (
    SELECT ProductID, Name, ListPrice,
    Student_9.ufn_IsPriceHigherThanCurrent(
    N'{"ProductID":706,"NewPrice":1500}') 
    as IsThePriceHigher
    FROM SalesLT.Product
    WHERE ProductID = 706

)