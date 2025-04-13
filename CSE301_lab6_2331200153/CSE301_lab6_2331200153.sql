CREATE DATABASE SaleManagement_lab6; -- drop DATABASE SaleManagement_lab6;
USE SaleManagement_lab6;

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

show table status from SaleManagement_lab6;
select * from clients;


-- lab 6
-- A.	Add, delete, update value for the columns in table related to calculate new values and constraint.
-- 1. How to check constraint in a table?
-- use to check all constraint in the table
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'salesman';

Select * 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where table_schema like 'sale%' and table_name like 'pro%';
/*
alter table product
add column profit_percentage decimal (15,4) after Quantity_Sell;

alter table product
drop column profit_percentage;

alter table product
add constraint chk_percentage check ( profit_percentage <=1);  -- 1 <-> 100% 

alter table product
drop constraint chk_percentage;
*/

-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information about product name and its buying price.
CREATE TABLE ProductCost ( -- drop table ProductCost
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Cost_Price DECIMAL(15,4) NOT NULL,
    PRIMARY KEY (Product_Name),
    FOREIGN KEY (Product_Name) REFERENCES Product(Product_Name)
);
SHOW CREATE TABLE  ProductCost;

-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
SELECT Product_Name, Sell_Price, Cost_Price,
(Sell_Price - Cost_Price) / Cost_Price * 100 AS profit_percentage
FROM Product;

-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
SELECT 
    Salesman_Name, 
    Sales_Target, 
    Target_Achieved, 
    IF(Target_Achieved >= Sales_Target * 1.75, 'Good', NULL) AS Remarks
FROM Salesman;

-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
SELECT 
    Salesman_Name, 
    Sales_Target, 
    Target_Achieved, 
    IF(Target_Achieved <= Sales_Target * 0.75, 'Average', NULL) AS Remarks
FROM Salesman;

-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
SELECT 
    Salesman_Name, 
    Sales_Target, 
    Target_Achieved, 
    IF(Target_Achieved < Sales_Target * 0.50, 'Poor', NULL) AS Remarks
FROM Salesman;

-- 7. Find the total quantity for each product. (Query)
SELECT Product_Number, SUM(Order_Quantity) AS Total_Quantity
FROM SalesOrderDetails
GROUP BY Product_Number;

-- 8. Add a new column and find the total quantity for each product.
ALTER TABLE Product
ADD COLUMN Total_Quantity INT;
UPDATE Product p
SET p.Total_Quantity = (
    SELECT SUM(Order_Quantity)
    FROM SalesOrderDetails sod
    WHERE sod.Product_Number = p.Product_Number
    GROUP BY sod.Product_Number
);
select Total_Quantity from Product;



-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5
ALTER TABLE Product ADD COLUMN Discount_Rate INT DEFAULT 0;
UPDATE Product 
SET Discount_Rate = IF(Quantity_On_Hand > 10, 10, 5);
select Discount_Rate from Product;


-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
UPDATE Product 
SET Discount_Rate = 
    IF(Quantity_On_Hand >= 20, 10, 
        IF(Quantity_On_Hand > 10, 5, 
            IF(Quantity_On_Hand > 5, 3, 0)
        )
    );
select Discount_Rate from Product;

-- 11. The first number of pin code in the client table should start with 7.
SELECT * FROM Clients WHERE Pincode  LIKE '7%'; -- SELECT * FROM Clients WHERE Pincode  LIKE '7%';
UPDATE Clients 
SET Pincode = 700000 
WHERE Pincode NOT LIKE '7%';


-- B.	Creating and using view:

-- 12.
-- Create a View
CREATE VIEW view_name AS 
SELECT * FROM table_name;
-- 2.Changing a view
ALTER VIEW view_name AS SELECT column1, column2 
FROM table_name;
-- 3.Renaming a view
RENAME TABLE view_name TO new_view_name;
-- Deleting a view
DROP VIEW IF EXISTS view_name;


-- 13. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
CREATE VIEW clients_view AS  -- DROP VIEW clients_view;
SELECT * FROM Clients 
WHERE City = 'Thu Dau Mot';
SELECT * FROM clients_view ;

-- 14. Drop the “client_view”.
DROP VIEW clients_view;


-- 15. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
CREATE VIEW clients_order AS -- DROP VIEW clients_order;
SELECT c.Client_Number, c.Client_Name, so.Order_Number, so.Order_Date, so.Order_Status
FROM Clients c
JOIN SalesOrder so ON c.Client_Number = so.Client_Number
WHERE c.City = 'Thu Dau Mot';
SELECT * FROM clients_order;



