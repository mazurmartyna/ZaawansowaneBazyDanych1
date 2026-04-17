-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- Sesja 1

BEGIN TRAN;

UPDATE SalesLT.Product
SET ListPrice = 1432
WHERE ProductID = 717;

WAITFOR DELAY '00:00:30';

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 2
WHERE ProductID = 717;

ROLLBACK;

-- Sesja 2

BEGIN TRAN;

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 2
WHERE ProductID = 717;

WAITFOR DELAY '00:00:30';

UPDATE SalesLT.Product
SET ListPrice = 1432
WHERE ProductID = 717;

ROLLBACK;
GO
-- Pierwsza sesja blokuje tabelę SalesLT.Product a druga w tym samym czasie tabelę SalesLT.SalesOrderDetail,
-- Następnie obie sesje na wzajem próbują użyć zasobu blokowanego przez drugą sesję, 
-- przez co żadna z nich nie jest w stanie dokończyć transakcji
-- Powstaje deadlock, a server automatycznie kończy jedną z tych transakcji
-- Przypadek ten jest niebezpieczny gdyż tracimy jedną z transakcji (zostaje wycofana), i jednocześnie dane / zmiany które miała ona wprowadzić

-- =============================================
-- Zadanie 2
-- =============================================

BEGIN TRAN

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 2
WHERE SalesOrderID >= 71774 AND SalesOrderID <= 71780;

UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductID >= 710 AND ProductID <= 722;

