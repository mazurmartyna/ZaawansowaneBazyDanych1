CREATE TABLE [237679].[Customer] (
    [CustomerID]   INT                                         IDENTITY (1, 1) NOT NULL,
    [NameStyle]    [dbo].[NameStyle]                           CONSTRAINT [DF_Customer_NameStyle] DEFAULT ((0)) NOT NULL,
    [Title]        NVARCHAR (8)                                NULL,
    [FirstName]    [dbo].[Name]                                NOT NULL,
    [MiddleName]   [dbo].[Name]                                NULL,
    [LastName]     [dbo].[M9_surname]                          NOT NULL,
    [Suffix]       NVARCHAR (10)                               NULL,
    [CompanyName]  NVARCHAR (128)                              NULL,
    [SalesPerson]  NVARCHAR (256)                              NULL,
    [EmailAddress] NVARCHAR (50)                               NULL,
    [Phone]        [dbo].[Phone]                               NULL,
    [PasswordHash] VARCHAR (128)                               NOT NULL,
    [PasswordSalt] VARCHAR (10)                                NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER                            CONSTRAINT [DF_Customer_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate] DATETIME                                    CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [SysStartTime] DATETIME2 (7) GENERATED ALWAYS AS ROW START DEFAULT (getdate()) NOT NULL,
    [SysEndTime]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [AK_Customer_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC),
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
);








GO
CREATE NONCLUSTERED INDEX [IX_Customer_EmailAddress]
    ON [237679].[Customer]([EmailAddress] ASC);


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