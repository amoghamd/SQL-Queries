--1. Query a count of the number of cities in CITY having a Population larger than 100,000.
SELECT count(name)

FROM city
WHERE population > 100000

--2. Query the total population of all cities in CITY where District is California.
SELECT sum(population)
FROM city
WHERE district  = 'California'

--3.Query the average population of all cities in CITY where District is California.

SELECT avg(population)

FROM city

WHERE district = ('california')

--4. Query the average population for all cities in CITY, rounded down to the nearest integer.
SELECT round(avg(population),0)
FROM CITY

--5. Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
SELECT SUM(POPULATION)
FROM CITY
WHERE COUNTRYCODE = 'JPN'

--6. Query the difference between the maximum and minimum populations in CITY.
SELECT max(population)-min (population)
FROM CITY

--7. Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's 0 key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.
select (Avg(Salary) - Avg(Cast(Replace(Salary,'0','') as int))) + 1 from Employees

--8. We define an employee's total earnings to be their monthly salary*months worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2 space-separated integers.
SELECT t.max,count(t.employee_id)

FROM
(
SELECT employee_id, salary*months AS total_salary, max(salary*months) oVER() AS max
FROM employee
) t
WHERE t.total_salary = t.max
GROUP BY t.max

--9. A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.
SELECT DISTINCT t.LAT

FROM
(SELECT  CONVERT(DECIMAL(10,4),percentile_cont(.5) WITHIN GROUP (ORDER BY LAT_N) OVER()) AS LAT FROM STATION) t

--10. Consider P1(a,b) and P2(a,b)  to be two points on a 2D plane.
-- a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
-- b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
-- c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
-- d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
--Query the Manhattan Distance between points P1  and P2  and round it to a scale of 4 decimal places.

SELECT CONVERT(DECIMAL(10,4),ABS(min(LAT_N) - max(LAT_N)) + ABS(min(LONG_W)-max(LONG_W)))
FROM STATION
