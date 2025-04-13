-- lab 5
USE SaleManagement_lab5;
-- Insert additional  data 
INSERT INTO Salesman (Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target, Target_Achieved, Phone) VALUES
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');

INSERT INTO SalesOrder (Order_Number, Order_Date, Client_Number, Salesman_Number, Delivery_Status, Delivery_Date, Order_Status) VALUES
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');

INSERT INTO SalesOrderDetails (Order_Number, Product_Number, Order_Quantity) VALUES
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

SELECT * FROM Salesman;
SELECT * FROM SalesOrder;
SELECT * FROM SalesOrderDetails;

-- 1.Display the clients (name) who lives in same city.
SELECT c1.Client_Name, c1.City
FROM Clients c1
WHERE c1.City IN (
    SELECT City
    FROM Clients
    GROUP BY City
    HAVING COUNT(*) > 1
);

-- 2.Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
SELECT c.City, c.Client_Name, s.Salesman_Name
FROM Clients c, Salesman s
WHERE c.City = 'Thu Dau Mot'
AND s.City = 'Thu Dau Mot';
   
-- 3.Display client name, client number, order number, salesman number, and product number for each order.
SELECT c.Client_Name, c.Client_Number, so.Order_Number, so.Salesman_Number, sod.Product_Number
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
JOIN SalesOrderDetails sod ON so.Order_Number =sod.Order_Number;

-- 4.Find each order (client_number, client_name, order_number) placed by each client. 
SELECT c.Client_Number, c.Client_Name, so.Order_Number
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number;

-- 5.Display the details of clients (client_number, client_name) and the number of orders which is paid by them.
SELECT c.Client_Number, c.Client_Name, COUNT(so.Order_Number) AS NumberOfOrders
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Successful'
GROUP BY c.Client_Number, c.Client_Name;

-- 6.Display the details of clients (client_number, client_name) who have paid for more than 2 orders. 
SELECT c.Client_Number, c.Client_Name
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Successful'
GROUP BY c.Client_Number, c.Client_Name
HAVING COUNT(so.Order_Number) > 2;

-- 7.Display details of clients who have paid for more than 1 order in descending order of client_number.
SELECT c.Client_Number, c.Client_Name, COUNT(so.Order_Number) AS OrderCount
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Successful'
GROUP BY c.Client_Number, c.Client_Name
HAVING COUNT(so.Order_Number) > 1
ORDER BY c.Client_Number DESC;

-- 8.Find the salesman names who sells more than 20 products.
SELECT s.Salesman_Name, SUM(sod.Order_Quantity) AS TotalSold
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
GROUP BY s.Salesman_Number, s.Salesman_Name
HAVING SUM(sod.Order_Quantity) > 20;

-- 9.Display the client information (client_number, client_name) and order number of those clients who have order status is cancelled.
SELECT c.Client_Number, c.Client_Name, so.Order_Number
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Cancelled';

-- 10.Display client name, client number of clients C101 and count the number of orders which were received “successful”.
SELECT c.Client_Number, c.Client_Name, COUNT(so.Order_Number) AS SuccessfulOrders
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
WHERE c.Client_Number = 'C101'
  AND so.Order_Status = 'Successful'
GROUP BY c.Client_Number, c.Client_Name;

-- 11.Count the number of clients orders placed for each product.
SELECT sod.Product_Number, COUNT(so.Order_Number) AS OrderCount
FROM SalesOrderDetails sod
JOIN SalesOrder so ON sod.Order_Number = so.Order_Number
GROUP BY sod.Product_Number;

-- 12.Find product numbers that were ordered by more than two clients then order in descending by product number.
SELECT sod.Product_Number
FROM SalesOrderDetails sod
JOIN SalesOrder so ON sod.Order_Number = so.Order_Number
GROUP BY sod.Product_Number
HAVING COUNT(DISTINCT so.Client_Number) > 2
ORDER BY sod.Product_Number DESC;


-- IV.Using nested query with operator (IN, EXISTS, ANY and ALL)
-- 13.Find the salesman’s names who is getting the second highest salary.
SELECT Salesman_Name
FROM Salesman
WHERE Salary = (
     SELECT MAX(Salary)
     FROM Salesman
     WHERE Salary < (SELECT MAX(Salary) FROM Salesman)
);

-- 14.Find the salesman’s names who is getting second lowest salary.
SELECT Salesman_Name
FROM Salesman
WHERE Salary = (
     SELECT MIN(Salary)
     FROM Salesman
     WHERE Salary > (SELECT MIN(Salary) FROM Salesman)
);

-- 15.Write a query to find the name and the salary of the salesman who have a higher salary than the salesman whose salesman number is S001.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary > (SELECT Salary FROM Salesman WHERE Salesman_Number = 'S001');

-- 16.Write a query to find the name of all salesman who sold the product has number: P1002.
SELECT DISTINCT s.Salesman_Name
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
WHERE sod.Product_Number = 'P1002';

-- 17.Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
SELECT DISTINCT s.Salesman_Name
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
WHERE so.Client_Number = 'C108'
AND so.Delivery_Status = 'Delivered';

