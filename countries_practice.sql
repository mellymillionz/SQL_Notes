SELECT *
FROM countries;

SELECT * 
FROM population_years;

SELECT COUNT(*)
FROM countries
WHERE continent = 'Africa';

SELECT ROUND(SUM(population_years.population), 2)
FROM population_years
JOIN countries
ON countries.id = population_years.country_id
WHERE population_years.year = 2005
AND countries.continent = 'Oceania'
GROUP BY countries.continent;

SELECT ROUND(AVG(population_years.population),2)
FROM population_years
JOIN countries
ON countries.id = population_years.country_id
WHERE population_years.year = 2003
AND countries.continent = 'South America';

SELECT population_years.population,
countries.name 
FROM population_years
JOIN countries
ON countries.id = population_years.country_id
WHERE population_years.year = 2007
GROUP BY countries.name
ORDER BY population_years.population ASC;

SELECT ROUND(AVG(population_years.population), 2)
FROM population_years
JOIN countries
ON countries.id = population_years.country_id
WHERE countries.name ='Poland';

SELECT
countries.name
FROM countries
WHERE countries.name LIKE '%The%';

SELECT ROUND(SUM(population_years.population), 2),
countries.continent
FROM population_years
JOIN countries
ON countries.id = population_years.country_id
WHERE population_years.year = 2010
GROUP BY countries.continent;