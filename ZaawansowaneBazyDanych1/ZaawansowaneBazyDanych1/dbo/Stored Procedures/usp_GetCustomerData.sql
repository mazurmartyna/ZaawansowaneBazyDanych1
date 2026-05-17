
CREATE   PROCEDURE dbo.usp_GetCustomerData
    @CustomerID     int = NULL,
    @FirstName    [dbo].[Name] = NULL,                                                               
    @LastName     [dbo].[M9_surname] = NULL,                                                                                                               
    @EmailAddress NVARCHAR (50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM [237679].Customer
    WHERE 
    (@CustomerID is NULL OR CustomerID = @CustomerID)
    AND (FirstName = @FirstName OR @FirstName is NULL)
    AND (LastName = @LastName OR @LastName is NULL)
    AND (EmailAddress = @EmailAddress OR @EmailAddress is NULL)
END;