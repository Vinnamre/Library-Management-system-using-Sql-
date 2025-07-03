🌟 Library Management System 🌟

Welcome to the Library Management System repository! This project brings to life a dynamic database schema designed to manage library operations efficiently. It includes tables for branches, books, employees, issued status, return status, and members. Dive in and explore!


![image (11)](https://github.com/user-attachments/assets/8bdda2ad-c442-4bc7-bd62-0cd0049ac3dd)



🎉 Project Tasks

![library_erd](https://github.com/user-attachments/assets/b7105baf-adbe-486a-adfc-b1271e7691ec)



✨ 2. CRUD Operations





Task 1: Create a New Book Record
Add a new book with details: '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

``` sql
insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;
```

Task 2: Update an Existing Member's Address
Refresh a member's address with ease!
```
update members
set member_address = '125 Oak St'
where member_id = 'C103';
```

Task 3: Delete a Record from the Issued Status Table
Objective: Remove the record with issued_id = 'IS104' from the issued_status table.
```
delete from issued_status
where issued_id = 'IS121';
```


Task 4: Retrieve All Books Issued by a Specific Employee
Objective: Fetch all books issued by the employee with emp_id = 'E101'.

```
select * from issued_status
where issued_emp_id = 'E101';
```

Task 5: List Members Who Have Issued More Than One Book
Objective: Use GROUP BY to spotlight members with multiple book issues.

```
select 
	issued_member_id,
	count(issued_id)
	from issued_status
group by issued_member_id
having count(issued_id) > 1;
```

✨ 3. CTAS (Create Table As Select)

Task 6: Create Summary Tables
Leverage CTAS to craft new tables showcasing each book and total book_issued_cnt.
```
create table book_issued_counts as
select 
	b.isbn as book_id,
	b.book_title as  title,
	count(i.issued_id) as issued_count
from books as b
join issued_status as i
on b.isbn = i.issued_book_isbn
group by b.isbn;

select * from book_issued_counts;
```

✨ 4. Data Analysis & Findings

Task 7: Retrieve All Books in a Specific Category
Explore books by category!
```
select * from books
where category = 'Classic';
```


Task 8: Find Total Rental Income by Category
Calculate the revenue per category.
```
select 
	b.category as category,
	sum(b.rental_price) as total_price,
	count(*)
	from books as b
	join book_issued_counts as isst
	on b.isbn = isst.book_id
	group by 1
	order by total_price desc;
```


Task 9: List Members Who Registered in the Last 180 Days
Highlight new members!
```
select * from members
insert into members(member_id, member_name, member_address, reg_date)
values
('C121', 'Sami Zayn', '131 Main St', '2025-03-12'),
('C122', 'Karion Kross', 'broklyn St', '2025-01-19');

select * from members
where reg_date >= current_date - interval '180 days';
```


Task 10: List Employees with Their Branch Manager's Name and Branch Details
Get the full employee-branch scoop.
```
select
	e1.emp_id,
	e1.emp_name,
	e1.position,
	e2.emp_name as manager,
	b.branch_id
from employee as e1
join branch as b
on e1.branch_id = b.branch_id
join employee as e2
on e2.emp_id = b.manager_id;
```


Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
Filter high-value rentals.
```
create table expensive_books as
select * from books
where rental_price > 7.00;

select * from expensive_books
```


Task 12: Retrieve the List of Books Not Yet Returned
Track outstanding books.
```
select 
	i.issued_id,
	i.issued_book_name,
	r.return_id
from issued_status as i
left join return_status as r
on i.issued_id = r.issued_id
where r.return_id is NULL;
```

✨ Advanced SQL Operations


Task 13: Identify Members with Overdue Books
Spot members with books overdue (assume a 450-day return period). Show member's name, book title, issue date, and days overdue.
```
select 
	m.member_id,
	m.member_name,
	isst.issued_book_name as book_title,
	isst.issued_date,
	-- re.return_id,
	current_date - isst.issued_date as overdue_days
	from
	members as m
	join issued_status as isst
	on m.member_id = isst.issued_member_id

	left join return_status as re
	on re.issued_id = isst.issued_id

	where re.return_id is NULL and (current_date - isst.issued_date) > 450
	order by m.member_id
```


Task 14: Update Book Status on Return
Set books to "available" in the books table upon return (based on return_status entries).
```
create or replace procedure books_st (pt_return_id varchar(10), pt_issued_id varchar(10))
language plpgsql
as $$

	declare
			v_book_name varchar(75);
			v_isbn_book varchar(30);
	begin
		select
			issued_book_name,
			issued_book_isbn into v_book_name, v_isbn_book 
			from issued_status
			where issued_id = pt_issued_id;
		
		insert into return_status(return_id, issued_id, return_book_name, return_date, return_book_isbn)
		values (pt_return_id, pt_issued_id, v_book_name, current_date, v_isbn_book);

		update books
		set status = 'YESS'
		where isbn = v_isbn_book;

		raise notice 'The books: % has been returned',v_isbn_book;
	end;
$$

call books_st('RSSEX', 'IS134')

select * from return_status
where issued_id = 'IS134'
```


Task 15: Branch Performance Report
Generate a report for each branch with books issued, returned, and total rental revenue.
```
create table branch_report
as
select 
	b.branch_id,
	b.manager_id,
	count(isst.issued_id) as total_books_issued,
	count(re.return_id) as total_books_returned,
	sum(bk.rental_price) as total_revenue

from issued_status as isst
join employee as e
on e.emp_id = isst.issued_emp_id
join branch as b
on e.branch_id = b.branch_id
left join return_status as re
on re.issued_id = isst.issued_id
join books as bk
on isst.issued_book_isbn = bk.isbn

group by 1,2
order by 1 asc, 2 asc;

select * from branch_report;
```


Task 16: CTAS: Create a Table of Active Members
Build an active_members table for members with at least one book issued in the last 6 months.
```
create table active_members
as
select * from members
where member_id in (
	select distinct issued_member_id 
	from issued_status
	where issued_date >= current_date - interval '15' month );

select * from active_members;
```


Task 17: Find Employees with the Most Book Issues Processed
Rank the top 3 employees by books processed, including name, count, and branch.
```
select
	e.emp_name,
	count(issued_id) as books_issued,
	b.*
from issued_status as ist
join employee as e
on ist.issued_emp_id = e.emp_id
join branch as b
on e.branch_id = b.branch_id

group by 1,3;
```



Task 18: Stored Procedure
Objective: Build a stored procedure to manage book status.
Description: Update book status: 'no' on issue, 'yes' on return.

```
create or replace procedure issue_book(p_issued_id varchar(10), p_member_id varchar(10), p_book_isbn varchar(30), p_emp_id varchar(10))
language plpgsql
as $$
	declare
		v_status varchar(10);
		v_title varchar(75);
	begin
		select
			status, book_title into v_status, v_title
		from books
		where isbn = p_book_isbn;

		if v_status = 'yes' then 

			insert into issued_status (issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
			values (p_issued_id, p_member_id, v_title, current_date, p_book_isbn, p_emp_id);

			update books
				set status = 'no'
			where isbn = p_book_isbn;

			raise notice 'Book recods add sucessfully';

		else

			raise notice 'Sorry the book is not available';

		end if;
		
	end;
$$

select * from books

call issue_book('IS155', 'C108', '978-0-330-25864-8', 'E104')
```



🎯 Conclusion

This project is a vibrant toolkit for mastering library management through SQL! From basic CRUD to advanced analytics and performance reporting, it’s a springboard for learning and growth. Customize the tasks or scale the schema to fit your needs—let’s make library management exciting!



🚀 How Others Can Use This Repo





Clone the Repository: Grab it with git clone https://github.com/vinnamre/Library-Management-system-using-Sql-.git.



Set Up the Database: Load the schema into your SQL database (e.g., MySQL, PostgreSQL) and add sample data.



Execute Tasks: Run the SQL queries under each task to bring the system to life.



Contribute: Fork it, enhance it with new features or queries, and submit a pull request!



Issues & Feedback: Share your thoughts or report bugs by opening an issue on GitHub.