INSERT INTO [237679].Customer (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES ('Bella', 'Miller', 'xxxxx', 'xxxxx'),
    ('Brian', 'Moore', 'xxxxx', 'xxxxx'),
    ('Brooke', 'Martin', 'xxxxx', 'xxxxx'),
    ('Brady', 'Murphy', 'xxxxx', 'xxxxx'),
    ('Beata', 'Morgan', 'xxxxx', 'xxxxx'),
    ('Bartosz', 'Smith', 'xxxxx', 'xxxxx'),
    ('Bogumila', 'Jones', 'xxxxx', 'xxxxx'),
    ('Brian', 'Taylor', 'xxxxx', 'xxxxx'),
    ('Bobby', 'Brown', 'xxxxx', 'xxxxx'),
    ('Ben', 'Williams', 'xxxxx', 'xxxxx')

TRUNCATE TABLE [237679].CustomerAddress

SELECT * FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID >= 71774 AND SalesOrderID <= 71780;

SELECT * FROM SalesLT.Product
WHERE ProductID >= 710 AND ProductID <= 722;

SELECT * FROM [237679].Customer
WHERE CustomerID > 30134

SELECT * FROM [237679].CustomerAddress

ROLLBACK TRAN;

SELECT * FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID >= 71774 AND SalesOrderID <= 71780;

SELECT * FROM SalesLT.Product
WHERE ProductID >= 710 AND ProductID <= 722;

SELECT * FROM [237679].Customer
WHERE CustomerID > 30134

SELECT * FROM [237679].CustomerAddress

GO

-- Select przed oraz po Rollback pokazuje inne stany tabel
-- Po ponownym wyświetleniu wybranych tablic, widzimy iż wykonane przez nas zmiany zostały cofnięte po kommendzie Rollback

-- =============================================
-- Zadanie 3
-- =============================================

BEGIN TRAN;

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 2
WHERE SalesOrderID >= 71774 AND SalesOrderID <= 71780;
WAITFOR DELAY '00:05:0';

UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductID >= 710 AND ProductID <= 722;
WAITFOR DELAY '00:05:0';

INSERT INTO [237679].Customer (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES ('Bella', 'Miller', 'xxxxx', 'xxxxx'),
    ('Brian', 'Moore', 'xxxxx', 'xxxxx'),
    ('Brooke', 'Martin', 'xxxxx', 'xxxxx'),
    ('Brady', 'Murphy', 'xxxxx', 'xxxxx'),
    ('Beata', 'Morgan', 'xxxxx', 'xxxxx'),
    ('Bartosz', 'Smith', 'xxxxx', 'xxxxx'),
    ('Bogumila', 'Jones', 'xxxxx', 'xxxxx'),
    ('Brian', 'Taylor', 'xxxxx', 'xxxxx'),
    ('Bobby', 'Brown', 'xxxxx', 'xxxxx'),
    ('Ben', 'Williams', 'xxxxx', 'xxxxx')
WAITFOR DELAY '00:05:0';

TRUNCATE TABLE [237679].CustomerAddress
WAITFOR DELAY '00:05:0';

ROLLBACK TRAN;

-- Sesja 2 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRAN;

SELECT * FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID >= 71774 AND SalesOrderID <= 71780;

SELECT * FROM SalesLT.Product
WHERE ProductID >= 710 AND ProductID <= 722;

SELECT * FROM [237679].Customer
WHERE CustomerID > 30134

SELECT * FROM [237679].CustomerAddress

GO

-- =============================================
-- Zadanie 4
-- =============================================

BEGIN TRY
    UPDATE SalesLT.Product
    SET ListPrice = ListPrice / 0 
    WHERE ProductID = 717;

END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO


-- =============================================
-- Zadanie 5
-- =============================================

-- Scenariusz: Klient chce anulować zamówienie
-- Podaje nam swoje dane: CustomerID, SalesOrderID
-- Sprawdzamy poprawność danych 
-- Jeżeli CustomerId nie istnieje w bazie danych to zwracamy błąd
-- Jeżeli CustomerId jest niepoprawny (wartość mniejsza od 1) to zwracamy błąd
-- Sprawdzamy czy przysyłka jest już wysłana: 
-- Jeżeli tak to klient otrzymuje informacje o braku mozliwosci anulowania zamowienia
-- Jeżeli przesyłka nie została jeszcze wysłana (nie ma statusu shipped w bazie danych)
-- To jej SalesOrderId zostaje usunięty z Tabeli SalesOrderHeader oraz SalesOrderDetails

declare @CustomerID int= 29847
declare @SalesOrderID int = 71774

BEGIN TRY 
    IF NOT EXISTS  (SELECT 1
    FROM [237679].Customer
    WHERE CustomerID = @CustomerID)
 
    throw 50001, 'Error - CustomerID not found in database',1;

    IF @CustomerID < 1
    throw 50001, 'Error - incorrect CustomerID',1;

    IF EXISTS (SELECT Status FROM SalesLT.ShipmentTrackingEvents
    WHERE Status = 'Shipped' AND SalesOrderID = @SalesOrderID)
    throw 50001, 'Order cannot be cancelled - the order has been shipped',1;

    ELSE 
    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID

    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID;
    
    PRINT 'Order has been cancelled successfully'

END TRY

BEGIN CATCH
    PRINT 'Something went wrong, please try again or contact customer support'
    SELECT ERROR_MESSAGE() as ErrorMessage;
END CATCH;
GO

-- =============================================
-- Zadanie 6
-- =============================================

declare @CustomerID int= 29847
declare @SalesOrderID int = 71774

BEGIN TRY 
    BEGIN TRAN;

    IF NOT EXISTS  (SELECT 1
    FROM [237679].Customer
    WHERE CustomerID = @CustomerID)
 
    throw 50001, 'Error - CustomerID not found in database',1;

    IF @CustomerID < 1
    throw 50001, 'Error - incorrect CustomerID',1;

    IF EXISTS (SELECT Status FROM SalesLT.ShipmentTrackingEvents
    WHERE Status = 'Shipped' AND SalesOrderID = @SalesOrderID)
    throw 50001, 'Order cannot be cancelled - the order has been shipped',1;

    ELSE 
    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID

    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID;
    
    COMMIT TRAN;
    PRINT 'Order has been cancelled successfully';

END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRAN;

    PRINT 'Something went wrong, please try again or contact customer support';
    SELECT ERROR_MESSAGE() as ErrorMessage;
END CATCH;
GO