-- 16. Creates a view that selects every product in the "Products" table with a sell price higher than the average sell price.
CREATE VIEW high_price_products AS  -- DROP VIEW high_price_products;
SELECT * FROM Product
WHERE Sell_Price > (SELECT AVG(Sell_Price) FROM Product);
SELECT * FROM high_price_products;

-- 17. Creates a view name as salesman_view that show all salesman information and products (product names, product price, quantity order) were sold by them.
CREATE VIEW salesman_view AS  -- DROP VIEW salesman_view;
SELECT s.*, p.Product_Name, p.Sell_Price, sod.Order_Quantity
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number;
SELECT * FROM salesman_view;

-- 18. Creates a view name as sale_view that show all salesman information and product (product names, product price, quantity order) were sold by them with order_status = 'Successful'.
CREATE VIEW sale_view AS  -- DROP VIEW sale_view;
SELECT s.*, p.Product_Name, p.Sell_Price, sod.Order_Quantity
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE so.Order_Status = 'Successful';
SELECT * FROM sale_view;

-- 19. Creates a view name as sale_amount_view that show all salesman information and sum order quantity of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
CREATE VIEW sale_amount_view AS  -- DROP VIEW sale_amount_view;
SELECT s.*, SUM(sod.Order_Quantity) AS Total_Quantity
FROM Salesman s
JOIN SalesOrder so ON s.Salesman_Number = so.Salesman_Number
JOIN SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
JOIN Product p ON sod.Product_Number = p.Product_Number
WHERE so.Order_Status = 'Successful'
GROUP BY s.Salesman_Number
HAVING Total_Quantity >= 20;
SELECT * FROM sale_amount_view;



SELECT * FROM clients_view ;
SELECT * FROM clients_order;
SELECT * FROM high_price_products;
SELECT * FROM salesman_view;
SELECT * FROM sale_view;
SELECT * FROM sale_amount_view;


-- Extra assignment
-- 20.Amount paid and amounted due should not be negative when you are inserting the data. 
SHOW COLUMNS FROM SalesOrder;
ALTER TABLE SalesOrder
ADD CONSTRAINT chk_amount_paid_due 
CHECK (Amount_Paid >= 0 AND Amount_Due >= 0); -- avoid negative

-- 21.Do not enforce the check constraint for pincode.
ALTER TABLE Clients 
DROP CHECK chk_pincode; -- if there is already an created constraint for pincode in client

-- 22.How to alter a check constraint enforcement state?
-- enable
ALTER TABLE Clients 
ENABLE KEYS;

-- disable
ALTER TABLE Clients 
DISABLE KEYS;

-- 23.Remove the constraint from pincode; ( same as 20)
ALTER TABLE Clients 
DROP CHECK chk_pincode;

-- 24.The sell price and cost price should be unique.
ALTER TABLE Product
ADD CONSTRAINT unique_price UNIQUE (Sell_Price, Cost_Price);

-- 25.The sell price and cost price should not be unique. (change above code)
ALTER TABLE Product
DROP INDEX unique_price;

-- 26.Update the delivery status to “Delivered” for the product number P1007.
UPDATE SalesOrder 
SET Delivery_Status = 'Delivered'
WHERE Product_Number = 'P1007';

-- 27.Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
UPDATE Clients 
SET Address = 'Phu Hoa', City = 'Thu Dau Mot'
WHERE Client_Number = 'C104';

-- 28.Add a new column to “Product” table named as “Exp_Date”, data type is Date.
ALTER TABLE Product
ADD COLUMN Exp_Date DATE;

-- 29.Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
ALTER TABLE Clients
ADD COLUMN Phone VARCHAR(15);

-- 30.Update remarks as “Good” for all salesman.
UPDATE Salesman
SET Remarks = 'Good';

-- 31.Change remarks to "bad" whose salesman number is "S004".
UPDATE Salesman
SET Remarks = 'Bad'
WHERE Salesman_Number = 'S004';

-- 32.Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
ALTER TABLE Clients
MODIFY Phone VARCHAR(10);

-- 33.Delete the “Phone” column from “Clients” table.
ALTER TABLE Clients
DROP COLUMN Phone;

-- 34.alter table Clients drop column Phone; (same as 32)
ALTER TABLE Clients
DROP COLUMN Phone;

-- 35.Change the sell price of Mouse to 120.
UPDATE Product 
SET Sell_Price = 120
WHERE Product_Name = 'Mouse';

-- 36.Change the city of client number C104 to “Ben Cat”.
UPDATE Clients
SET City = 'Ben Cat'
WHERE Client_Number = 'C104';

-- 37.If Order_Quantity greater than 5, then 10% discount. If Order_Quantity greater than 10, then 15% discount. Othrwise, no discount
UPDATE SalesOrderDetails
SET Discount = IF(Order_Quantity > 10, 15, IF(Order_Quantity > 5, 10, 0));


