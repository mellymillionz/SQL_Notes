
#COUNT(DISTINCT)
Get the number of distinct rows from a column:
```sql
SELECT COUNT(DISTINCT birthdate)
FROM people;
```

# between two conditions
```sql
SELECT *
FROM films
WHERE language = 'Spanish'
AND release_year > 2000 AND release_year < 2010;
```

Now you'll write a query to get the title and release year of films released in the 90s which were in French or Spanish and which took in more than $2M gross.

```sql
SELECT title, release_year
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')
AND gross > 2000000;
```

# BETWEEN
It's important to remember that BETWEEN is inclusive, meaning the beginning and end values are included in the results!

 Title and release year of all Spanish or French language films released between 1990 and 2000 (inclusive) with budgets over $100 million. 
```sql
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 and 2000
AND budget > 100000000
AND (language = 'French' OR language = 'Spanish');
```
# WHERE IN

 The IN operator allows you to specify multiple values in a WHERE clause, making it easier and quicker to specify multiple OR conditions!
```sql
SELECT name
FROM kids
WHERE age = 2
OR age = 4
OR age = 6
OR age = 8
OR age = 10;

---CAN ACTUALLY JUST BE:
SELECT name
FROM kids
WHERE age IN (2, 4, 6, 8, 10);

---ANOTHER EXAMPLE:
SELECT title, certification
FROM films
WHERE certification IN ('NC-17', 'R');
```

# EXCEPT aka <>
ALL films except those in 2015

```sql
SELECT *
From films
WHERE release_year <> 2015
ORDER BY duration;
```

# NULL / IS NULL / IS NOT NULL

Check is some is alive!
```sql 
SELECT name
FROM people
WHERE deathdate IS NULL;
```

# LIKE / NOT LIKE
wildcard!

For example, the following query matches companies like 'Data', 'DataC' 'DataCamp', 'DataMind', and so on:
```sql
SELECT name
FROM companies
WHERE name LIKE 'Data%';
```
The _ wildcard will match a single character. For example, the following query matches companies like 'DataCamp', 'DataComp', and so on:
```sql
SELECT name
FROM companies
WHERE name LIKE 'DataC_mp';
```

# ALIAS with ADDITION for NEW COLUMN
```sql
SELECT title, (gross - budget) AS net_profit
FROM films;
-- returns the title of the move with a new column called 'net_profit'
```
Get the title and duration in hours for all films. The duration is in minutes, so you'll need to divide by 60.0 to get the duration in hours. Alias the duration in hours as duration_hours.

```sql
SELECT title, 
(duration/60.0) AS duration_hours
FROM films;
```
```sql
SELECT AVG(duration) / 60.00 AS avg_duration_hours
from films;     
```
Determine the percent of dead people in the database:
```sql
SELECT COUNT(deathdate) * 100.00 / COUNT(*) AS percentage_dead
FROM people;
```

# ORDER BY mutliple columns

Try using ORDER BY to sort multiple columns! Remember, to specify multiple columns you separate the column names with a comma.
```sql
SELECT birthdate, name
FROm people
ORDER BY birthdate, name;
```

#GROUP BY

A word of warning: SQL will return an error if you try to SELECT a field that is not in your GROUP BY clause without using it to calculate some kind of value about the entire group.

Get the release year and count of films released in each year.
```sql
SELECT release_year, COUNT(*)
FROM films
GROUP BY release_year;
```
Get the release year, country, and highest budget spent making a film for each year, for each country. Sort your results by release year and country.
```sql
SELECT release_year, country, MAX(budget)
FROM films
GROUP BY release_year, country
ORDER BY release_year, country;
```

Now you're going to write a query that returns the average budget and average gross earnings for films in each year after 1990, if the average budget is greater than $60 million.

```sql
SELECT release_year,
AVG(budget) as avg_budget,
AVG(gross) as avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget)> 60000000
ORDER BY AVG(gross) DESC;
```

#INNER JOINS

#SELF JOIN
Use the populations table to perform a self-join to calculate the percentage increase in population from 2010 to 2015 for each country code!
```sql

SELECT p1.country_code,
       p1.size AS size2010,
       p2.size AS size2015
FROM populations as p1
    INNER JOIN populations as p2
    ON p1.country_code = p2.country_code
        WHERE p1.year = p2.year-5;
```
you'll use the populations table to perform a self-join to calculate the percentage increase in population from 2010 to 2015 for each country code!
```sql
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- 1. calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- 2. From populations (alias as p1)
FROM populations AS p1
  -- 3. Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- 4. Match on country code
    ON p1.country_code = p2.country_code
        -- 5. and year (with calculation)
        AND p1.year = p2.year - 5;
```

#CASE WHEN

```sql
SELECT name, continent, code, surface_area,
    -- 1. First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- 2. Second case
        WHEN surface_area > 350000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name
        AS geosize_group
-- 5. From table
FROM countries;
```
With a where clause:
```sql
SELECT country_code, size,
    -- 1. First case
    CASE WHEN size > 50000000 THEN 'large'
        -- 2. Second case
        WHEN size > 1000000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name (popsize_group)
        AS popsize_group
-- 5. From table
FROM populations
-- 6. Focus on 2015
WHERE year = 2015;
```
#INTO

Copies some of the columns into a new table, which you can then query!

```sql

SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;

-- 5. Select fields
SELECT * 
-- 1. From countries_plus (alias as c)
FROM countries_plus as c
  -- 2. Join to pop_plus (alias as p)
  JOIN pop_plus as p
    -- 3. Match on country code
    ON p.country_code = c.code
-- 4. Order the table    
ORDER BY geosize_group ASC;
```

# INNER JOIN vs LEFT JOIN

You'll use INNER JOIN when you want to return only records having pair on both sides, and you'll use LEFT JOIN when you need all records from the “left” table, no matter if they have pair in the “right” table or not.

The following queries are almost identical but the INNER JOIN version resulted in 909 records. The LEFT JOIN version returned 916 rows.

LEFT JOIN
```sql
SELECT c.name AS country, local_name, l.name AS language, percent
-- 1. From left table (alias as c)
FROM countries AS c
  -- 2. Join to right table (alias as l)
  LEFT JOIN languages AS l
    -- 3. Match on fields
    ON c.code = l.code
-- 4. Order by descending country
ORDER BY country DESC;
```
INNER JOIN
```sql
SELECT c.name AS country, local_name, l.name AS language, percent
-- 1. From left table (alias as c)
FROM countries AS c
  -- 2. Join to right table (alias as l)
  INNER JOIN languages AS l
    -- 3. Match on fields
    ON c.code = l.code
-- 4. Order by descending country
ORDER BY country DESC;
```