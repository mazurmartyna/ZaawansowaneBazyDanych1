
CREATE FUNCTION dbo.fn_GetCustomerCreditRisk(@CustomerID int)
RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @TotalMoneySpent money
    DECLARE @LateOrders int
    DECLARE @Orders table (
    TotalDue money,
    OrderDate datetime,
    DueDate datetime
    )

    INSERT INTO @Orders 
    SELECT TotalDue, OrderDate,DueDate
    FROM SalesLT.SalesOrderHeader
    WHERE CustomerID = @CustomerID

    SELECT @TotalMoneySpent = sum(TotalDue)
    FROM @Orders 
    
    SELECT @LateOrders =  count(*) 
    FROM @Orders WHERE datediff(day, OrderDate, DueDate) > 3

    IF @TotalMoneySpent > 100000 AND @LateOrders >= 2
        Return 'HIGH'
    IF @TotalMoneySpent > 50000
        Return 'MEDIUM'
    
    Return 'LOW'
END;