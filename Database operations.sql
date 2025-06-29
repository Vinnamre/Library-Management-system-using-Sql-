-- CRUD Operations

-- 1.Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

-- 2. Update an Existing member's address

update members
set member_address = '125 Oak St'
where member_id = 'C103';

-- 3. Delete a record from the issued status table where issued_id = 'IS121'

delete from issued_status
where issued_id = 'IS121';

-- 4. Retrieve all the books issued by a specific employee with emp_id = 'E101'

select * from issued_status
where issued_emp_id = 'E101';

-- 5. List of members who have issued more than one book

select 
	issued_member_id,
	count(issued_id)
	from issued_status
group by issued_member_id
having count(issued_id) > 1;

-- 6. Create summary tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

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

-- 7. Retrieve All Books in a Specific Category:

select * from books
where category = 'Classic';

-- 8. Find Total Rental Income by Category:

select 
	b.category as category,
	sum(b.rental_price) as total_price,
	count(*)
	from books as b
	join book_issued_counts as isst
	on b.isbn = isst.book_id
	group by 1
	order by total_price desc;

-- 9. List Members Who Registered in the Last 180 Days:
select * from members
insert into members(member_id, member_name, member_address, reg_date)
values
('C121', 'Sami Zayn', '131 Main St', '2025-03-12'),
('C122', 'Karion Kross', 'broklyn St', '2025-01-19');

select * from members
where reg_date >= current_date - interval '180 days';

-- 10. List Employees with Their Branch Manager's Name and their branch details:

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

-- 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as
select * from books
where rental_price > 7.00;

select * from expensive_books

-- 12. Retrieve the List of Books Not Yet Returned

select 
	i.issued_id,
	i.issued_book_name,
	r.return_id
from issued_status as i
left join return_status as r
on i.issued_id = r.issued_id
where r.return_id is NULL;



