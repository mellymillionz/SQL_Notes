
-- CREATE TABLE

CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
);

-- Alter and Insert

INSERT INTO 
dbo.offices(office_name, office_address)
VALUES
('silicon valley', '400 East 119th');

-- Select only even rows

Select studentId 
FROM (Select rowno, studentId from student) 
WHERE mod(rowno,2)=0;

-- Select unique records from a table

Select 
DISTINCT StudentID, StudentName 
from Student;

-- fetch first 5 characters of the string:

SELECT
SUBSTRING(student_name, 1, 5) as studentname 
FROM students;

-- Extract 3 characters from a string, starting in position 1:

SELECT SUBSTRING('SQL Tutorial', 1, 3) AS ExtractString;

-- Pattern matching query: '%' matches zero or more character and _ underscore matched exactly one character.

SELECT *
FROM student
WHERE student_name like 'a%';

SELECT *
FROM student
WHERE student_name like 'ami_'

-- Join two tables:

SELECT FirstName, LastName, City, State
FROM Person
LEFT JOIN Address
ON Person.PersonId = Address.PersonId;

-- ORDER BY

SELECT *
FROM sales.customers
WHERE state = 'CA'
ORDER BY first_name;

-- GROUP BY: the following statement returns all the cites of customers located in California and the number of customers in each city.

SELECT city, COUNT(*)
FROM sales.customers
WHERE state = 'CA'
GROUP BY city
ORDER BY city;

-- Filter groups by one or more conditions using HAVING: 
-- This example returns the city in CA that has more than 10 customers

SELECT
    city,
    COUNT(*)
FROM sales.customers
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(*) > 10
ORDER BY city;


