create database HumanResourcesManagement; -- DROP database HumanResourcesManagement( phong khi can reset database)
use  HumanResourcesManagement;  	 	-- DROP table tableName ( phong khi can reset table)
CREATE TABLE DEPARTMENT (
    departmentID INT PRIMARY KEY,
    departmentName VARCHAR(10) NOT NULL,
    managerID VARCHAR(3),
    dateOfEmployment DATE NOT NULL
);

CREATE TABLE DEPARTMENTADDRESS (
    departmentID INT,
    address VARCHAR(30),
    PRIMARY KEY (departmentID, address),
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);


CREATE TABLE EMPLOYEES (
    employeeID VARCHAR(3) PRIMARY KEY,
    lastName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20),
    firstName VARCHAR(20) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender VARCHAR(5) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    address VARCHAR(100) NOT NULL,
    managerID VARCHAR(3),
    departmentID INT,
    FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);


CREATE TABLE PROJECTS (
    projectID INT PRIMARY KEY,
    projectName VARCHAR(30) NOT NULL,
    projectAddress VARCHAR(100) NOT NULL,
    departmentID INT,
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);


CREATE TABLE ASSIGNMENT (
    employeeID VARCHAR(3),
    projectID INT,
    workingHour FLOAT NOT NULL,
    PRIMARY KEY (employeeID, projectID),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
    FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID)
);


CREATE TABLE RELATIVE (
    employeeID VARCHAR(3),
    relativeName VARCHAR(50),
    gender VARCHAR(5) NOT NULL,
    dateOfBirth DATE,
    relationship VARCHAR(30) NOT NULL,
    PRIMARY KEY (employeeID, relativeName),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID)
);

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
UPDATE EMPLOYEES
SET managerID = 888
WHERE employeeID = '333';

UPDATE EMPLOYEES
SET managerID = 888
WHERE employeeID = '987';

UPDATE DEPARTMENT
SET managerID = 888
WHERE departmentID = 1;

UPDATE DEPARTMENT
SET managerID = 987
WHERE departmentID = 4;

UPDATE DEPARTMENT
SET managerID = 333
WHERE departmentID = 5;

INSERT INTO DEPARTMENT (departmentID, departmentName, managerID, dateOfEmployment)
VALUES
(1, 'Quan ly', null, '1971-06-19'),
(4, 'Dieu hanh', null, '1985-01-01'),
(5, 'Nghien cuu', null, '1978-05-22');
INSERT INTO EMPLOYEES (employeeID, lastName, middleName, firstName, dateOfBirth, gender, salary, address, managerID, departmentID) 
VALUES
('333', 'Nguyen', 'Thanh', 'Tung', '1945-12-08', 'Nam', 40000, '638 Nguyen Van Cu Q5 TPHCM', NULL, 5),
('888', 'Vuong', 'Ngoc', 'Quyen', '1927-10-10', 'Nu', 55000, '450 Trung Vuong My Tho TG', NULL, 1),
('987', 'Le', 'Thi', 'Nhan', '1931-06-20', 'Nu', 43000, '291 Ho Van Hue Q.PN TPHCM', NULL, 4);




INSERT INTO EMPLOYEES (employeeID, lastName, middleName, firstName, dateOfBirth, gender, salary, address, managerID, departmentID) 
VALUES 
('123', 'Dinh', 'Ba', 'Tien', '1995-01-09', 'Nam', 30000, '731 Tran Hung Dao Q1 TPHCM', '333', 5), 
('453', 'Tran', 'Thanh', 'Tam', '1962-07-31', 'Nam', 25000, '543 Mai Thi Luu Ba Dinh Ha Noi', '333', 5), 
('666', 'Nguyen', 'Manh', 'Hung', '1972-09-15', 'Nam', 38000, '975 Le Lai P3 Vung Tau', '333', 5), 
('777', 'Tran', 'Hong', 'Quang', '1959-03-29', 'Nam', 25000, '980 Le Hong Phong Vung Tau', '987', 4), 
('999', 'Bui', 'Thuy', 'Vu', '1958-07-19', 'Nam', 25000, '332 Nguyen Thai Hoc Quy Nhon', '987', 4);



INSERT INTO DEPARTMENTADDRESS (departmentID, address)
VALUES
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');

INSERT INTO PROJECTS (projectID, projectName, projectAddress, departmentID)
VALUES
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);

INSERT INTO ASSIGNMENT (employeeID, projectID, workingHour)
VALUES
('123', 1, 22.5),
('123', 2, 7.5),
('123', 3, 10),
('333', 10, 10),
('333', 20, 10),
('453', 1, 20),
('453', 2, 20),
('666', 3, 40),
('888', 20, 0),
('987', 20, 15);

INSERT INTO RELATIVE (employeeID, relativeName, gender, dateOfBirth, relationship)
VALUES
('123', 'Chau', 'Nu', '1978-12-31', 'Con gai'),
('123', 'Duy', 'Nam', '1978-01-01', 'Con trai'),
('123', 'Phuong', 'Nu', '1957-05-05', 'Vo chong'),
('333', 'Duong', 'Nu', '1948-05-03', 'Vo chong'),
('333', 'Quang', 'Nu', '1976-04-05', 'Con gai'),
('333', 'Tung', 'Nam', '1973-10-25', 'Con trai'),
('987', 'Dang', 'Nam', '1932-02-29', 'Vo chong');

SHOW CREATE TABLE DEPARTMENT;
SHOW CREATE TABLE EMPLOYEES;
SHOW CREATE TABLE DEPARTMENTADDRESS;
SHOW CREATE TABLE PROJECTS;
SHOW CREATE TABLE ASSIGNMENT;
SHOW CREATE TABLE RELATIVE;

SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTADDRESS;
SELECT * FROM PROJECTS;
SELECT * FROM ASSIGNMENT;
SELECT * FROM RELATIVE;




