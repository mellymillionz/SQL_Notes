
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

-- 'WITH' subquery. Here, we are essentially giving everything inside the parentheses (the sub-query) the name of previous_query using AS.
-- Here, previous_query is basically just a temporary table that we can join on.

WITH previous_query AS
(SELECT customer_id,
  COUNT(subscription_id) AS 'subscriptions'
FROM orders
GROUP BY customer_id)
SELECT customers.customer_name,
previous_query.subscriptions
FROM previous_query
JOIN customers
  ON previous_query.customer_id = customers.customer_id;

-- CASE

SELECT name,
CASE
  WHEN review > 4.5 THEN "YUM!"
  WHEN review > 4 THEN "Pretty yummy"
  WHEN review > 3 THEN "Medium ok"
  WHEN review > 2 THEN "Meh"
  ELSE "YUCK!"
END AS 'Review'
FROM nomnom;

-- RANK

SELECT
  name,
  RANK() OVER (ORDER BY review DESC) AS rankedreview
FROM
  nomnom
;

-- Three dollar signs or more.

SELECT name, price, cuisine
FROM nomnom
WHERE price LIKE '%$$$%'
AND cuisine = 'Italian';

-- EXACTLY three dollar signs.

SELECT name, price, cuisine
FROM nomnom
WHERE price = '$$$'
AND cuisine = 'Italian';

-- Generate a table of user ids and total watch duration for users who watched more than 400 minutes of content.

SELECT user_id, SUM(watch_duration_in_minutes) AS total_duration
FROM watch_history
GROUP BY 1
HAVING SUM(watch_duration_in_minutes) > 400;

-- Find all the users that have successfully made a payment to Codeflix and find their total amount paid.

SELECT user_id, SUM(amount)
FROM payments
WHERE status = 'paid'
GROUP BY user_id
ORDER BY 2 DESC;

-- Which days in this period did Codeflix collect the most money?

SELECT pay_date, SUM(amount)
FROM payments
WHERE status = "paid"
GROUP BY pay_date
ORDER BY 2 DESC;

-- Temporary Table Join

WITH play_count as
(SELECT song_id,
COUNT(*) as 'times_played'
FROM plays
GROUP BY song_id)
SELECT songs.title,
songs.artist,
play_count.times_played
FROM play_count
JOIN songs
ON songs.id = play_count.song_id;

-- CREATE TABLE SQL SERVER. CONSTRAINT allows you to name the foreign key

CREATE TABLE procurement.vendors (
    venfor_id INT IDENTITY PRIMARY KEY,
    group_id INT NOT NULL,
    CONSTRAINT special_name FOREIGN KEY (group_id)
    REFERENCES procurement.vendor_groups(group_id)
);

-- SQL server
SELECT TOP 3 * FROM Customers;

-- Uncorrelated Subqueries: 
-- Using a subquery, find the average total distance flown by day of week and month.

SELECT a.dep_month,
       a.dep_day_of_week,
       AVG(a.flight_distance) AS average_distance
  FROM (
        SELECT dep_month,
              dep_day_of_week,
               dep_date,
               sum(distance) AS flight_distance
          FROM flights
         GROUP BY 1,2,3
       ) a
 GROUP BY 1,2
 ORDER BY 1,2;

-- Correlated subquery: the subquery can not be run independently of the outer query. The order of operations is important in a correlated subquery:
-- A row is processed in the outer query. Then, for that particular row in the outer query, the subquery is executed.
-- The below query returns all flight ids where the flight distance was below the average. It runs through each row and compares it to the average, then returns or not.

SELECT id
FROM flights as f
WHERE distance < (
  SELECT AVG(distance)
  FROM flights
  WHERE carrier = f.carrier
);

-- Correlated Subqueries 2: Using the same pattern, write a query to view flights by origin, flight id, and sequence number. Alias the sequence number column as flight_sequence_number.

SELECT origin, id, 
  (SELECT COUNT(*)
  FROM flights f
  WHERE f.id < flights.id
  AND f.origin = flights.origin) +1
AS flight_sequence_number
FROM flights;

-- UNION ALL to find average sale price by consumer between current and historic tables
-- Group by 1 allows them to be grouped by the user ID thus providing the aggregate average for each user.

SELECT id, avg(a.sale_price) FROM (
  SELECT id, sale_price FROM order_items
  UNION ALL
  SELECT id, sale_price FROM order_items_historic) AS a 
  GROUP BY 1;


