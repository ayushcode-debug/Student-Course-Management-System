CREATE DATABASE CollegeDB;
USE CollegeDB;

CREATE TABLE Course (
    course_id INT NOT NULL AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    duration_months TINYINT NOT NULL,
    fees DECIMAL(10 , 2 ) NOT NULL CHECK (fees >= 0),
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (course_id),
    UNIQUE KEY uq_course_code (course_code)
);

CREATE TABLE Student (
    student_id INT NOT NULL AUTO_INCREMENT,
    roll_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    gender ENUM('M', 'F', 'O') DEFAULT 'O',
    birth_date DATE,
    city VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id),
    UNIQUE KEY uq_roll (roll_number),
    UNIQUE KEY uq_email (email)
);

CREATE TABLE Teacher (
    teacher_id INT NOT NULL AUTO_INCREMENT,
    teacher_code VARCHAR(30) NOT NULL,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (teacher_id),
    UNIQUE KEY uq_teacher_code (teacher_code),
    UNIQUE KEY uq_teacher_email (email)
);

CREATE TABLE Enrollment (
  enroll_id INT NOT NULL AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  teacher_id INT,
  enroll_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  status ENUM('active','completed','dropped') NOT NULL DEFAULT 'active',
  final_grade VARCHAR(5),
  fee_paid DECIMAL(10,2) DEFAULT 0 CHECK (fee_paid >= 0),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (enroll_id),
  UNIQUE KEY uq_student_course (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (course_id)  REFERENCES Course(course_id)  ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Payment (
  payment_id INT NOT NULL AUTO_INCREMENT,
  enroll_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  paid_on DATE NOT NULL DEFAULT (CURRENT_DATE),
  method VARCHAR(30),
  reference VARCHAR(100),
  PRIMARY KEY (payment_id),
  FOREIGN KEY (enroll_id) REFERENCES Enrollment(enroll_id) ON DELETE CASCADE
);

INSERT INTO Course (course_code, name, duration_months, fees, description) VALUES
('DS101','Data Science',6,35000.00,'Intro to data science projects'),
('PY201','Python Programming',3,18000.00,'Python fundamentals & libs'),
('WD301','Web Development',4,25000.00,'Frontend + backend basics');

INSERT INTO Student (roll_number, first_name, last_name, gender, birth_date, city, email, phone) VALUES
('R2025001','Ayush','Bhardwaj','M','2004-02-15','Delhi','ayush@example.com','9876543210'),
('R2025002','Riya','Khan','F','2003-07-10','Mumbai','riya@example.com','9123456780'),
('R2025003','Karan','Verma','M','2005-01-20','Pune','karan@example.com','9988776655'),
('R2025004','Simran','Singh','F','2002-11-05','Delhi','simran@example.com','9012345678');

INSERT INTO Teacher (teacher_code, name, specialization, email) VALUES
('T001','Dr. Mehta','Data Science','mehta@example.com'),
('T002','Mrs. Sharma','Python','sharma@example.com'),
('T003','Mr. Arjun','Web Development','arjun@example.com');

INSERT INTO Enrollment (student_id, course_id, teacher_id, enroll_date, status, fee_paid) VALUES
(1, 1, 1, '2024-05-01', 'active', 35000.00),
(2, 2, 2, '2024-06-15', 'active', 18000.00),
(3, 3, 3, '2024-07-10', 'active', 25000.00),
(4, 1, 1, '2024-08-20', 'completed', 35000.00);

INSERT INTO Payment (enroll_id, amount, paid_on, method, reference) VALUES
(1, 35000.00, '2024-05-01', 'card', 'TXN1001'),
(2, 18000.00, '2024-06-15', 'cash', 'RCPT2002'),
(3, 25000.00, '2024-07-10', 'card', 'TXN3003');

SELECT 
    COUNT(*) AS total_students
FROM
    Student;
SELECT 
    COUNT(*) AS total_courses
FROM
    Course;
SELECT 
    COUNT(*) AS total_enrollments
FROM
    Enrollment;
SELECT 
    *
FROM
    Student;

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    c.name AS course,
    t.name AS teacher,
    e.enroll_date,
    e.status
FROM
    Enrollment e
        JOIN
    Student s ON e.student_id = s.student_id
        JOIN
    Course c ON e.course_id = c.course_id
        LEFT JOIN
    Teacher t ON e.teacher_id = t.teacher_id;

SELECT 
    c.name,
    COUNT(e.enroll_id) AS students_enrolled,
    SUM(e.fee_paid) AS revenue
FROM
    Course c
        LEFT JOIN
    Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id , c.name;

SELECT 
    first_name, last_name
FROM
    Student
WHERE
    student_id NOT IN (SELECT 
            student_id
        FROM
            Enrollment);
SELECT 
    *
FROM
    Enrollment
WHERE
    enroll_date > '2024-06-30'
ORDER BY enroll_date DESC;

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, city
FROM
    student
WHERE
    city = 'Delhi';

SELECT 
    t.name AS teacher_name, COUNT(e.enroll_id) AS total_students
FROM
    Teacher t
        JOIN
    Enrollment e ON t.teacher_id = e.teacher_id
GROUP BY t.teacher_id , t.name
ORDER BY total_students DESC
LIMIT 1;

SELECT 
    CONCAT(s.first_name, s.last_name) AS student_name,
    SUM(p.amount) AS total_fee_paid
FROM
    student s
        JOIN
    Enrollment e ON s.student_id = e.student_id
        LEFT JOIN
    Payment p ON e.enroll_id = p.enroll_id
GROUP BY s.student_id , student_name;

UPDATE Student 
SET 
    email = 'ayushbh045@gmail.com'
WHERE
    student_id = 1;

SELECT student_id, first_name, email
FROM Student
WHERE student_id = 1;

DELETE FROM Student 
WHERE
    student_id = 3;

SELECT 
    *
FROM
    Enrollment
WHERE
    student_id = 3;
SELECT 
    *
FROM
    Payment
WHERE
    enroll_id NOT IN (SELECT 
            enroll_id
        FROM
            Enrollment);
INSERT INTO Course (course_code, name, duration_months, fees, description)
VALUES ('SQL101', 'SQL Basics', 2, 12000.00, 'Intro to SQL');

INSERT INTO Enrollment (student_id, course_id, teacher_id, enroll_date, fee_paid)
VALUES (1, LAST_INSERT_ID(), 2, CURDATE(), 12000.00);

CREATE VIEW student_enrollments AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    c.name AS course_name,
    t.name AS teacher_name,
    e.enroll_date,
    e.status
FROM
    Enrollment e
        JOIN
    Student s ON e.student_id = s.student_id
        JOIN
    Course c ON e.course_id = c.course_id
        LEFT JOIN
    Teacher t ON e.teacher_id = t.teacher_id;

SELECT 
    *
FROM
    student_enrollments;

CREATE INDEX idx_enroll_date ON Enrollment (enroll_date);

# Meaning:
#Indexing enroll_date makes queries like:
SELECT 
    *
FROM
    Enrollment
WHERE
    enroll_date >= '2024-01-01';
# much faster because SQL can quickly find rows by date instead of scanning the entire table.