-- 1. Combine Two Tables

Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')

Select firstName, lastName, city,state from Person p left join Address a on p.personId=a.personId

-- 2. Employees Earning More Than Their Managers
Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)

Select a.name from Employee d join Employee a on d.id=a.managerId where d.salary<a.salary

-- 3.Duplicate Emails
Create table Person1 (id int, email varchar(255))
insert into Person1 (id, email) values ('1', 'a@b.com') 
insert into Person1 (id, email) values ('2', 'c@d.com') 
insert into Person1 (id, email) values ('3', 'a@b.com')

Select distinct a.email from Person1 a join Person1 d on a.email=d.email and a.id<>d.id

-- 4. Delete Duplicate Emails
Create table Person2 (id int, email varchar(255))
insert into Person2(id, email) values ('1', 'john@example.com') 
insert into Person2 (id, email) values ('2', 'bob@example.com') 
insert into Person2 (id, email) values ('3', 'john@example.com')

Select distinct a.email from Person2 a join Person2 d on a.email=d.email and a.id=d.id

-- 5. Find those parents who has only girls.

CREATE TABLE boys (Id INT PRIMARY KEY,name VARCHAR(100),ParentName VARCHAR(100));
CREATE TABLE girls (Id INT PRIMARY KEY,name VARCHAR(100),ParentName VARCHAR(100));
INSERT INTO boys (Id, name, ParentName) VALUES (1, 'John', 'Michael'),(2, 'David', 'James'),(3, 'Alex', 'Robert'),(4, 'Luke', 'Michael'), (5, 'Ethan', 'David'), (6, 'Mason', 'George');  
INSERT INTO girls (Id, name, ParentName) VALUES (1, 'Emma', 'Mike'),(2, 'Olivia', 'James'),(3, 'Ava', 'Robert'), (4, 'Sophia', 'Mike'),(5, 'Mia', 'John'),(6, 'Isabella', 'Emily'), (7, 'Charlotte', 'George');

select girls.ParentName from girls left join boys on girls.ParentName=boys.ParentName where boys.ParentName is not null

-- 7. Carts
CREATE TABLE Cart1
( Item  VARCHAR(100) PRIMARY KEY);
CREATE TABLE Cart2
(Item  VARCHAR(100) PRIMARY KEY);
INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');

Select ISNULL(Cart1.Item,'') Cart1_Item,ISNULL(Cart2.Item,'') Cart2_Item from Cart1 full join Cart2 on Cart1.Item=Cart2.Item

-- 8. Customers Who Never Order
Create table Customera1 (id int, name varchar(255))
Create table Order123 (id int, customerId int)

insert into Customera1 (id, name) values ('1', 'Joe')
insert into Customera1 (id, name) values ('2', 'Henry')
insert into Customera1 (id, name) values ('3', 'Sam')
insert into Customera1 (id, name) values ('4', 'Max')

insert into Order123(id, customerId) values ('1', '3')
insert into Order123 (id, customerId) values ('2', '1')
Select name from Customera1 a join Order123 b on a.id=b.id

-- 9. Students and Examinations
Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))

insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')

insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')

insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math');

SELECT
  s.student_id,
  s.student_name,
  sub.subject_name,
  COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

