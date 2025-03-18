create table employees (
    empid int primary key,
    name varchar(50),
    salary decimal(10,2))
-- bitta yozuv qo'shish
insert into employees (empid, name, salary) 
values (1, 'ali', 4500)

-- bir nechta yozuv qo'shish
insert into employees (empid, name, salary) 
values (2, 'zarina', 5500), (3, 'bobur', 6000)

update employees 
set salary = 5000
where empid = 1

delete from employees 
where empid = 2

-- delete (faqat ma'lumotlarni o'chiradi, tuzilma saqlanib qoladi)
delete from employees

-- truncate (barcha yozuvlarni o'chiradi, ammo jadvalni saqlaydi)
truncate table employees

-- drop (butun jadvalni o‘chiradi)
drop table employees

alter table employees 
modify name varchar(100)

alter table employees 
add department varchar(50)

create table departments (
    departmentid int primary key,
    departmentname varchar(50))

delete from employees;

insert into departments (departmentid, departmentname) 
select distinct empid, department from employees

update employees 
set department = 'management' 
where salary > 5000

truncate table employees

alter table employees 
drop column department

alter table employees 
rename to staffmembers

drop table departments

drop table departments

create table products (
    productid int primary key,
    productname varchar(50),
    category varchar(50),
    price decimal(10,2),
    stockquantity int)

alter table products 
add constraint chk_price check (price > 0)

alter table products 
alter column stockquantity set default 50

alter table products 
rename column category to productcategory

insert into products (productid, productname, productcategory, price, stockquantity) 
values 
(1, 'shokolad', 'shirinlik', 10.00, 100),
(2, 'keks', 'non', 5.00, 50),
(3, 'konfet', 'shirinlik', 3.50, 200),
(4, 'pechenye', 'shirinlik', 4.75, 150),
(5, 'suv', 'ichimlik', 1.00, 500)

select * into products_backup from products

alter table products 
rename to inventory

alter table inventory 
modify price float

alter table inventory 
add productcode int identity(1000,5)
