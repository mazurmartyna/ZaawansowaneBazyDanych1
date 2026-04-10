CREATE TABLE [SalesLT].[ProductBOM] (
    [BOMID]              INT             NULL,
    [ParentProductID]    INT             NOT NULL,
    [ComponentProductID] INT             NOT NULL,
    [Quantity]           DECIMAL (18, 2) DEFAULT ((1.0)) NULL,
    [InstructionStep]    INT             NULL,
    CONSTRAINT [PK_ProductBom] PRIMARY KEY CLUSTERED ([ParentProductID] ASC, [ComponentProductID] ASC),
    CONSTRAINT [FK_BOM_Component] FOREIGN KEY ([ComponentProductID]) REFERENCES [SalesLT].[Product] ([ProductID]),
    CONSTRAINT [FK_BOM_Parent] FOREIGN KEY ([ParentProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProductBOM_ComponentProductID_BOMID]
    ON [SalesLT].[ProductBOM]([ComponentProductID] ASC, [BOMID] ASC);

