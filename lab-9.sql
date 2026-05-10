-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE FUNCTION SalesLT.fn_BestRecord 
(
    @Price money = 63.50,
    @SellStartDate datetime = '2007-07-01 00:00:00.000',
    @ProductColor NVARCHAR(50) = 'Blue'
)
RETURNS int
AS
BEGIN
    DECLARE @Result int

    SELECT top 1 @Result = [ProductID]
    FROM SalesLT.v_237679_order
    WHERE ListPrice >= @Price AND SellStartDate >= @SellStartDate AND Color = @ProductColor
    ORDER BY  ListPrice ASC
    RETURN @Result
END;
GO

-- =============================================
-- Zadanie 2
-- =============================================

SELECT TOP 25 ProductID, Name, ListPrice
INTO ##TopProducts
FROM SalesLT.Product
WHERE SellEndDate IS Null
ORDER BY ListPrice ASC;
go

CREATE FUNCTION Student_9.ufn_CalcAdjustedPrices()
RETURNS @Summary table(
    ProductID int,
    ListPrice money
)
AS
BEGIN
    INSERT INTO @Summary
    SELECT
        ProductID,
        ListPrice - (ListPrice * 0.05)
    FROM ##TopProducts;
    RETURN;
END;
GO

-- =============================================
-- Zadanie 3
-- =============================================

CREATE FUNCTION Student_9.ufn_ProductsJsonByCategory(
@CategoryName NVARCHAR(50)
)
RETURNS NVARCHAR(max) 
AS
BEGIN
    DECLARE @Product NVARCHAR(max)
    
    SELECT @Product =
    (
        SELECT
            p.ProductID,
            p.Name,
            p.ListPrice,
            pc.Name AS Category
        FROM SalesLT.Product p
        JOIN SalesLT.ProductCategory pc
            ON p.ProductCategoryID = pc.ProductCategoryID
        WHERE pc.Name = @CategoryName
        FOR JSON PATH
    );
    RETURN @Product;
END;
GO

-- =============================================
-- Zadanie 4
-- =============================================

CREATE FUNCTION Student_9.ufn_IsPriceHigherThanCurrent(
@ProductData NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    
    declare @ProductID int
    declare @CurrentPrice money
    declare @NewPrice money

    SELECT @ProductID = ProductID, @NewPrice = NewPrice
    FROM OPENJSON(@ProductData)
    WITH(
        ProductID int,
        NewPrice money
        )
    SELECT @CurrentPrice = ListPrice 
    FROM SalesLT.Product
    WHERE ProductID = @ProductID

    IF @NewPrice > @CurrentPrice
       RETURN 1
    
    RETURN 0;
END;
GO
-- Je¿eli cena bêdzie równa to funkcja zwróci wartoœæ 0, odpowiadaj¹c¹ FALSE

-- =============================================
-- Zadanie 5
-- =============================================
CREATE FUNCTION Student_9.ufn_ProductsWithHigherPrice()
RETURNS table
AS
RETURN (
    SELECT ProductID, Name, ListPrice,
    Student_9.ufn_IsPriceHigherThanCurrent(
    N'{"ProductID":706,"NewPrice":1500}') 
    as IsThePriceHigher
    FROM SalesLT.Product
    WHERE ProductID = 706
)
GO

-- =============================================
-- Zadanie 6
-- =============================================
-- Scenariusz - Komunikacja miejska - rozk³ady jazdy tramwajów, przystanki,

CREATE TABLE [237679].Routes
(
    RouteID INT PRIMARY KEY IDENTITY,
    TramNumber NVARCHAR(10),
    StartStop NVARCHAR(100),
    EndStop NVARCHAR(100)
);

INSERT INTO [237679].Routes VALUES
('1','Salwator','Wzg. Krzes³awickie'),
('3','Krowodrza Górka P+R','Nowy Bie¿anów P+R'),
('4','Bronowice Ma³e','Wzg. Krzes³awickie'),
('52','Os.Piastów','Czerwone Maki'),
('8','Borek Fa³êcki','Bronowice Ma³e')

CREATE TABLE [237679].TramStops
(
    StopID INT PRIMARY KEY IDENTITY,
    StopName NVARCHAR(100),
);

INSERT INTO [237679].TramStops(StopName) VALUES
('Salwator'),('Filharmonia'),('Plac Wszystkich Œwiêtych'),
('Poczta G³ówna'),('Teatr S³owackiego'),('Lubicz')


CREATE TABLE [237679].Tram
(
    TramID INT PRIMARY KEY IDENTITY,
    TramNumberID NVARCHAR(20),
);


INSERT INTO [237679].Tram VALUES
('KR123'),('AB123'),('BC321'),('CD432'),('DE543')

CREATE TABLE [237679].Timetable
(
    TimetableID INT PRIMARY KEY IDENTITY,
    RouteID INT,
    StopID INT,
    TramID INT,
    DepartureTime TIME,

    FOREIGN KEY (RouteID)
        REFERENCES [237679].Routes(RouteID),

    FOREIGN KEY (StopID)
        REFERENCES [237679].TramStops(StopID),

    FOREIGN KEY (TramID)
        REFERENCES [237679].Tram(TramID)
);

INSERT INTO [237679].Timetable (RouteID, StopID, TramID, DepartureTime)
VALUES
(1, 1, 1, '06:15'),
(1, 1, 1, '07:00'),
(1, 2, 1, '06:25'),
(2, 1, 2, '08:10');


CREATE TABLE [237679].Trips
(
    TripID INT PRIMARY KEY IDENTITY,
    RouteID INT,
    PlannedDuration INT,
    ActualDuration INT,
    TripDate DATE,

    FOREIGN KEY (RouteID)
        REFERENCES [237679].Routes(RouteID)
);
GO

--iTVF (inline table-valued function),
--Pasa¿er chce sprawdziæ wszystkie tramwaje odje¿d¿aj¹ce z wybranego przystanku po okreœlonej godzinie.

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
    FROM  [237679].Timetable t
    JOIN  [237679].TramStops s
        ON t.StopID = s.StopID
    JOIN  [237679].Routes r
        ON t.RouteID = r.RouteID
    WHERE s.StopName = @StopName
      AND t.DepartureTime > @AfterTime
);
GO

--mTVF (multi-statement table-valued function),
--System monitoringu komunikacji miejskiej ma wyliczaæ rzeczywiste opóŸnienie tramwajów wzglêdem planowanego czasu przejazdu.

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
    FROM  [237679].Trips t
    JOIN  [237679].Routes r
        ON t.RouteID = r.RouteID;

    RETURN;
END;
GO

-- widok
-- Pokazuje ca³¹ trasê danej linii: przystanki + godziny odjazdu + tramwaj.

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
GO
-- funkcja skalarna.
-- Oblicza czy tramwaj jest opóŸniony wzglêdem rozk³adu

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
GO

-- =============================================
-- Zadanie 7
-- =============================================

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
GO