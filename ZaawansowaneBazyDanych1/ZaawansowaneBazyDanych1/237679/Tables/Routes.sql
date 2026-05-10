CREATE TABLE [237679].[Routes] (
    [RouteID]    INT            IDENTITY (1, 1) NOT NULL,
    [TramNumber] NVARCHAR (10)  NULL,
    [StartStop]  NVARCHAR (100) NULL,
    [EndStop]    NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([RouteID] ASC)
);

