CREATE TABLE [dbo].[BazaSklepuRowerowego] (
    [RowerID]    INT           NOT NULL,
    [TypRoweru]  NVARCHAR (50) NULL,
    [Model]      NVARCHAR (50) NULL,
    [IloscSztuk] INT           NULL,
    PRIMARY KEY CLUSTERED ([RowerID] ASC)
);

