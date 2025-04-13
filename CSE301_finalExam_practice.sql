-- Tạo cơ sở dữ liệu
CREATE DATABASE UniversityLibrary;  -- drop DATABASE UniversityLibrary;
USE UniversityLibrary;

-- Bảng lưu thông tin sách
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    Genre VARCHAR(100),
    PublicationYear INT,
    Category VARCHAR(100),
    TotalCopies INT NOT NULL
);

-- Bảng lưu thông tin người đọc (sinh viên, giảng viên, nhân viên)
CREATE TABLE Readers (
    ReaderID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    DateOfBirth DATE,
    UniversityID VARCHAR(50) UNIQUE NOT NULL,
    Department VARCHAR(255),
    ContactDetails VARCHAR(255),
    ReaderType VARCHAR(100) NOT NULL
);

-- Bảng lưu thông tin nhân viên thư viện
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100),
    WorkSchedule TEXT
);

-- Bảng lưu thông tin mượn/trả sách
CREATE TABLE BorrowingTransactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    ReaderID INT,
    StaffID INT,
    BorrowDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(100),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Bảng lưu thông tin đặt chỗ sách
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    ReaderID INT,
    ReservationDate DATE NOT NULL,
    Status ENUM('Pending', 'Completed') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID)
);

INSERT INTO Books (BookID, Title, Author, Genre, PublicationYear, Category, TotalCopies) VALUES
(1, 'Clean Code', 'Robert C. Martin', 'Programming', 2008, 'Software Engineering', 5),
(2, 'The Pragmatic Programmer', 'Andrew Hunt', 'Programming', 1999, 'Software Engineering', 3),
(3, 'Introduction to Algorithms', 'Thomas H. Cormen', 'Algorithms', 2009, 'Computer Science', 4),
(4, 'Database System Concepts', 'Abraham Silberschatz', 'Database', 2010, 'Computer Science', 2),
(5, 'Artificial Intelligence: A Modern Approach', 'Stuart Russell', 'AI', 2020, 'AI', 3);
INSERT INTO Readers (ReaderID, FullName, DateOfBirth, UniversityID, Department, ContactDetails, ReaderType) VALUES
(101, 'Nguyen Van A', '2000-05-12', 'U123456', 'Computer Science', 'nguyenvana@example.com', 'Student'),
(102, 'Tran Thi B', '1998-08-24', 'U234567', 'Software Engineering', 'tranthib@example.com', 'Faculty'),
(103, 'Le Van C', '2001-02-15', 'U345678', 'Computer Science', 'levanc@example.com', 'Student'),
(104, 'Pham Thi D', '1995-06-10', 'U456789', 'Data Science', 'phamthid@example.com', 'Staff'),
(105, 'Hoang Van E', '1999-11-30', 'U567890', 'AI', 'hoangvane@example.com', 'Student');
INSERT INTO Staff (StaffID, Name, Role, WorkSchedule) VALUES
(201, 'Nguyen Thanh T', 'Librarian', 'Monday - Friday, 8 AM - 5 PM'),
(202, 'Tran Van K', 'Assistant Librarian', 'Tuesday - Saturday, 9 AM - 6 PM');
INSERT INTO BorrowingTransactions (TransactionID, BookID, ReaderID, StaffID, BorrowDate, DueDate, ReturnDate, Status) VALUES
(301, 1, 101, 201, '2025-03-10', '2025-03-24', NULL, 'Not Returned'),
(302, 2, 102, 202, '2025-03-05', '2025-04-04', '2025-03-28', 'Returned'),
(303, 3, 103, 201, '2025-03-15', '2025-03-29', NULL, 'Overdue'),
(304, 4, 104, 202, '2025-03-12', '2025-03-26', NULL, 'Not Returned'),
(305, 5, 105, 201, '2025-03-18', '2025-04-01', NULL, 'Not Returned');
INSERT INTO Reservations (ReservationID, BookID, ReaderID, ReservationDate, Status) VALUES
(401, 1, 101, '2025-03-20', 'Pending'),
(402, 2, 102, '2025-03-18', 'Completed'),
(403, 3, 103, '2025-03-22', 'Pending'),
(404, 4, 104, '2025-03-15', 'Completed'),
(405, 5, 105, '2025-03-21', 'Pending');

