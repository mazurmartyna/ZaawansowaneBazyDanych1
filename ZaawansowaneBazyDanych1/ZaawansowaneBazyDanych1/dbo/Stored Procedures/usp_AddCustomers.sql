
CREATE   PROCEDURE dbo.usp_AddCustomers                              
    @FirstName    [dbo].[Name],                                                               
    @LastName     [dbo].[M9_surname],                                                                                                                
    @EmailAddress NVARCHAR (50) = NULL,                              
    @Phone        [dbo].[Phone] = NULL
AS
BEGIN
    DECLARE @NameExists BIT 
    SELECT @NameExists = [237679].ufn_IsLastNameUnique(@LastName)

    IF @NameExists = 1
    BEGIN
        INSERT INTO [237679].Customer (FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt,rowguid,ModifiedDate)
        VALUES (@FirstName, @LastName, @EmailAddress, @Phone, 
        'LNoK27abGQo48gGue3EBV/UrlYSToV0/s87dCRV7uJl=', 'YTNH5Rw=','FF862851-1DAA-4044-BE7C-3E85583C054E', getdate());
    END    
    ELSE
        PRINT 'Customer already exists.';
        
END;