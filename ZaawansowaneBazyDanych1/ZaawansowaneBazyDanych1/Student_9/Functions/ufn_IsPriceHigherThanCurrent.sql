CREATE FUNCTION Student_9.ufn_IsPriceHigherThanCurrent(
@ProductData NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    
    declare @ProductID int
    declare @CurrentPrice money
    declare @NewPrice money

    SELECT @ProductID = ProductID, @NewPrice = NewPrice
    FROM OPENJSON(@ProductData)
    WITH(
        ProductID int,
        NewPrice money
        )
    SELECT @CurrentPrice = ListPrice 
    FROM SalesLT.Product
    WHERE ProductID = @ProductID

    IF @NewPrice > @CurrentPrice
       RETURN 1
    
    RETURN 0;
END;