select * from Readers;

-- date_sub: trừ đi một khoảng thời gian  từ một ngày cụ thể
-- Query 
-- A. Constraint 
-- 1. Restricts transaction statuses to predefined values as follows: Returned, Not Returned, Overdue
alter table BorrowingTransactions
add CONSTRAINT transaction_chk check ( Status in ( 'Returned' , 'Not Returned' , 'Overdue'));

-- 2. Ensures reservation dates are not in the future
ALTER table Reservations
add CONSTRAINT reservations_chk check ( ReservationDate <= sysdate());


-- B. SQL Query
-- 3. Retrieve all book reservations that are currently in the status 'Pending' and were made within the last 7 days.
SELECT * FROM Reservations
WHERE Status = 'Pending' 
AND ReservationDate >= date_sub(current_date(), INTERVAL 7 DAY);


-- 4. Find any borrowed book exceeds the maximum loan duration described as below: 
-- o Students can borrow up to 3 books at a time for a maximum of 14 days.
-- o Faculty can borrow up to 5 books at a time for a maximum of 30 days.
-- o Staff can borrow up to 2 books at a time for a maximum of 7 days.
Select bt.*, re.ReaderType
FROM BorrowingTransactions as bt
join Readers as re 
on bt.ReaderID = re.ReaderID
where ( 
( re.ReaderType = 'Students' and datediff(current_date(),bt.BorrowDate) >14 )
or(re.Readertype = 'Faculty' and datediff(current_date(), bt.BorrowDate)>30)
or(re.Readertype = 'Staff' and datediff(current_date(), bt.BorrowDate)>7)
)
and bt.Status ='Not Returned';

-- 5. Retrieve Total Borrowed Books by Reader.
Select ReaderID, count(*) as totalBorrow
from BorrowingTransactions
where status !='Returned'
Group by ReaderID;


-- 6. Update the status of all book reservations to 'Completed' if the current status is 'Pending' and the reservation date is more than 7 days old. This ensures that only reservations that 
-- are overdue for completion are updated, while those with a recent reservation date or already completed status remain unchanged.
Update  Reservations
set Status ='Completed'
where Status ='Pending' and ReservationDate < date_sub(curdate(),interval 7 day);

select status from Reservations; -- kiem tra

-- 7. Create a procedure to check if a specific book is available for borrowing. The procedure takes the book's ID as input and verifies whether the number of available copies 
-- (QuantityAvailable) is greater than zero. It returns a status (Allowed or Not Allowed) and a message explaining the result, such as whether borrowing is permitted or if the book is 
-- currently unavailable. This simple procedure focuses solely on book availability and provides clear output for decision-making.



-- -------
/*  midterm solution
CREATE TABLE schedules(
	ScheduleID INT auto_increment primary key,
    ClassID INT ,
    ScheduleDate date not null,
    Activity varchar(255),
    foreign key  (ClassID) 
    REFERENCES classes (ClassID)
);

-- b --
INSERT INTO schedules (ClassID, ScheduleDate, Activity) values
(1, '2023-09-01', 'Toán tư duy'),
(2, '2023-09-01', 'Âm nhạc'),
(3, '2023-09-01', 'Hội họa') ;



-- Q2 --
-- a --
UPDATE parents 
SET Phone='0909999999'
WHERE Name='Nguyễn Văn An';

-- b --
delete from healthrecords 
where StudentID = 2;

-- c --
select p.ParentID, p.Name, p.Phone from parents p
where p.Name like "%Nguyễn%" and p.Phone like "0909%"
order by ParentID asc;

-- d --
select s.StudentID, s.Name, s.ClassID from students s
where s.DateOfBirth like "%2018%"
order by DateOfBirth asc;
*/

