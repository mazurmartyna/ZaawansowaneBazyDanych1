CREATE TABLE [dbo].[CustomerCopy] (
    [CustomerID]   INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]    [dbo].[Name]  NOT NULL,
    [LastName]     [dbo].[Name]  NOT NULL,
    [EmailAddress] NVARCHAR (50) NULL
);

