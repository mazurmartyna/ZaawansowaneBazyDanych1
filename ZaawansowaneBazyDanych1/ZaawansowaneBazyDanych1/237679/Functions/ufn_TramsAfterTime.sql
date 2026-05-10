
CREATE FUNCTION [237679].ufn_TramsAfterTime
(
    @StopName NVARCHAR(100),
    @AfterTime TIME
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        r.TramNumber,
        s.StopName,
        t.DepartureTime
    FROM Timetable t
    JOIN TramStops s
        ON t.StopID = s.StopID
    JOIN Routes r
        ON t.RouteID = r.RouteID
    WHERE s.StopName = @StopName
      AND t.DepartureTime > @AfterTime
);