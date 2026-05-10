CREATE FUNCTION Student_9.ufn_ProductsJsonByCategory(
@CategoryName NVARCHAR(50)
)
RETURNS NVARCHAR(max) 
AS
BEGIN
    DECLARE @Product NVARCHAR(max)
    
    SELECT @Product =
    (
        SELECT
            p.ProductID,
            p.Name,
            p.ListPrice,
            pc.Name AS Category
        FROM SalesLT.Product p
        JOIN SalesLT.ProductCategory pc
            ON p.ProductCategoryID = pc.ProductCategoryID
        WHERE pc.Name = @CategoryName
        FOR JSON PATH
    );

    RETURN @Product;
END;