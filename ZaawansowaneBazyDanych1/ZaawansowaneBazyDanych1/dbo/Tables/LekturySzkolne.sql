CREATE TABLE [dbo].[LekturySzkolne] (
    [KsiazkaID] INT             NOT NULL,
    [Tytul]     NVARCHAR (50)   NULL,
    [Autor]     NVARCHAR (50)   NULL,
    [Ocena]     DECIMAL (10, 2) NULL,
    PRIMARY KEY CLUSTERED ([KsiazkaID] ASC)
);

