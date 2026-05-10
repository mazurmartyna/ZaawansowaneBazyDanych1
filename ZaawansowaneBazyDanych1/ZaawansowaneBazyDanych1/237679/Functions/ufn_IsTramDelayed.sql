
CREATE FUNCTION [237679].ufn_IsTramDelayed
(
    @PlannedTime time,
    @ActualTime time
)
RETURNS BIT
AS
BEGIN

    DECLARE @Result BIT;

    IF @ActualTime > @PlannedTime
        SET @Result = 1;
    ELSE
        SET @Result = 0;

    RETURN @Result;
END;