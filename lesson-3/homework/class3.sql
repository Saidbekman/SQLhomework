--Easy-Level Tasks (10)

-- BULK INSERT - bu SQL Server’da katta hajmdagi ma’lumotlarni tez va samarali ravishda ma’lumotlar bazasiga yuklash uchun ishlatiladigan buyruqdir.

-- CSV, TXT, XML, JSON

create database homework3
use homework3

create table Products (ProductID int primary key, ProductName varchar (50), Price decimal(10,2))

Select * from Products

insert into Products
Select 1, 'shakar', 12500
union
Select 2, 'lavlagi', 5000
union
Select 3, 'bugdoy', 3000

-- NULL bo'sh qiymatlarni kirgizishga ruxsat beradi, NOT NULL bo'sh qiymatlarni kirgizishlikga ruxsat bermaydi
create table null_notnlltable (nullid int, nullname varchar(50) null, notnullname varchar(50) not null)

Select * from null_notnlltable

insert into null_notnlltable values (1,'Company' ,'Ahmadtea')
insert into null_notnlltable values (1,'' ,'Alkazaytea')
insert into null_notnlltable (nullid,notnullname) values (1,'Alkazaytea')

Alter table Products
add constraint Uk_unique unique(ProductName)

--SQL so‘rovlariga sharh (kommentariya) qo‘shish uchun -- (bir qatorli sharh) yoki /* */ (ko‘p qatorli sharh) ishlatiladi. 

create table Categories (CategoryID int primary key, CategoryName varchar(50) unique)

--IDENTITY ustuni jadvalning avtomatik ravishda o'suvchi (auto-increment) qiymatlarini yaratish uchun ishlatiladi

-- Medium-Level Tasks (10)

bulk insert Products
from 'C:\Users\user\Documents\SOURSE FILE\Product.txt'
WITH (FIELDTERMINATOR = ',',ROWTERMINATOR = '\n')

Select * from Products

-- PRIMARY KEY avtomatik ravishda UNIQUE, NOT NULL xususiyatiga ega va bir marta ishlatiladi, UNIQUE KEY ustunidagi qiymatlar takrorlanmasligi ta'minlaydi vako'p marta qo'llasa bo'ladi

Alter table Products
add constraint Ch_check check(Price>0)

Alter table Products
add Stock int not null DEFAULT 0

Select * from Products

update Products
set Stock = isnull(Stock,0)

/*
FOREIGN KEY (tashqi kalit) bir jadvaldagi ustunni boshqa jadvaldagi PRIMARY KEY (asosiy kalit) yoki
UNIQUE KEY bilan bog‘lash uchun ishlatiladi. Bu cheklov jadval o‘rtasidagi bog‘liqlikni saqlaydi va
ma'lumotlarning yaxlitligi buzilmasligini ta’minlaydi.
*/

-- Hard-Level Tasks (10)

create table Customers(CusID int PRIMARY KEY, CusName varchar(50), CusFullName varchar(50), CusAge int  check(CusAge>18))

Select * from Customers

create table identitytable (identityid int identity(100,10), identityname varchar(50))

Select * from identitytable

create table OrderDetails (OrderDetailsID int PRIMARY KEY, OrderDetailsName varchar(50), OrderDetailsAge int check (OrderDetailsAge>18))

Select * from OrderDetails

update Products
set Price = coalesce(Price,0)

update Products
set Price = isnull(Price,0)

create table Employees (EmpId int primary key, Email varchar (50) unique)

Select * from Employees

create table on_delete_cascade (id int primary key, name varchar(50))

create table up_update_cascade (NameID int, ProductName varchar(50), salesKG decimal(10,2), 
constraint Fk_cascade foreign key (NameID)  references on_delete_cascade(id)) 

Select * from on_delete_cascade
Select * from up_update_cascade
