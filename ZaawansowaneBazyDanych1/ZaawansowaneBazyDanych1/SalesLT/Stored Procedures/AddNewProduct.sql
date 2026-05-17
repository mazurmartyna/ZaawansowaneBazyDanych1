
CREATE   PROCEDURE SalesLT.AddNewProduct
    @ProductName NVARCHAR(50),
    @ProductCategory  NVARCHAR(50),
    @ListPrice MONEY,
    @Amount INT,
    @ProductNumber NVARCHAR(65)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    IF @ListPrice <= 0
        THROW 50003, 'Cena musi być większa od zera.', 1;

    IF @Amount < 0
        THROW 50004, 'Ilość w magazynie nie może być ujemna.', 1;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE @CategoryID INT
        SELECT @CategoryID = ProductCategoryID 
        FROM SalesLt.ProductCategory
        WHERE [Name] = @ProductCategory

        INSERT INTO SalesLT.Product (
            [Name]
           ,[ProductNumber]
           ,[ProductCategoryID]
           ,[StandardCost]
           ,[ListPrice]
           ,[SellStartDate]
           ,[rowguid]
           ,[ModifiedDate])
        VALUES
           (
            @ProductName
           ,@ProductNumber
           ,@CategoryID
           ,@ListPrice
           ,@ListPrice
           ,GETDATE()
           ,NEWID() 
           ,GETDATE());

        DECLARE @ProductID int
        SET @ProductID = @@Identity

        INSERT INTO SalesLT.ProductInventory (ProductID, ProductAmount)
        VALUES (@ProductID, @Amount);

        COMMIT TRAN;
 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRAN;

        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END