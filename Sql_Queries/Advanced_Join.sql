--1. You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. 
    --It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
    --If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.
    --Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. 
    --If there is more than one project that have the same number of completion days, then order by the start date of the project.

SELECT Start_Date, End_Date
FROM
(
SELECT cum_total, min(Start_Date) as Start_Date, max(End_Date) as End_Date,
        DATEDIFF(day,min(Start_Date) , max(End_Date)) as date_diff
FROM
(
SELECT Task_ID, Start_Date, End_Date, date_dif, 
    SUM(date_dif) OVER(ORDER BY End_Date) AS cum_total
FROM
(
SELECT Task_ID, Start_Date, End_Date, 
   COALESCE(ABS(DATEDIFF(day,lead_date , End_Date)) -1, 0) AS date_dif
FROM
    (
        SELECT Task_ID, Start_Date, End_Date,
        LAG(End_Date,1) OVER( ORDER BY End_Date) AS lead_date
        FROM Projects
    ) AS base_tab
) as final_tab
) as result
Group By cum_total
) as fin
Order by date_diff asc, Start_Date
    ;
    
--2. You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). 
  -- Packages contains two columns: ID and Salary (offered salary in $ thousands per month).
  --Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends. 
  --It is guaranteed that no two students got same salary offer.
  SELECT t.name
FROM    
(SELECT s.name,f.id,f.friend_id,p.salary as salary,pp.salary as friend_salary
FROM students s
JOIN friends f on s.id = f.id
JOIN packages p on f.id = p.id  
JOIN packages pp
ON f.friend_id = pp.id) t

WHERE t.salary < t.friend_salary
ORDER by t.friend_salary

--3. You are given a table, Functions, containing two columns: X and Y.
  -- Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
  -- Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.
select f1.X, f1.Y from Functions f1
where exists( select * from Functions f2 where (f1.X=f2.Y and f2.X=f1.Y)) and f1.X<f1.Y
union
select f1.X, f1.Y from Functions f1
where f1.X=f1.Y and (select count(*) from Functions where X=f1.X and Y=f1.X)>1
order by X;

--4. Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. 
    --Exclude the contest from the result if all four sums are .
    
 SELECT   
con.contest_id, con.hacker_id, con.name
, ISNULL(SUM(ss.total_submissions), 0), ISNULL(SUM(ss.total_accepted_submissions), 0)
, ISNULL(SUM(vs.total_views), 0), ISNULL(SUM(vs.total_unique_views), 0)
FROM 
View_Stats vs
FULL OUTER JOIN Submission_Stats ss ON ss.challenge_id IS NULL
INNER JOIN Challenges ch ON ch.challenge_id = ss.challenge_id OR ch.challenge_id = vs.challenge_id
INNER JOIN Colleges col ON col.college_id = ch.college_id
INNER JOIN Contests con ON con.contest_id = col.contest_id
GROUP BY con.contest_id, con.hacker_id, con.name
ORDER BY con.contest_id, con.hacker_id, con.name

  
