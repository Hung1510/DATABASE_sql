CREATE DATABASE SaleManagement;
USE SaleManagement;

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
SELECT * FROM Product;
SELECT * FROM Salesman;
SELECT * FROM SalesOrder;
SELECT * FROM SalesOrderDetails;



-- Truy van thong tin tu nhieu bang
SELECT * FROM Clients c, SalesOrder s
where c.Client_Number = s.Client_Number
order by c.Client_Number, s.Client_Number;

select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date -- explain select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date
from Clients c ,  SalesOrder s
where c.Client_Number = s.Client_Number;


-- Join
-- INNER JOIN ( Viet tat JOIN)
-- y chang doan code nay nhung toi uu tot hon 
/* select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date
from Clients c ,  SalesOrder s
where c.Client_Number = s.Client_Number
*/
select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date
from Clients c Join  SalesOrder s On c.Client_Number = s.Client_Number;


select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date
from Clients c Join  SalesOrder s On c.Client_Number = s.Client_Number
where c.City like 'h%';

-- Find who is the saleman of every client?
select c.Client_Number, c.Client_Name, sm.Salesman_Number, sm.Salesman_Name
from Clients c Join  SalesOrder s On c.Client_Number = s.Client_Number
Join Salesman sm on sm.Salesman_Number = s.Salesman_Number
order by c.Client_Number;

-- Find who is the saleman of every product?
select p.Product_Number, p.Product_Name, sm.Salesman_Number, sm.Salesman_Name
from Product p Join  SalesOrderDetails sd On p.Product_Number = sd.Product_Number
 join salesorder s on s.Order_Number =sd.Order_Number
 join salesman sm On sm.Salesman_Number = s.Salesman_Number
 order by p.Product_Number, sm.Salesman_Number;

-- Left Join ( lay het du lieu ben trai cua dong join)
Select distinct *
from SalesOrderDetails sd Left Join Product p ON p.Product_Number = sd.Product_Number;


Select distinct *
from Product p Left Join SalesOrderDetails sd ON p.Product_Number = sd.Product_Number
where sd.Product_Number is null;

-- Right Join
Select distinct p.Product_Number, p.Product_Name, sd.Order_Number
from SalesOrderDetails sd right Join Product p ON sd.Product_Number = p.Product_Number;

-- full join
Select p.Product_Number, p.Product_Name, sd.Order_Number
from SalesOrderDetails sd  Product p ON sd.Product_Number = p.Product_Number;


-- print out saleman who havent sale anything
desc salesorder;
select * from salesorder;
insert into salesorder
values('020015','2024-2-13','C110',null,'Ready to ship',null,'Successful');
insert into salesman
values('5007','Thao','Tan Uyen','Binh Duong','750000','Binh Duong',10000,100,0,'0909123456');
-- find saleman who hasnt sale anything
select distinct *
from Salesman sm left join salesorder s on sm.Salesman_Number = s.Salesman_Number
union
select distinct *
from Salesman sm right join salesorder s on sm.Salesman_Number = s.Salesman_Number

