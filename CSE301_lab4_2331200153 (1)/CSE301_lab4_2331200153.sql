CREATE DATABASE SaleManagementLab4;
USE SaleManagementLab4;

CREATE TABLE Clients (
    Client_Number varchar(10) ,
    Client_Name varchar(25) not null,
    Address varchar(30),
    City varchar(30),
    Pincode int not null,
    Province char(25),
    Amount_Paid decimal(15,4),
    Amount_Due decimal(15,4),
    CHECK (Client_Number LIKE "C%"), -- LIKE la ham so sanh chu cai
    primary key (Client_Number)
);

CREATE TABLE Product (
    Product_Number VARCHAR(15) ,
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Quantity_On_Hand INT NOT NULL,
    Quantity_Sell INT NOT NULL,
    Sell_Price DECIMAL(15,4) NOT NULL,
    Cost_Price DECIMAL(15,4) NOT NULL,
    CHECK (Product_Number LIKE "P%"),
    CHECK (Cost_Price <> 0),
    PRIMARY KEY(Product_Number)
);

CREATE TABLE Salesman (
    Salesman_Number VARCHAR(15) ,
    Salesman_Name VARCHAR(25) NOT NULL,
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT NOT NULL,
    Province CHAR(25) DEFAULT 'Vietnam',
    Salary DECIMAL(15,4) NOT NULL, 
    Sales_Target INT NOT NULL, 
    Target_Achieved INT,
    Phone CHAR(10) NOT NULL UNIQUE,
    CHECK (Salesman_Number like "S%"),
    CHECK (Salary <> 0),
    CHECK (Sales_Target <> 0),
    PRIMARY KEY(Salesman_Number)
);

CREATE TABLE SalesOrder (
    Order_Number VARCHAR(15),
    Order_Date DATE,
    Client_Number VARCHAR(10),
    Salesman_Number VARCHAR(15),
    Delivery_Status CHAR(15), 
    Delivery_Date DATE, 
    Order_Status VARCHAR(15), 
    PRIMARY KEY(Order_Number),
    FOREIGN KEY (Client_Number) REFERENCES Clients(Client_Number),
    FOREIGN KEY (Salesman_Number) REFERENCES Salesman(Salesman_Number),
    CHECK (Order_Number like "O%"),
    CHECK (Client_Number like "C%"),
    CHECK (Salesman_Number like "S%"),
    CHECK (Delivery_Status IN ('Delivered', 'On Way', 'Ready to Ship')),
    CHECK (Delivery_Date > Order_Date),
    CHECK (Order_Status IN ('In Process', 'Successful', 'Cancelled'))
);

CREATE TABLE SalesOrderDetails (
    Order_Number VARCHAR(15),
    Product_Number VARCHAR(15),
    Order_Quantity INT,
    CHECK (Order_Number like "O%"),
    CHECK (Product_Number LIKE "P%"),
    FOREIGN KEY (Order_Number) 
    REFERENCES SalesOrder(Order_Number),
    FOREIGN KEY (Product_Number) 
    REFERENCES Product(Product_Number)
);

INSERT INTO Clients (Client_Number, Client_Name, Address, City, Pincode, Province, Amount_Paid, Amount_Due) VALUES
('C101','Mai Xuan','Phu Hoa','Dai An',700001,'Binh Duong',10000,5000),
('C102','Le Xuan','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',18000,3000),
('C103','Trinh Huu','Phu Loi','Da Lat',700051,'Lam Dong',7000,3200),
('C104','Tran Tuan','Phu Tan','Thu Dau Mot',700080,'Binh Duong',8000,0),
('C105','Ho Nhu','Chanh My','Hanoi',700005,'Hanoi',7000,150),
('C106','Tran Hai','Phu Hoa','Ho Chi Minh',700002,'Ho Chi Minh',7000,1300),
('C107','Nguyen Thanh ','Hoa Phu','Dai An',700023,'Binh Duong',8500,7500),
('C108','Nguyen Sy','Tan An','Da Lat',700032,'Lam Dong',15000,1000),
('C109','Duong Thanh','Phu Hoa','Ho Chi Minh',700011,'Ho Chi Minh',12000,8000),
('C110','Tran Minh','Phu My','Hanoi',700005,'Hanoi',9000,1000);

INSERT INTO Product (Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price) VALUES
('P1001','TV',10,30,1000,800),
('P1002','Laptop',12,25,1500,1100),
('P1003','AC',23,10,400,300),
('P1004','Modem',22,16,250,230),
('P1005','Pen',19,13,12,8),
('P1006','Mouse',5,10,100,105),
('P1007','Keyboard',45,60,120,90),
('P1008','Headset',63,75,50,40);

