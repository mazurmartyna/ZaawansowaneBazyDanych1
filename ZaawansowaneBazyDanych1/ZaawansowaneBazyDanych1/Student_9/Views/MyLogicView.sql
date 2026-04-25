CREATE VIEW Student_9.MyLogicView AS
SELECT 
    p.ProductID, p.Name, p.SellStartDate
FROM SalesLT.Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM SalesLT.SalesOrderdetail od 
    WHERE p.ProductID = od.ProductID)
    AND SellEndDate IS NULL AND DiscontinuedDate IS NULL