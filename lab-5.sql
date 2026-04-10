-- =============================================
-- Martyna
-- Mazur
-- 237679
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- https://github.com/mazurmartyna/ZaawansowaneBazyDanych1.git

-- =============================================
-- Zadanie 2
-- =============================================
ALTER TABLE [237679].Customer
    ADD
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT getdate(),
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL default cast('9999-12-31 23:59:59.9999999' as DATETIME2),
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);
GO

ALTER TABLE [237679].Customer
   SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [237679].CustomerHistory));
GO


-- =============================================
-- Zadanie 3
-- =============================================

UPDATE [237679].Customer
SET MiddleName = 'Nieznane'
WHERE MiddleName is NULL;
GO

UPDATE [237679].Customer
SET Title = 'Ms.'
WHERE FirstName = 'Martyna';
GO

UPDATE [237679].Customer
SET CompanyName = 'Nieznane'
WHERE FirstName = 'Martyna';
GO


INSERT INTO [237679].Customer (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES ('Ala', 'Miller', 'xxxxx', 'xxxxx'),
    ('Anna', 'Moore', 'xxxxx', 'xxxxx'),
    ('Alex', 'Martin', 'xxxxx', 'xxxxx'),
    ('August', 'Murphy', 'xxxxx', 'xxxxx'),
    ('Alexandra', 'Morgan', 'xxxxx', 'xxxxx')
GO

-- =============================================
-- Zadanie 4
-- =============================================
SELECT * FROM [237679].Customer
FOR SYSTEM_TIME ALL
WHERE CustomerID = 30124;
GO
-- =============================================
-- Zadanie 5
-- =============================================
SELECT * FROM [237679].Customer
FOR SYSTEM_TIME AS OF '2026-04-10 19:39:48.5659520'
GO

-- =============================================
-- Zadanie 6
-- =============================================
CREATE XML SCHEMA COLLECTION ProductSchema AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Product" type="ProductType"/>
  <xs:complexType name="ProductType">
    <xs:sequence>
      <xs:element name="Name" type="xs:string"/>
      <xs:element name="Price" type="xs:decimal"/>
      <xs:element name="Weight" type="xs:decimal"/>
      <xs:element name="CompanyName" type="xs:string"/>
      <xs:element name="MainIngredient" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:schema>';
GO

CREATE TABLE [SalesLT].[ProductAttribute] (
    ProductID   int PRIMARY KEY,
    Info        xml(ProductSchema) NULL

    constraint FKPA foreign key (ProductID)
    references [SalesLT].[Product] (ProductID)
);
GO

-- =============================================
-- Zadanie 7
-- =============================================

INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Info)
VALUES (680, '<Product><Name>RoadFrame</Name><Price>1431.50</Price><Weight>1016.04</Weight><CompanyName>HL</CompanyName><MainIngredient>Steel</MainIngredient></Product>'),
(707, '<Product><Name>Helmet</Name><Price>34.99</Price><Weight>10</Weight><CompanyName>Sport</CompanyName><MainIngredient>Plastic</MainIngredient></Product>'),
(709, '<Product><Name>Socks</Name><Price>9.50</Price><Weight>2</Weight><CompanyName>Mountain Bike</CompanyName><MainIngredient>Cotton</MainIngredient></Product>'),
(712, '<Product><Name>Cap</Name><Price>8.99</Price><Weight>2</Weight><CompanyName>AWC</CompanyName><MainIngredient>Cotton</MainIngredient></Product>'),
(713, '<Product><Name>Jersey</Name><Price>49.99</Price><Weight>5</Weight><CompanyName>Unknown</CompanyName><MainIngredient>Cotton</MainIngredient></Product>');
GO

-- =============================================
-- Zadanie 8
-- =============================================

UPDATE [SalesLT].[ProductAttribute]
SET info.modify('
    replace value of (/Product/Name)[1]
    with concat("M", (/Product/Name)[1])
');
GO

UPDATE [SalesLT].[ProductAttribute]
SET info.modify('
    replace value of (/Product/CompanyName)[1]
    with concat("M", (/Product/CompanyName)[1])
');
GO

UPDATE [SalesLT].[ProductAttribute]
SET info.modify('
    replace value of (/Product/MainIngredient)[1]
    with concat("M", (/Product/MainIngredient)[1])
');
GO

-- =============================================
-- Zadanie 9
-- =============================================

DECLARE @json nvarchar(max) = N'{"Person": {"Name": "Martyna Mazur", "NrIndeksu":0 }}';
SET @json = JSON_MODIFY(@json, '$.Person.NrIndeksu', 237679);
GO