INSERT INTO Salesman (Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target, Target_Achieved, Phone) VALUES
('S001','Huu','Phu Tan','Ho Chi Minh',700002,'Ho Chi Minh',15000,50,35,'0902361123'),
('S002','Phat','Tan An','Hanoi',700005,'Hanoi',25000,100,110,'0903216542'),
('S003','Khoa','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',17500,40,30,'0904589632'),
('S004','Tien','Phu Hoa','Dai An',700023,'Binh Duong',16500,70,72,'0908654723'),
('S005','Deb','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,60,48,'0903213659'),
('S006','Tin','Chanh My','Da Lat',700032,'Lam Dong',20000,80,55,'0907853497');

INSERT INTO SalesOrder (Order_Number, Order_Date, Client_Number, Salesman_Number, Delivery_Status, Delivery_Date, Order_Status) VALUES
('O20001','2022-01-15','C101','S003','Delivered','2022-02-10','Successful'),
('O20002','2022-01-25','C102','S003','Delivered','2022-02-15','Cancelled'),
('O20003','2022-01-31','C103','S002','Delivered','2022-04-03','Successful'),
('O20004','2022-02-10','C104','S003','Delivered','2022-04-23','Successful'),
('O20005','2022-02-18','C101','S003','On Way',NULL,'Cancelled'),
('O20006','2022-02-22','C105','S005','Ready to Ship',NULL,'In Process'),
('O20007','2022-04-03','C106','S001','Delivered','2022-05-08','Successful'),
('O20008','2022-04-16','C102','S006','Ready to Ship',NULL,'In Process'),
('O20009','2022-04-24','C101','S004','On Way',NULL,'Successful'),
('O20010','2022-04-29','C106','S006','Delivered','2022-05-08','Successful'),
('O20011','2022-05-08','C107','S005','Ready to Ship',NULL,'Cancelled'),
('O20012','2022-05-12','C108','S004','On Way',NULL,'Successful'),
('O20013','2022-05-16','C109','S001','Ready to Ship',NULL,'In Process'),
('O20014','2022-05-16','C110','S001','On Way',NULL,'Successful');

INSERT INTO SalesOrderDetails (Order_Number, Product_Number, Order_Quantity) VALUES
('O20001','P1001',5),
('O20001','P1002',4),
('O20002','P1007',10),
('O20003','P1003',12),
('O20004','P1004',3),
('O20005','P1001',8),
('O20005','P1008',15),
('O20005','P1002',14),
('O20006','P1002',5),
('O20007','P1005',6),
('O20008','P1004',8),
('O20009','P1008',2),
('O20010','P1006',11),
('O20010','P1001',9),
('O20011','P1007',6),
('O20012','P1005',3),
('O20012','P1001',2),
('O20013','P1006',10),
('O20014','P1002',20);

SHOW CREATE TABLE Clients;
SHOW CREATE TABLE Product;
SHOW CREATE TABLE Salesman;
SHOW CREATE TABLE SalesOrder;
SHOW CREATE TABLE SalesOrderDetails;

SELECT * FROM Clients;
-- SELECT Client_Name FROM Clients;
SELECT * FROM Product;
SELECT * FROM Salesman;
SELECT * FROM SalesOrder;
SELECT * FROM SalesOrderDetails;

-- Lab4 ( command practice)
-- logical assignment
-- 1.Show the all-clients details who lives in “Binh Duong”.
SELECT * 
FROM Clients 
WHERE Province LIKE 'Binh Duong%';

-- 2.Find the client’s number and client’s name who do not live in “Hanoi”.
SELECT Client_Number, Client_Name
FROM Clients 
WHERE Province <> 'Hanoi';

-- 3.	Identify the names of all products with less than 25 in stock.
SELECT Product_Name 
From Product
where Quantity_On_Hand <25;

-- 4.	Find the product names where company making losses. 
select Product_Name
from Product
where Sell_Price < Cost_Price;

-- 5.Find the salesman’s details who are able achieved their target.
select *
from Salesman
where Target_Achieved > Sales_Target;

-- 6.	Select the names and city of salesman who are not received salary between 10000 and 17000.
select Salesman_Name, City
from Salesman
where Salary between 10000 and 17000;

-- 7.	Show order date and the clients_number of who bought the product between '2022-01-01' and '2022-02-15'.
SELECT Order_Date, Client_Number
FROM SalesOrder
WHERE Order_Date BETWEEN '2022-01-01' AND '2022-02-15';

-- STRING command
-- 8.	Find the names of cities in clients table where city name starts with "N"
SELECT City 
FROM Clients 
WHERE City LIKE 'N%';

-- 9.	Display clients’ information whose names have "u" in third position.
SELECT * 
FROM Clients 
WHERE Client_Name LIKE '__u%';

-- 10.	Find the details of clients whose names have "u" in second last position
SELECT * 
FROM Clients 
WHERE Client_Name LIKE '%u_';

-- 11.	Find the names of cities in clients table where city name starts with "D" and ends with “n”.
SELECT City 
FROM Clients 
WHERE City LIKE 'D%' and City LIKE '%n';

-- 12.	Select all clients details who belongs from Ho Chi Minh, Hanoi and Da Lat.
SELECT * 
FROM Clients 
WHERE City LIKE '%Ho Chi Minh%' or City LIKE '%Hanoi%' or City LIKE '%Da Lat%';

-- 13.	Choose all clients data who do not reside in Ho Chi Minh, Hanoi and Da Lat.
SELECT * 
FROM Clients 
WHERE City not LIKE '%Ho Chi Minh%' and City not LIKE '%Hanoi%' and City not LIKE '%Da Lat%';


-- c)Using mySQL functions (Min(), Max(), COUNT(), AVG() and SUM())
-- 14.	Find the average salesman’s salary.
SELECT AVG(Salary) AS average_salary
FROM Salesman;

