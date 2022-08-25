-- 1. Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:
--  Equilateral: It's a triangle with  sides of equal length.
--  Isosceles: It's a triangle with  sides of equal length.
--  Scalene: It's a triangle with  sides of differing lengths.
--  Not A Triangle: The given values of A, B, and C don't form a triangle.

SELECT CASE 
WHEN A+B <= C or B+C <=A OR A+C <= B then "Not A Triangle"
WHEN a=b AND a=c AND b=c then "Equilateral"
WHEN a=b OR a=c OR b=c  then "Isosceles"
WHEN a<>b AND a<>c AND b<> C then  "Scalene"
end

FROM triangles;

-- 2. 1.Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
    --2. Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:There are a total of [occupation_count] [occupation]s.
    --where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

SELECT CONCAT(name,'(',UPPER(left(occupation,1)),')')
FROM occupations
ORDER BY name;

SELECT CONCAT('There are a total of ', count(occupation),' ', LOWER(occupation),'s.')
FROM occupations
GROUP by occupation
Order by count(occupation),occupation

--3. Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
     Note: Print NULL when there are no more names corresponding to an occupation.

select
    [Doctor], [Professor], [Singer], [Actor]
from (
    select
        rn = rank() over (partition by o.occupation order by o.name),
        o.name,
        o.occupation
    from OCCUPATIONS o
) s
pivot (
    max(name) 
    for occupation in ([Doctor], [Professor], [Singer], [Actor])
) as p;
