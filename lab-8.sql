-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE TABLE SalesLT.ProductPriceHistory (
    PriceChangeID         INT IDENTITY PRIMARY KEY,
    ProductID       INT,
    OldPrice        DECIMAL(12,2),
    NewPrice        DECIMAL(12,2),
    ChangedBy       SYSNAME      DEFAULT SYSTEM_USER,
    ChangedAt       DATETIME2    DEFAULT SYSDATETIME()
);
GO

CREATE TRIGGER SalesLT.trg_Product_PriceChange
ON SalesLT.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SalesLT.ProductPriceHistory (ProductID, OldPrice, NewPrice)
    SELECT 
        i.ProductID,
        d.ListPrice AS OldPrice,
        i.ListPrice AS NewPrice
    FROM INSERTED i
    JOIN DELETED d ON i.ProductID = d.ProductID
    WHERE ISNULL(d.ListPrice, -1) <> ISNULL(i.ListPrice, -1);
END;
GO

-- =============================================
-- Zadanie 2
-- =============================================

CREATE TABLE SalesLT.DeletedCustomersLog (
    LogID INT Identity PRIMARY KEY,
    CustomerID   INT,
	Title nvarchar(8) NULL,
	FirstName [dbo].[Name] NOT NULL,
	MiddleName [dbo].[Name] NULL,
	LastName [dbo].[M9_surname] NOT NULL,
	Suffix nvarchar(10) NULL,
	CompanyName nvarchar(128) NULL,
	SalesPerson nvarchar(256) NULL,
	EmailAddress nvarchar(50) NULL,
	Phone [dbo].[Phone] NULL,
	PasswordHash varchar(128) NOT NULL,
	PasswordSalt varchar(10) NOT NULL,
	rowguid [uniqueidentifier] NOT NULL,
	ModifiedDate   [datetime] NOT NULL
);
GO

CREATE TRIGGER [237679].trg_Customer_PreventDelete
ON [237679].Customer
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SalesLT.DeletedCustomersLog 
    (CustomerID, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, 
    Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
    SELECT 
    d.CustomerID, d.Title, d.FirstName, d.MiddleName, d.LastName, d.Suffix, d.CompanyName, d.SalesPerson, d.EmailAddress, 
    d.Phone, d.PasswordHash, d.PasswordSalt, d.rowguid, d.ModifiedDate
    FROM DELETED d
    WHERE EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader soh 
    WHERE d.CustomerID = soh.CustomerID)
    
 
    DELETE c FROM [237679].Customer c
    INNER JOIN DELETED d ON c.CustomerID = d.CustomerID
    WHERE NOT EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader soh 
    WHERE d.CustomerID = soh.CustomerID)
END;
GO

-- =============================================
-- Zadanie 3
-- =============================================

WITH CategoryHierarchy AS
(
    SELECT 
        ProductCategoryID,
        ParentProductCategoryID,
        CAST(Name AS nvarchar(max)) AS Path
    FROM SalesLT.ProductCategory
    WHERE ParentProductCategoryID IS NULL

    UNION ALL

    SELECT 
        c.ProductCategoryID,
        c.ParentProductCategoryID,
        ch.Path + ' -> ' + c.Name
    FROM SalesLT.ProductCategory c
    JOIN CategoryHierarchy ch 
        ON c.ParentProductCategoryID = ch.ProductCategoryID
)
SELECT Path
FROM CategoryHierarchy
GO

-- =============================================
-- Zadanie 4
-- =============================================

CREATE TRIGGER trg_PriceChangeUpdateCheck
ON SalesLT.Product
FOR UPDATE
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM INSERTED i JOIN DELETED d ON i.ProductID = d.ProductID
        WHERE i.ListPrice > d.ListPrice * 1.20
    )
    BEGIN
        INSERT INTO dbo.ErrorLog (ErrorMessage, ErrorTime)
        VALUES ('Price increase > 20%', GETDATE());
            
        THROW 50000, 'ListPrice cannot change by more than 20%', 1;
    END
END;
GO

-- =============================================
-- Zadanie 5
-- =============================================

Create table dbo.DatabaseAuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(100),
    ObjectName NVARCHAR(256),
    LoginName NVARCHAR(256),
    EventTime DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_DatabaseAuditLogChanges
ON DATABASE
FOR ALTER_TABLE, DROP_TABLE, CREATE_TABLE
AS
BEGIN
    SET NOCOUNT ON;
   
    BEGIN
        Insert Into dbo.DatabaseAuditLog(EventType,ObjectName, LoginName)
        Select  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
                EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(256)'),
                ORIGINAL_LOGIN()
    END
END;
GO

-- =============================================
-- Zadanie 6
-- =============================================

-- Tworzymy now¹ tabelê która zawiera tylko produkty High Value - o wartoœci ListPrice wiêkszej ni¿ 150
-- Tabela ta jest rozszerzona o VendorID, który sprzedaje dany produkt
-- Nastepnie tworzymy zapytanie CTE ktore dodatkowo zawê¿a nam zakres produktów, pokazuj¹c tylko te o ListPrice wiêkszej ni¿ œrednia wszystkich produktów

CREATE TABLE SalesLT.ProductsHighValue (
    HighValueProductID INT IDENTITY PRIMARY KEY,
    ProductID INT,
    VendorID INT,
    Name NVARCHAR (50),
    ProductNumber NVARCHAR (25),
    ListPrice MONEY,
    StandardPrice MONEY,
    FOREIGN KEY (ProductID) REFERENCES SalesLT.Product(ProductID)
);

INSERT INTO SalesLT.ProductsHighValue (ProductID, VendorID, Name, ProductNumber, ListPrice, StandardPrice)
SELECT p.ProductID, VendorID, Name, ProductNumber, p.ListPrice, v.StandardPrice
FROM SalesLT.Product p inner join SalesLT.ProductVendor v on p.ProductID = v.ProductID
WHERE ListPrice > 150;

WITH HigherThanAvgPriceProducts AS
(
    SELECT *
    FROM SalesLT.ProductsHighValue
    WHERE ListPrice > (
        SELECT AVG(ListPrice) 
        FROM SalesLT.Product
    )
)
SELECT *
FROM HigherThanAvgPriceProducts
ORDER BY ListPrice DESC;

    
