
CREATE   FUNCTION [237679].ufn_IsLastNameUnique
(                                                            
    @LastName     [dbo].[M9_surname]                                                                                                     
)
RETURNS BIT
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM [237679].Customer
        WHERE LastName = @Lastname
    )
        RETURN 0
    RETURN 1
END;