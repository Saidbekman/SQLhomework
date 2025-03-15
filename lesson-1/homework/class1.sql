-- Data: Bu har qanday faktlar, raqamlar yoki yozuvlardir
-- Database: Ma’lumotlarni tartiblangan holda saqlash va boshqarish uchun mo‘ljallangan tizim
-- Relational Database: Jadvallar o‘rtasida bog‘liqlik mavjud bo‘lgan ma’lumotlar bazasi
-- Table: Ma’lumotlarni qatorlar (rows) va ustunlar (columns) dan iborat
 /*
List five key features of SQL Server.
Ma’lumotlarni ishonchli saqlash va boshqarish
Katta hajmdagi ma’lumotlar bilan ishlash imkoniyati
Tahlil qilish va hisobot yaratish funksiyalari
Turli dasturlar bilan integratsiya qilish
Yaxshi xavfsizlik tizimi
*/
create database SchoolDB

use SchoolDB

create table Students (StudentID INT PRIMARY KEY, [Name] VARCHAR(50), Age INT)


/*
SQL Server: Ma’lumotlar bazasini boshqarish tizimi (DBMS)
SSMS: SQL Server bilan ishlash uchun grafik interfeys
SQL: Ma’lumotlarni so‘rash va boshqarish uchun ishlatiladigan til
*/

Select * from Students

insert into Students (StudentID, [Name], Age) VALUES (1, 'Bekmurod', 20)

create table Teachers (TeacherID INT, [Name] VARCHAR(50))

begin tran
create table Oybek(id int) 
rollback tran

insert into Students (StudentID, [Name], Age) VALUES (2, 'Kamron', 20)
insert into Students (StudentID, [Name], Age) VALUES (3, 'Ahmadjon', 22)
insert into Students (StudentID, [Name], Age) VALUES (4, 'Karima', 21)
