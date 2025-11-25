🧑‍🎓 Student Course Management System – SQL Project

This is a complete SQL-based relational database project designed to manage Students, Courses, Teachers, Enrollments, and Payments.
The project includes full SQL scripts, ER diagram, and exported output datasets.

📂 Project Structure
student-course-management-system/
│── student course management system.sql
│── outputs/
│    ├── Course table.csv
│    ├── Enrollment table.csv
│    ├── MySQL Screenshot 1.png
│    ├── MySQL Screenshot 2.png
│    ├── MySQL Screenshot 3.png
│    ├── Teacher table.csv
│    ├── student table.csv
│── README.md
│── ERD.png

🧩 ER Diagram
![ER Diagram](./ERD.png)

▶ How to Run the Project

Install MySQL or use an online SQL editor.

Run the SQL script:

source student course management system.sql;


This will automatically:

✔ Create database
✔ Create tables
✔ Insert sample data

📊 Example SQL Query
SELECT 
    s.first_name,
    s.last_name,
    c.name AS course,
    t.name AS teacher,
    e.enroll_date
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id
JOIN Teacher t ON e.teacher_id = t.teacher_id;

🎯 What This Project Demonstrates

Relational database design

Primary/foreign keys

ER diagram modeling

SQL joins and constraints

CSV export for data analysis

GitHub project documentation

🚀 Future Enhancements

Attendance table

Admin login module

Power BI dashboard

API integration (Node.js/Python)

✔ Project ready for resume + portfolio
✔ Ideal for Data Analyst, SQL Developer, DBMS portfolio
