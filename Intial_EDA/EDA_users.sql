
SELECT  
	TOP 50 *
FROM Bronze.unClean_users



EXEC sp_help 'Bronze.unClean_users';


-- CTE to identify duplicate users based on (email + full name)
WITH DuplicateUsers AS (
    SELECT 
        CONCAT(first_name, ' ', last_name) AS FullName, 
        email AS UserEmail,                              
        ROW_NUMBER() OVER (
            PARTITION BY email, CONCAT(first_name, ' ', last_name) 
            ORDER BY CONCAT(first_name, ' ', last_name)
        ) AS DuplicateRank                              
    FROM Bronze.unClean_users
)
SELECT *  
FROM Bronze.unClean_users
WHERE CONCAT(first_name, ' ', last_name) IN (
    SELECT FullName
    FROM DuplicateUsers
    WHERE DuplicateRank > 1
)
ORDER BY email;






-- Total number of unique users
SELECT COUNT(DISTINCT id) AS total_users
FROM Bronze.unClean_users;


-- Age statistics (maximum, minimum, average)
SELECT 
    MAX(age) AS max_age, 
    MIN(age) AS min_age, 
    AVG(age) AS avg_age
FROM Bronze.unClean_users;


-- User count by gender
SELECT 
    gender, 
    COUNT(gender) AS total_by_gender
FROM Bronze.unClean_users
GROUP BY gender;


-- Total number of unique countries
SELECT COUNT(DISTINCT country) AS total_countries
FROM Bronze.unClean_users;


-- Total number of unique cities
SELECT COUNT(DISTINCT city) AS total_cities
FROM Bronze.unClean_users;


-- Total number of unique states
SELECT COUNT(DISTINCT state) AS total_states
FROM Bronze.unClean_users;


-- List of unique traffic sources
SELECT DISTINCT traffic_source
FROM Bronze.unClean_users;
