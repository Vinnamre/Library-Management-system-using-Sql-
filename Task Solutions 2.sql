select * from books;
select * from branch;
select * from employee;
select * from issued_status;
select * from members;
select * from return_status;



-- Task 13: Identify Members with Overdue Books Write a query to identify members who have overdue books (assume a 450-day return period as data is from 2024). Display the member's_id, member's name, book title, issue date, and days overdue.

-- members // books // issued_status // return status

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



-- Task 14: Update Book Status on Return Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

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


-- Task 15: Branch Performance Report Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

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


-- Task 16: CTAS: Create a Table of Active Members Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 15 months.

create table active_members
as
select * from members
where member_id in (
	select distinct issued_member_id 
	from issued_status
	where issued_date >= current_date - interval '15' month );

select * from active_members;

-- Task 17: Find Employees with the Most Book Issues Processed Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

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
