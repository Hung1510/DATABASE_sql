USE `kindergartenmanagement`;

-- Q1 --
-- a --
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
