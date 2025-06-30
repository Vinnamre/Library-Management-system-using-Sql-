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


