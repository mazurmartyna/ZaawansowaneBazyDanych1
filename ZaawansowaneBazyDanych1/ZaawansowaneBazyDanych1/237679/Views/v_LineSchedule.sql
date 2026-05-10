
CREATE VIEW [237679].v_LineSchedule
AS
SELECT
    r.TramNumber,
    s.StopName,
    t.DepartureTime,
    b.TramNumberID
FROM [237679].Timetable t
JOIN [237679].Routes r
    ON t.RouteID = r.RouteID
JOIN [237679].TramStops s
    ON t.StopID = s.StopID
JOIN [237679].Tram b
    ON t.TramID = b.TramID;