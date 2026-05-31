-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

SELECT DISTINCT
    pc.Name AS CategoryName,
    MIN(p.ListPrice) OVER (
        PARTITION BY p.ProductCategoryID
    ) AS CheapestInCategory,
    MAX(p.ListPrice) OVER (
        PARTITION BY p.ProductCategoryID
    ) AS MostExpensiveInCategory,
    COUNT(p.ProductID) OVER (
        PARTITION BY p.ProductCategoryID
    ) AS ProductCount
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID;

-- =============================================
-- Zadanie 2
-- =============================================
--Scenariusz przedstawia ranking lektur szkolnych wed³ug ocen czytelników (z platformy goodreads). 
--Funkcja okienkowa DENSE_RANK() pozwala nadaæ ksi¹¿kom miejsca w rankingu od najlepiej ocenionej do najs³abiej ocenionej.

CREATE TABLE dbo.LekturySzkolne (
    KsiazkaID INT PRIMARY KEY,
    Tytul NVARCHAR(50),
    Autor  NVARCHAR(50),
    Ocena DECIMAL(10,2)
);

INSERT INTO LekturySzkolne VALUES
(1, 'Makbet', 'William Szekspir', 3.9 ),
(2, 'Lalka', 'Boleslaw Prus',3.8 ),
(3, 'Zbrodnia i kara', 'Fiodor Dostojewski',4.3 ),
(4, 'Wesele', 'Stanis³aw Wyspiañski',3.2 ),
(5, 'Dzuma', 'Albert Camus', 4.0 );
GO

SELECT 
    DENSE_RANK() OVER (ORDER BY Ocena DESC) AS DenseBookRank,
    KsiazkaID,
    Tytul,
    Autor,
    Ocena
FROM dbo.LekturySzkolne ;

-- =============================================
-- Zadanie 3
-- =============================================

-- Pokazanie ile albumów w danym roku wyda³ dany wykonawca
-- Zapytanie PIVOT pozwala przedstawiæ lata jako kolumny, dziêki czemu ³atwo porównaæ aktywnoœæ wykonawców. 
-- Zapytanie UNPIVOT pozwala przekszta³ciæ te dane z powrotem z 'szerokich' na 'dlugie', w celu czytelniejszego analizowania liczby albumów wykonawcy w danym roku

CREATE TABLE dbo.AlbumyMuzyczne (
    AlbumID INT PRIMARY KEY,
    Wykonawca NVARCHAR(50),
    Album  NVARCHAR(50),
    RokWydania int
);

INSERT INTO AlbumyMuzyczne VALUES
(1, 'Noah Kahan', 'The Great Divide', 2026),
(2, 'Taylor Swift', 'The Life of a Showgirl', 2025),
(3, 'Noah Kahan','Stick Season (Forever)', 2024),
(4, 'Taylor Swift', 'THE TORTURED POETS DEPARTMENT', 2024),
(5, 'Taylor Swift', '1989 (Taylors Version)', 2023);
GO

SELECT *
into #pivotTable
FROM (
    SELECT AlbumID, Wykonawca, RokWydania
    FROM dbo.AlbumyMuzyczne 
) src
PIVOT
(
    COUNT(AlbumID)
    FOR RokWydania IN ([2026], [2025], [2024],[2023])
) AS pvt;

select * from #pivotTable

SELECT Wykonawca, LiczbaAlbumow
FROM #pivotTable
UNPIVOT
(
    LiczbaAlbumow FOR AlbumID IN ([2026])
) AS unpvt;

-- =============================================
-- Zadanie 4
-- =============================================
-- Sklep rowerowy analizuje liczbê sztuk rowerów dostêpnych w magazynie. 
-- Zapytanie z ROLLUP pokazuje sumê sztuk dla ka¿dego modelu, sumê dla danego typu roweru oraz sumê ca³kowit¹ dla ca³ego sklepu.

CREATE TABLE dbo.BazaSklepuRowerowego (
    RowerID INT PRIMARY KEY,
    TypRoweru NVARCHAR(50),
    Model  NVARCHAR(50),
    IloscSztuk int
);

INSERT INTO BazaSklepuRowerowego VALUES
(1, 'Gorski', 'MTB PRO', 10),
(2, 'Gorski', 'Full', 5),
(3, 'Gorski', 'Enduro', 7),
(4, 'Szosowy', 'Aero', 5),
(5, 'Szosowy', 'Ultra light', 10);
GO

SELECT 
    TypRoweru,
    Model,
    SUM(IloscSztuk) AS LacznaIlosc
FROM dbo.BazaSklepuRowerowego
GROUP BY ROLLUP (TypRoweru, Model);
GO