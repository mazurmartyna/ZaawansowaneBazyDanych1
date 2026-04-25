CREATE VIEW SalesLT.v_NotSoldProductsDetails AS
SELECT 
    v.ProductID, v.Name, v.SellStartDate, p.ListPrice
FROM Student_9.MyLogicView v INNER JOIN SalesLT.Product p on v.ProductID= p.ProductID;