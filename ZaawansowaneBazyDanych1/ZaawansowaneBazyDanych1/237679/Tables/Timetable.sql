CREATE TABLE [237679].[Timetable] (
    [TimetableID]   INT      IDENTITY (1, 1) NOT NULL,
    [RouteID]       INT      NULL,
    [StopID]        INT      NULL,
    [TramID]        INT      NULL,
    [DepartureTime] TIME (7) NULL,
    PRIMARY KEY CLUSTERED ([TimetableID] ASC),
    FOREIGN KEY ([RouteID]) REFERENCES [237679].[Routes] ([RouteID]),
    FOREIGN KEY ([StopID]) REFERENCES [237679].[TramStops] ([StopID]),
    FOREIGN KEY ([TramID]) REFERENCES [237679].[Tram] ([TramID])
);

