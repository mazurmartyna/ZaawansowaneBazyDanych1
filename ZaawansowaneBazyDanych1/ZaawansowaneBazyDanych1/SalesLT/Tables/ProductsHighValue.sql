CREATE TABLE [SalesLT].[ProductsHighValue] (
    [HighValueProductID] INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]          INT           NULL,
    [VendorID]           INT           NULL,
    [Name]               NVARCHAR (50) NULL,
    [ProductNumber]      NVARCHAR (25) NULL,
    [ListPrice]          MONEY         NULL,
    [StandardPrice]      MONEY         NULL,
    PRIMARY KEY CLUSTERED ([HighValueProductID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

