
CREATE FUNCTION [237679].ufn_CalculateDelays()
RETURNS @Delays TABLE
(
    TramNumber NVARCHAR(10),
    PlannedMinutes INT,
    ActualMinutes INT,
    DelayMinutes INT
)
AS
BEGIN

    INSERT INTO @Delays
    SELECT
        r.TramNumber,
        t.PlannedDuration,
        t.ActualDuration,
        t.ActualDuration - t.PlannedDuration
    FROM Trips t
    JOIN Routes r
        ON t.RouteID = r.RouteID;

    RETURN;
END;