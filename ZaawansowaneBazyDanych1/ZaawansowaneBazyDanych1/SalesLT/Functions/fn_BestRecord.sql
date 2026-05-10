
CREATE FUNCTION SalesLT.fn_BestRecord 
(
    @Price money = 63.50,
    @SellStartDate datetime = '2007-07-01 00:00:00.000',
    @ProductColor NVARCHAR(50) = 'Blue'
)
RETURNS int
AS
BEGIN
    DECLARE @Result int

    SELECT top 1 @Result = [ProductID]
    FROM SalesLT.v_237679_order
    WHERE ListPrice >= @Price AND SellStartDate >= @SellStartDate AND Color = @ProductColor
    ORDER BY  ListPrice ASC
    RETURN @Result
END;