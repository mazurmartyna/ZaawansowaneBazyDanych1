CREATE TABLE [237679].[Trips] (
    [TripID]          INT  IDENTITY (1, 1) NOT NULL,
    [RouteID]         INT  NULL,
    [PlannedDuration] INT  NULL,
    [ActualDuration]  INT  NULL,
    [TripDate]        DATE NULL,
    PRIMARY KEY CLUSTERED ([TripID] ASC),
    FOREIGN KEY ([RouteID]) REFERENCES [237679].[Routes] ([RouteID])
);

