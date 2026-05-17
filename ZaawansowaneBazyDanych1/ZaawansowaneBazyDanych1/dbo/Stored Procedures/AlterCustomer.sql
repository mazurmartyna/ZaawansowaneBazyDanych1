
CREATE   PROCEDURE dbo.AlterCustomer
    @CustomerID INT,
    @FirstName    [dbo].[Name],                                                               
    @LastName     [dbo].[M9_surname]                                                   
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [237679].Customer WHERE CustomerID = @CustomerID)
    BEGIN
        RAISERROR ('Rekord klienta nie istnieje', 16, 1);
        RETURN;
    END

    UPDATE [237679].Customer
    SET FirstName = @FirstName, 
        LastName = @LastName,
        ModifiedDate = GETDATE()
    WHERE CustomerID = @CustomerID

END