-- -------
/*
CSE 301 2021-2022
-- 1. Change the appointment date and doctor information
UPDATE Appointment
SET Appt_date = '2022-04-05', Doctor_Reg_No = 106
WHERE Patient_id = 'P1005' AND Appt_date = '2022-07-04' AND Doctor_Reg_No = 105;

-- 2. Calculate total appointments from July 1st to July 5th, sorted by date
SELECT Appt_date, COUNT(*) AS Total_Appointments
FROM Appointment
WHERE Appt_date BETWEEN '2022-07-01' AND '2022-07-05'
GROUP BY Appt_date
ORDER BY Appt_date ASC;

-- 3. Change doctor phone number for a doctor with an appointment with patient P1001 on July 5th, 2022
UPDATE Doctor
SET Doctor_Phone = 0909999222
WHERE Doctor_Reg_No = (
    SELECT Doctor_Reg_No FROM Appointment
    WHERE Patient_id = 'P1001' AND Appt_date = '2022-07-05'
    LIMIT 1
);

-- 4. Find patients with multiple appointments where doctors specialize in different fields but have the same fees
SELECT p.Patient_Name, a.Appt_Number, a.Appt_date, d1.Specialization AS Specialization1, d2.Specialization AS Specialization2, d1.Fees
FROM Appointment a1
JOIN Appointment a2 ON a1.Patient_id = a2.Patient_id AND a1.Doctor_Reg_No <> a2.Doctor_Reg_No
JOIN Doctor d1 ON a1.Doctor_Reg_No = d1.Doctor_Reg_No
JOIN Doctor d2 ON a2.Doctor_Reg_No = d2.Doctor_Reg_No AND d1.Fees = d2.Fees AND d1.Specialization <> d2.Specialization
JOIN Patient p ON a1.Patient_id = p.Patient_id
ORDER BY p.Patient_Name;
*/

-- -------
-- lab3
-- chỉnh sửa bảng chỉ được trước khi nhập dữ liệu vô, nhập dữ liệu r thì phải drop table khởi tạo lại
/* Chỉnh sửa bảng sau khi đã tạo, thêm constraint
alter table Employees
Add Foreign Key (DepartmentID) references Department(DepartmentID);
*/
/* Chỉnh sửa bảng sau khi đã tạo, thêm check
alter table Employees
Add Constraint chk_salary check (salary > 0);
*/
/* Chỉnh sửa bảng sau khi đã tạo, thêm constraint cho foreign key
alter table Employees
Add Constraint chk_forSomething Foreign Key (DepartmentID) references Department(DepartmentID);
*/
/* update du lieu cua table
Update Employees
SET departmentID=null
WHERE departmentID='888'
*/

/* phần edit có preferences, voo sql editor đó tắt safe option nếu muốn xóa bảng hoặc dữ liệu
mà ko có sử dụng hàm wehre để giới hạn đọan xoa
*/


/* -- Truy van thong tin tu nhieu bang
SELECT * FROM Clients c, SalesOrder s
where c.Client_Number = s.Client_Number
order by c.Client_Number, s.Client_Number;

select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date -- explain select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date
from Clients c ,  SalesOrder s
where c.Client_Number = s.Client_Number;


-- Join
-- INNER JOIN ( Viet tat JOIN)
-- y chang doan code nay nhung toi uu tot hon 
 select c.Client_Number, c.Client_Name, c.City, s.Order_Number, s.Order_Date
from Clients c ,  SalesOrder s
where c.Client_Number = s.Client_Number

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
*/
-- -------
-- lab 3 rtiep tuc 
/* -- Truy van thong tin tu nhieu bang
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
/*
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
*/


-- -------
/* 
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
*/



-- -------
-- lab 5
/*
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

-- -------
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
*/

-- -------
/*
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
/*
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
*/







