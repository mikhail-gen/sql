CREATE TABLE students (
   student_id INT PRIMARY KEY,
   full_name VARCHAR(100),
   age INT,
   group_id INT
);

CREATE TABLE groups (
   group_id INT PRIMARY KEY,
   group_name VARCHAR(50)
);

CREATE TABLE subjects (
   subject_id INT PRIMARY KEY,
   subject_name VARCHAR(50)
);

CREATE TABLE grades (
   grade_id INT PRIMARY KEY,
   student_id INT,
   subject_id INT,
   grade INT,
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

--1
INSERT INTO groups (group_id, group_name)
VALUES
(1, 'Group A'),
(2, 'Group B');

INSERT INTO students (student_id, full_name, age, group_id)
VALUES
(1, 'Alice Smith', 20, 1),
(2, 'Bob Johnson', 21, 1),
(3, 'Charlie Brown', 19, 2),
(4, 'Diana Miller', 22, 2);

INSERT INTO subjects (subject_id, subject_name)
VALUES
(1, 'Mathematics'),
(2, 'Physics'),
(3, 'Chemistry');

INSERT INTO grades (grade_id, student_id, subject_id, grade)
VALUES
(1, 1, 1, 85), -- Alice, Mathematics
(2, 1, 2, 90), -- Alice, Physics
(3, 2, 1, 78), -- Bob, Mathematics
(4, 2, 3, 88), -- Bob, Chemistry
(5, 3, 2, 92), -- Charlie, Physics
(6, 3, 3, 81), -- Charlie, Chemistry
(7, 4, 1, 95), -- Diana, Mathematics
(8, 4, 2, 87); -- Diana, Physics

--2
select count(student_id)
from students

--3
select avg(age)
from students

--4
select min(age), max(age)
from students

--5
select count(grade_id)
from grades

--6
select group_id, count(student_id) as student_count
from students
group by group_id
order by group_id asc

--7
select group_id, avg(age)
from students
group by group_id
order by group_id asc

--8
select g.subject_id, s.subject_name, avg(grade)
from grades g
left join subjects s on g.subject_id = s.subject_id
group by g.subject_id, s.subject_name;

--9
selext g.student_id
from grades g
group by g.student_id
HAVING COUNT(DISTINCT g.subject_id) = (SELECT COUNT(*) FROM subjects);

--10
select group_id
from students s
group by group_id
having count(s.student_id) > 1;

--11
select g.subject_id, s.subject_name, avg(grade)
from grades g
left join subjects s on g.subject_id = s.subject_id
group by g.subject_id, s.subject_name
having avg(grade)>8;

--12
select g.student_id, s.full_name, avg(g.grade)
from grades g
left join students s on g.student_id = s.student_id
group by g.student_id, s.full_name
having avg(g.grade)>8.5;