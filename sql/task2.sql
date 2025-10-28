CREATE TABLE students (
                         student_id SERIAL PRIMARY KEY,
                         first_name VARCHAR(50) NOT NULL,
                         last_name VARCHAR(50) NOT NULL,
                         birth_date DATE NOT NULL,
                         email VARCHAR(100) UNIQUE,
                         group_id INT NOT NULL
);

--1
INSERT INTO students (first_name, last_name, birth_date, email, group_id)
VALUES
-- Unique students
('Alice', 'Smith', '2002-05-14', 'alice.smith@example.com', 1),
('Bob', 'Johnson', '2001-08-22', 'bob.johnson@example.com', 1),
('Diana', 'Miller', '2002-11-05', 'diana.miller@example.com', 2),
-- Duplicate students
('Charlie', 'Brown', '2003-01-30', 'charlie.brown2@example.com', 2),
('Charlie', 'Brown', '2003-01-30', 'charlie.brown@example.com', 2);

--2
select
    first_name,
    last_name,
    COUNT(*) AS duplicate_count
from students
GROUP BY first_name, last_name
having COUNT(*) > 1;

--3
delete from students
WHERE student_id NOT IN (
    SELECT MIN(student_id)
    from students
    group by first_name, last_name);