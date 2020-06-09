
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