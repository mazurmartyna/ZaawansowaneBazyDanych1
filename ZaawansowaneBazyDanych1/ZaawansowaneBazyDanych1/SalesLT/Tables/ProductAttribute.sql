CREATE TABLE [SalesLT].[ProductAttribute] (
    [ProductID] INT                                NOT NULL,
    [Info]      XML(CONTENT [dbo].[ProductSchema]) NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FKPA] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

