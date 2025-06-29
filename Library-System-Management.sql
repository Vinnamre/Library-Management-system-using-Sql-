-- Library Management system

-- creating a branch table

drop table if exists branch;
create table branch(
	branch_id varchar(10) primary key,	
	manager_id varchar(10),	
	branch_address varchar(10),	
	contact_no varchar(10)
	);

-- creating a table employees

drop table if exists employee;
create table employee(
	emp_id varchar(10) primary key,
	emp_name varchar(25),
	position varchar(25),
	salary Int,
	branch_id varchar(25) --FK
);

-- creating books table

drop table if exists books;
create table books (
	isbn varchar(20) primary key,
	book_title varchar(75),
	category varchar (10),
	rental_price float,
	status varchar(15),
	author varchar(20),
	publisher varchar(55)
);

-- creating table members

drop table if exists members;
create table members(
	member_id varchar(10) primary key,
	member_name varchar(25),
	member_address varchar(75),
	reg_date DATE
);

-- creating table issued table

drop table if exists issued_status;
create table issued_status (
	issued_id varchar(10) primary key,
	issued_member_id varchar(10), --FK
	issued_book_name varchar(75),
	issued_date DATE,
	issued_book_isbn varchar(25), --FK
	issued_emp_id varchar(10) --FK
);

-- creating table return status

drop table if exists return_status;
create table return_status(
	return_id varchar(10) primary key,
	issued_id varchar(10), --FK
	return_book_name varchar(75),
	return_date DATE,
	return_book_isbn varchar(20)
);


-- DATA MODELING or Constraints

alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn); 

alter table issued_status
add constraint fk_employee_id
foreign key (issued_emp_id)
references employee(emp_id);

alter table employee
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

alter table return_status
add constraint fk_issued_id
foreign key (issued_id)
references issued_status(issued_id);