-- 15.	Find the name of the highest paid salesman
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary= (SELECT MAX(Salary) FROM Salesman);

-- 16.	Find the name of the salesman who is paid the lowest salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary= (SELECT MIN(Salary) FROM Salesman);

-- 17.	Determine the total number of salespeople employed by the company.
SELECT count(*) AS total_number_SalePeople
FROM Salesman;

-- 18.	Compute the total salary paid to the company's salesman.
SELECT sum(Salary) AS total_salary
FROM Salesman;

-- d)	Using Order by keyword, limit clause
-- 19.	Select the salesman’s details sorted by their salary.
SELECT *
FROM salesman
ORDER BY Salary DESC; 

-- 20.	Display salesman names and phone numbers based on their target achieved (in ascending order) and their city (in descending order).
SELECT Salesman_Name, Phone
FROM Salesman
ORDER BY Target_Achieved ASC, City DESC;

-- 21. Display 3 first names of the salesman table and the salesman’s names in descending order.
SELECT Salesman_Name
FROM Salesman
ORDER BY Salesman_Name DESC
LIMIT 3;

-- 22. Find salary and the salesman’s names who is getting the highest salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary = (SELECT MAX(Salary) FROM Salesman);

-- 23. Find salary and the salesman’s names who is getting second lowest salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary = (SELECT DISTINCT Salary FROM Salesman ORDER BY Salary ASC LIMIT 1 OFFSET 1);

-- 24. Display the first five sales orders in formation from the sales order table.
SELECT *
FROM SalesOrder
ORDER BY Order_Number ASC
LIMIT 5;

-- 25. Display next ten sales order information from sales order table except first five sales orders.
SELECT *
FROM SalesOrder
ORDER BY Order_Number ASC
LIMIT 10 OFFSET 5;

-- 26. If there are more than one client, find the name of the province and the number of clients in each province, ordered high to low.
SELECT Province, COUNT(*) AS Client_Count
FROM Clients
GROUP BY Province
HAVING COUNT(*) > 1
ORDER BY Client_Count DESC;

-- 27. Display information clients have number of sales order more than 1.
SELECT c.*
FROM Clients c
JOIN (
    SELECT Client_Number, COUNT(*) AS Order_Count
    FROM SalesOrder
    GROUP BY Client_Number
    HAVING COUNT(*) > 1
) AS o ON c.Client_Number = o.Client_Number;

-- Practice to grade
-- Question : Using database ‘SaleManagerment’ to write SQL queries following:


-- 28. Display the name and due amount of those clients who live in “Hanoi”.
SELECT Client_Name, Amount_Due
FROM Clients
WHERE City = 'Hanoi';

-- 29. Find the clients details who has due more than 3000.
SELECT *
FROM Clients
WHERE Amount_Due > 3000;

-- 30. Find the clients name and their province who has no due.
SELECT Client_Name, Province
FROM Clients
WHERE Amount_Due = 0;

-- 31. Show details of all clients paying between 10,000 and 13,000.
SELECT *
FROM Clients
WHERE Amount_Paid BETWEEN 10000 AND 13000;

-- 32. Find the details of clients whose name is “Dat”.
SELECT *
FROM Clients
WHERE Client_Name = 'Dat';

-- 33. Display all product name and their corresponding selling price.
SELECT Product_Name, Sell_Price
FROM Product;

-- 34. How many TVs are in stock?
SELECT Quantity_On_Hand
FROM Product
WHERE Product_Name = 'TV';

-- 35. Find the salesman’s details who are not able to achieve their target.
SELECT *
FROM Salesman
WHERE Target_Achieved < Sales_Target;

