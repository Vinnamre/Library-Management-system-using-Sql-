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


Task 2: Update an Existing Member's Address
Refresh a member's address with ease!

update members
set member_address = '125 Oak St'
where member_id = 'C103';


Task 3: Delete a Record from the Issued Status Table
Objective: Remove the record with issued_id = 'IS104' from the issued_status table.



Task 4: Retrieve All Books Issued by a Specific Employee
Objective: Fetch all books issued by the employee with emp_id = 'E101'.



Task 5: List Members Who Have Issued More Than One Book
Objective: Use GROUP BY to spotlight members with multiple book issues.

✨ 3. CTAS (Create Table As Select)





Task 6: Create Summary Tables
Leverage CTAS to craft new tables showcasing each book and total book_issued_cnt.

✨ 4. Data Analysis & Findings





Task 7: Retrieve All Books in a Specific Category
Explore books by category!



Task 8: Find Total Rental Income by Category
Calculate the revenue per category.



Task 9: List Members Who Registered in the Last 180 Days
Highlight new members!



Task 10: List Employees with Their Branch Manager's Name and Branch Details
Get the full employee-branch scoop.



Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
Filter high-value rentals.



Task 12: Retrieve the List of Books Not Yet Returned
Track outstanding books.

✨ Advanced SQL Operations





Task 13: Identify Members with Overdue Books
Spot members with books overdue (assume a 30-day return period). Show member's name, book title, issue date, and days overdue.



Task 14: Update Book Status on Return
Set books to "available" in the books table upon return (based on return_status entries).



Task 15: Branch Performance Report
Generate a report for each branch with books issued, returned, and total rental revenue.



Task 16: CTAS: Create a Table of Active Members
Build an active_members table for members with at least one book issued in the last 6 months.



Task 17: Find Employees with the Most Book Issues Processed
Rank the top 3 employees by books processed, including name, count, and branch.



Task 18: Identify Members Issuing High-Risk Books
Find members issuing "damaged" books more than twice. Display name, title, and issue count.



Task 19: Stored Procedure
Objective: Build a stored procedure to manage book status.
Description: Update book status: 'no' on issue, 'yes' on return.



🎯 Conclusion

This project is a vibrant toolkit for mastering library management through SQL! From basic CRUD to advanced analytics and performance reporting, it’s a springboard for learning and growth. Customize the tasks or scale the schema to fit your needs—let’s make library management exciting!



🚀 How Others Can Use This Repo





Clone the Repository: Grab it with git clone https://github.com/vinnamre/Library-Management-system-using-Sql-.git.



Set Up the Database: Load the schema into your SQL database (e.g., MySQL, PostgreSQL) and add sample data.



Execute Tasks: Run the SQL queries under each task to bring the system to life.



Contribute: Fork it, enhance it with new features or queries, and submit a pull request!



Issues & Feedback: Share your thoughts or report bugs by opening an issue on GitHub.
