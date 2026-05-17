-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
CREATE OR ALTER PROCEDURE dbo.usp_AddCustomers                              
    @FirstName    [dbo].[Name],                                                               
    @LastName     [dbo].[M9_surname],                                                                                                                
    @EmailAddress NVARCHAR (50) = NULL,                              
    @Phone        [dbo].[Phone] = NULL
AS
BEGIN
    INSERT INTO [237679].Customer 
    (FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt,rowguid,ModifiedDate)
    VALUES (@FirstName, @LastName, @EmailAddress, @Phone, 
    'LNoK27abGQo48gGue3EBV/UrlYSToV0/s87dCRV7uJl=', 'YTNH5Rw=','FF862851-1DAA-4044-BE7C-3E85583C054E', getdate());
END;
GO

-- =============================================
-- Zadanie 2
-- =============================================

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerData
    @CustomerID     int = NULL,
    @FirstName    [dbo].[Name] = NULL,                                                               
    @LastName     [dbo].[M9_surname] = NULL,                                                                                                               
    @EmailAddress NVARCHAR (50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM [237679].Customer
    WHERE 
    (@CustomerID is NULL OR CustomerID = @CustomerID)
    AND (FirstName = @FirstName OR @FirstName is NULL)
    AND (LastName = @LastName OR @LastName is NULL)
    AND (EmailAddress = @EmailAddress OR @EmailAddress is NULL)
END;
GO

-- =============================================
-- Zadanie 3
-- =============================================

-- Nie da siê wykonaæ tego zadania, poniewa¿ w procedurach parametr OUTPUT nie mo¿e byæ zmienn¹ tabeleryczn¹

-- =============================================
-- Zadanie 4
-- =============================================
--Zakladamy ¿e wystarczy unikalne nazwisko

CREATE OR ALTER FUNCTION [237679].ufn_IsLastNameUnique
(                                                            
    @LastName     [dbo].[M9_surname]                                                                                                     
)
RETURNS BIT
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM [237679].Customer
        WHERE LastName = @Lastname
    )
        RETURN 0
    RETURN 1
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddCustomers                              
    @FirstName    [dbo].[Name],                                                               
    @LastName     [dbo].[M9_surname],                                                                                                                
    @EmailAddress NVARCHAR (50) = NULL,                              
    @Phone        [dbo].[Phone] = NULL
AS
BEGIN
    DECLARE @NameExists BIT 
    SELECT @NameExists = [237679].ufn_IsLastNameUnique(@LastName)

    IF @NameExists = 1
    BEGIN
        INSERT INTO [237679].Customer (FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt,rowguid,ModifiedDate)
        VALUES (@FirstName, @LastName, @EmailAddress, @Phone, 
        'LNoK27abGQo48gGue3EBV/UrlYSToV0/s87dCRV7uJl=', 'YTNH5Rw=','FF862851-1DAA-4044-BE7C-3E85583C054E', getdate());
    END    
    ELSE
        PRINT 'Customer already exists.';
        
END;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE OR ALTER PROCEDURE dbo.AlterCustomer
    @CustomerID INT,
    @FirstName    [dbo].[Name],                                                               
    @LastName     [dbo].[M9_surname]                                                   
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [237679].Customer WHERE CustomerID = @CustomerID)
    BEGIN
        RAISERROR ('Rekord klienta nie istnieje', 16, 1);
        RETURN;
    END

    UPDATE [237679].Customer
    SET FirstName = @FirstName, 
        LastName = @LastName,
        ModifiedDate = GETDATE()
    WHERE CustomerID = @CustomerID

END
GO

-- =============================================
-- Zadanie 6
-- =============================================

CREATE TABLE SalesLT.ProductInventory (
    ProductID INT PRIMARY KEY,
    ProductAmount int
);
GO

CREATE OR ALTER PROCEDURE SalesLT.AddNewProduct
    @ProductName NVARCHAR(50),
    @ProductCategory  NVARCHAR(50),
    @ListPrice MONEY,
    @Amount INT,
    @ProductNumber NVARCHAR(65)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    IF @ListPrice <= 0
        THROW 50003, 'Cena musi byæ wiêksza od zera.', 1;

    IF @Amount < 0
        THROW 50004, 'Iloœæ w magazynie nie mo¿e byæ ujemna.', 1;

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
GO
-- =============================================
-- Zadanie 7
-- =============================================

CREATE TABLE ##TopProducts
(
    ProductID INT,
    [Name] NVARCHAR(50),
    ListPrice MONEY
);

INSERT INTO #TopProducts
SELECT TOP 25 ProductID, [Name], ListPrice
FROM SalesLT.Product
WHERE SellEndDate IS Null
ORDER BY ListPrice ASC;
GO

DECLARE @Summary TABLE
    (
        ProductID INT,
        [Name] NVARCHAR(50),
        ListPrice MONEY,
        NewPrice MONEY
    );
GO
-- Zmienna tabelaryczna ma nie byæ deklarowana w ciele procedury, 
-- wiêc nie mo¿na siê do niej odwo³aæ w procedurze
-- zadanie nie ma rozwi¹zania

CREATE OR ALTER PROCEDURE Student_9.AdjustedPrices
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO @Summary
    SELECT
        ProductID,
        [Name],
        ListPrice,
        ListPrice - (ListPrice * 0.09) as NewPrice
    FROM ##TopProducts;

    SELECT * FROM @Summary
END;
GO

