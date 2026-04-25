-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE TYPE M9_surname FROM NVARCHAR(50) NOT NULL;
GO

ALTER TABLE [237679].Customer
ALTER COLUMN LastName M9_surname;

-- =============================================
-- Zadanie 2
-- =============================================

DECLARE @ProductInfo nvarchar(max) = N'
    { "Product" : [
        {"ProductID": 710, "NewPrice": 10},
        {"ProductID": 711, "NewPrice": 32},
        {"ProductID": 712, "NewPrice": 10},
        {"ProductID": 713, "NewPrice": 52},
        {"ProductID": 714, "NewPrice": 48}]
    }';
GO

CREATE VIEW SalesLT.v_ProductNewPrices AS
SELECT p.ProductID, p.ListPrice, NewPrice 
FROM SalesLT.Product p inner join OPENJSON(@ProductInfo, '$.Product')
WITH (
    ProductID int '$.ProductID',
    NewPrice int '$.NewPrice'
) j on p.ProductID = j.ProductID;
GO

-- Nie da siê wykonaæ tego zadania gdy zmienna nie jest definiowana w ramach tworzonego widoku, a przed nim, 
-- gdy¿ CREATE VIEW musi byæ jedynym statement w batchu, co oznacza, i¿ nie da siê u¿yæ wczeœniej zdefiniowej zmiennej w widoku

-- =============================================
-- Zadanie 3
-- =============================================

CREATE VIEW SalesLT.v_237679_order AS
SELECT TOP 300 * 
FROM SalesLT.Product
ORDER BY ProductNumber DESC;
GO

-- =============================================
-- Zadanie 4
-- =============================================

-- Logika biznesowa: Przedstawienie produktów w sprzeda¿y, których dotychczas nigdy nie sprzedano
-- Pokazanie ProductID, Nazwy produktu oraz daty rozpoczêcia sprzeda¿y
-- Potrzeba biznesowa: Zlokalizowanie zalegaj¹cych produktów, które siê nie sprzedaj¹, wraz z dat¹ rozpoczêcia sprzeda¿y
-- dziêki czemu ³atwiej zadecydowaæ, czy produkty te powinny zostaæ wycofane ze sprzeda¿y

CREATE VIEW Student_9.MyLogicView AS
SELECT 
    p.ProductID, p.Name, p.SellStartDate
FROM SalesLT.Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM SalesLT.SalesOrderdetail od 
    WHERE p.ProductID = od.ProductID)
    AND SellEndDate IS NULL AND DiscontinuedDate IS NULL;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE VIEW SalesLT.v_NotSoldProductsDetails AS
SELECT 
    v.ProductID, v.Name, v.SellStartDate, p.ListPrice
FROM Student_9.MyLogicView v INNER JOIN SalesLT.Product p on v.ProductID= p.ProductID;
GO


