--1. Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.
SELECT sum(c.population)
FROM city c
JOIN Country cr ON c.countrycode = cr.code
WHERE continent = 'Asia'

--2. Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
SELECT c.name
FROM city C
INNER JOIN COUNTRY CO
ON C.countrycode  = CO.code
WHERE CO.continent = 'Africa'

--3. Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
SELECT c.continent, ROUND(AVG(ct.population),0)
FROM COUNTRY c
INNER JOIN 
CITY ct ON ct.countrycode = c.code
GROUP BY c.continent

--4.  You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks.
--Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8. 
--The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. 
--If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.
--Write a query to help Eve.

select s.name, g.grade, s.marks from students s, grades g where g.grade>=8 and s.marks between g.min_mark and g.max_mark order by g.grade desc, s.name;

select 'NULL', g.grade, s.marks from students s, grades g where g.grade<8 and s.marks between g.min_mark and g.max_mark order by g.grade desc, s.marks;

--5. Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! 
    --Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of challenges in which the hacker earned a full score. 
    --If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.
with temp as 
(
SELECT DISTINCT h.hacker_id, h.name , t.num_chall
FROM hackers h
    JOIN (
    
  SELECT s.hacker_id , h.name,  s.challenge_id,
    COUNT(s.challenge_id) OVER(PARTITION BY s.hacker_id ORDER BY s.hacker_id) [num_chall]
FROM submissions s
INNER JOIN challenges c
ON s.challenge_id = c.challenge_id 
INNER JOIN difficulty d ON c.difficulty_level = d.difficulty_level 
    join hackers h
    on s.hacker_id = h.hacker_id
    WHERE s.score = d.score
) AS t 
ON h.hacker_id = t.hacker_id
    WHERE t.num_chall > 1
    ) 
    SELECT hacker_id, name
    from temp
    ORDER BY num_chall DESC , 1 ASC
    
    --6. The total score of a hacker is the sum of their maximum scores for all of the challenges. 
    --Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. 
    --If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of  from your result.
    SELECT hacker_id, name, total_score
FROM
  (SELECT 
    hacker_id, 
    name, 
    SUM(Max_score) as total_score
FROM
    (SELECT 
    h.hacker_id,
    h.name,
    MAX(s.score) as Max_score
FROM Hackers h
    JOIN Submissions s
ON h.hacker_id = s.hacker_id
GROUP BY h.hacker_id, h.name, s.challenge_id) as source
GROUP BY hacker_id, name) result
WHERE total_score != 0
ORDER BY 3 DESC, 1 ASC;

--7. Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.

--Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. 
--Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. 
--If more than one wand has same power, sort the result in order of descending age.

SELECT w.id, wp.age, w.coins_needed, w.power
FROM wands AS w
INNER JOIN wands_property AS wp
ON w.code = wp.code
WHERE wp.is_evil = 0 AND 
      w.coins_needed IN (SELECT MIN(wa.coins_needed)
                         FROM wands AS wa
                         WHERE wa.code = wp.code
                         GROUP BY wa.power)
ORDER BY power DESC, age DESC

 


    
    