-- 18.Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal to 5.
SELECT DISTINCT p.Product_Name
FROM Product p
JOIN SalesOrderDetails sod ON p.Product_Number = sod.Product_Number
WHERE sod.Order_Quantity = 5;

-- 19.Write a query to find the name and number of the salesman who sold pen or TV or laptop. 
SELECT DISTINCT s.Salesman_Number, s.Salesman_Name
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE p.Product_Name IN ('Pen', 'TV', 'Laptop');

-- 20.Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand more than 50.
SELECT DISTINCT s.Salesman_Name
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE p.Sell_Price < 800
AND p.Quantity_On_Hand > 50;

-- 21.Write a query to find the name and salary of the salesman whose salary is greater than the average salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary > (SELECT AVG(Salary) FROM Salesman);

-- 22.Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the average amount paid.
SELECT Client_Name, Amount_Paid
FROM Clients
WHERE Amount_Paid > (SELECT AVG(Amount_Paid) FROM Clients);


-- V.Additional excersices:
-- 23.Find the product price that was sold to Le Xuan.
SELECT DISTINCT p.Sell_Price
FROM Product p
JOIN SalesOrderDetails sod ON p.Product_Number = sod.Product_Number
JOIN SalesOrder so ON sod.Order_Number = so.Order_Number
JOIN Clients c ON so.Client_Number = c.Client_Number
WHERE c.Client_Name = 'Le Xuan';

-- 24.Determine the product name, client name and amount due that was delivered.
SELECT DISTINCT p.Product_Name, c.Client_Name, c.Amount_Due
FROM SalesOrder so
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
JOIN Clients c ON so.Client_Number = c.Client_Number
WHERE so.Delivery_Status = 'Delivered';

-- 25.Find the salesman’s name and their product name which is cancelled.
SELECT DISTINCT s.Salesman_Name, p.Product_Name
FROM SalesOrder so
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Salesman s ON so.Salesman_Number = s.Salesman_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE so.Order_Status = 'Cancelled';

-- 26.Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
SELECT DISTINCT p.Product_Name, p.Sell_Price, so.Delivery_Status
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE c.Client_Name = 'Nguyen Thanh';

-- 27.Display the product name, sell price, salesperson name, delivery status, and order quantity information for each customer.
SELECT c.Client_Name, p.Product_Name, p.Sell_Price, s.Salesman_Name, so.Delivery_Status, sod.Order_Quantity
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
JOIN Salesman s ON so.Salesman_Number = s.Salesman_Number;

-- 28.Find the names, product names, and order dates of all sales staff whose product order status has been successful but the items have not yet been delivered to the client.
SELECT DISTINCT s.Salesman_Name, p.Product_Name, so.Order_Date
FROM SalesOrder so
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
JOIN Salesman s ON so.Salesman_Number = s.Salesman_Number
WHERE so.Order_Status = 'Successful'
AND so.Delivery_Status <> 'Delivered';

-- 29.Find each clients’ product which in on the way.
SELECT c.Client_Name, p.Product_Name
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE so.Delivery_Status = 'On Way';

-- 30.Find salary and the salesman’s names who is getting the highest salary
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary = (SELECT MAX(Salary) FROM Salesman);

-- 31.Find salary and the salesman’s names who is getting second lowest salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary = (
     SELECT MIN(Salary)
     FROM Salesman
     WHERE Salary > (SELECT MIN(Salary) FROM Salesman)
);

-- 32.Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more than 9.
SELECT DISTINCT p.Product_Name
FROM Product p
JOIN SalesOrderDetails sod ON p.Product_Number = sod.Product_Number
WHERE sod.Order_Quantity > 9;

-- 33.Find the name of the customer who ordered the same item multiple times.
SELECT DISTINCT c.Client_Name
FROM (
     SELECT so.Client_Number, sod.Product_Number, COUNT(*) AS cnt
     FROM SalesOrder so
     JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
     GROUP BY so.Client_Number, sod.Product_Number
     HAVING COUNT(*) > 1
     ) t
JOIN Clients c ON t.Client_Number = c.Client_Number;

-- 34.Write a query to find the name, number and salary of the salemans who earns less than the average salary and works in any of Thu Dau Mot city.
SELECT Salesman_Number, Salesman_Name, Salary
FROM Salesman
WHERE Salary < (SELECT AVG(Salary) FROM Salesman)
AND City = 'Thu Dau Mot';

-- 35.Write a query to find the name, number and salary of the salemans who earn a salary that is higher than the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to highest.
SELECT s.Salesman_Number, s.Salesman_Name, s.Salary
FROM Salesman s
WHERE s.Salary > ALL (
       SELECT s2.Salary
       FROM Salesman s2
       JOIN SalesOrder so ON s2.Salesman_Number = so.Salesman_Number
       WHERE so.Order_Status = 'Cancelled'
     )
ORDER BY s.Salary ASC;

-- 36.Write a query to find the 4th maximum salary on the salesman’s table.
SELECT DISTINCT Salary
FROM Salesman
ORDER BY Salary DESC
LIMIT 1 OFFSET 3;

-- 37.Write a query to find the 3th minimum salary in the salesman’s table.
SELECT DISTINCT Salary
FROM Salesman
ORDER BY Salary ASC
LIMIT 1 OFFSET 2;
   
   