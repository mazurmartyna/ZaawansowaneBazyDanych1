CREATE TABLE [dbo].[ShipmentCustomerDetails] (
    [SalesorderID] INT            NOT NULL,
    [Status]       VARCHAR (50)   NULL,
    [CustomerID]   INT            NULL,
    [CompanyName]  NVARCHAR (128) NULL,
    [EmailAddress] NVARCHAR (50)  NULL
);