-- 36. Show all the product details of product number ‘P1005’.
SELECT *
FROM Product
WHERE Product_Number = 'P1005';

-- 37. Find the buying price and selling price of a Mouse.
SELECT Cost_Price, Sell_Price
FROM Product
WHERE Product_Name = 'Mouse';

-- 38. Find the salesman names and phone numbers who live in Thu Dau Mot.
SELECT Salesman_Name, Phone
FROM Salesman
WHERE City = 'Thu Dau Mot';

-- 39. Find all the salesman’s name and salary.
SELECT Salesman_Name, Salary
FROM Salesman;

-- 40. Select the names and salary of salesman who receive between 10000 and 17000.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary BETWEEN 10000 AND 17000;

-- 41. Display all salesman details who receive salary between 10000 and 20000 and achieved their target.
SELECT *
FROM Salesman
WHERE Salary BETWEEN 10000 AND 20000 AND Target_Achieved >= Sales_Target;

-- 42. Display all salesman details who receive salary between 20000 and 30000 and not achieved their target.
SELECT *
FROM Salesman
WHERE Salary BETWEEN 20000 AND 30000 AND Target_Achieved < Sales_Target;

-- 43. Find information about all clients whose names do not end with "h".
SELECT *
FROM Clients
WHERE Client_Name NOT LIKE '%h';

-- 44. Find client names whose second letter is 'r' or second last letter 'a'.
SELECT Client_Name
FROM Clients
WHERE Client_Name LIKE '_r%' OR Client_Name LIKE '%a_';

-- 45. Select all clients where the city name starts with "D" and at least 3 characters in length.
SELECT *
FROM Clients
WHERE City LIKE 'D%' AND LENGTH(City) >= 3;

-- 46. Select the salesman name, salaries and target achieved sorted by their target_achieved in descending order.
SELECT Salesman_Name, Salary, Target_Achieved
FROM Salesman
ORDER BY Target_Achieved DESC;

-- 47. Select the salesman’s details sorted by their sales_target and target_achieved in ascending order.
SELECT *
FROM Salesman
ORDER BY Sales_Target ASC, Target_Achieved ASC;

-- 48. Select the salesman’s details sorted ascending by their salary and descending by achieved target.
SELECT *
FROM Salesman
ORDER BY Salary ASC, Target_Achieved DESC;

-- 49. Display salesman names and phone numbers in descending order based on their sales target.
SELECT Salesman_Name, Phone
FROM Salesman
ORDER BY Sales_Target DESC;

-- 50. Display the product name, cost price, and sell price sorted by quantity in hand.
SELECT Product_Name, Cost_Price, Sell_Price
FROM Product
ORDER BY Quantity_On_Hand ASC;

-- 51. Retrieve the clients’ names in ascending order.
SELECT Client_Name
FROM Clients
ORDER BY Client_Name ASC;

-- 52. Display client information based on order by their city.
SELECT *
FROM Clients
ORDER BY City ASC;

-- 53. Display client information based on order by their address and city.
SELECT *
FROM Clients
ORDER BY Address ASC, City ASC;

-- 54. Display client information based on their city, sorted high to low based on amount due.
SELECT *
FROM Clients
ORDER BY City ASC, Amount_Due DESC;

-- 55. Display last five sales order information from the sales order table.
SELECT *
FROM SalesOrder
ORDER BY Order_Number DESC
LIMIT 5;

-- 56. Count the pincode in the client table.
SELECT COUNT(DISTINCT Pincode) AS Pincode_Count
FROM Clients;

-- 57. How many clients are living in Binh Duong?
SELECT COUNT(*) AS Client_Count
FROM Clients
WHERE Province = 'Binh Duong';

-- 58. Count the clients for each province.
SELECT Province, COUNT(*) AS Client_Count
FROM Clients
GROUP BY Province;

-- 59. If there are more than three clients, find the name of the province and the number of clients in each province.
SELECT Province, COUNT(*) AS Client_Count
FROM Clients
GROUP BY Province
HAVING COUNT(*) > 3;

-- 60. Display product number and product name and count number orders of each product more than 1 (in ascending order).
SELECT p.Product_Number, p.Product_Name, COUNT(sod.Order_Number) AS Order_Count
FROM Product p
JOIN SalesOrderDetails sod ON p.Product_Number = sod.Product_Number
GROUP BY p.Product_Number, p.Product_Name
HAVING COUNT(sod.Order_Number) > 1
ORDER BY Order_Count ASC;

-- 61. Find products which have more quantity on hand than 20 and less than the sum of average.
SELECT *
FROM Product
WHERE Quantity_On_Hand > 20
AND Quantity_On_Hand < (SELECT SUM(Quantity_On_Hand) / COUNT(*) FROM Product);


