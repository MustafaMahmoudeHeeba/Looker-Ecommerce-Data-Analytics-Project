
SELECT TOP 50 *
FROM Bronze.unClean_products;


-- Show metadata information about the table (columns, datatypes, etc.)
EXEC sp_help 'Bronze.unClean_products';


-- Count how many NULL values exist in 'name' and 'brand' columns
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS TotalNulls_Name,   
    SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS TotalNulls_Brand  
FROM Bronze.unClean_products;


-- Retrieve all rows where 'name' or 'brand' is missing (NULL)
SELECT * 
FROM Bronze.unClean_products
WHERE name IS NULL OR brand IS NULL;


-- Count the total number of products
SELECT COUNT(DISTINCT id) AS TotalProducts
FROM Bronze.products;



-- Show the top 10 duplicate product names
SELECT TOP 10 *
FROM Bronze.unClean_products
WHERE name IN (
    SELECT name
    FROM Bronze.unClean_products
    GROUP BY name
    HAVING COUNT(id) > 1
)
ORDER BY name;


-- Count the number of products grouped by department
SELECT COUNT(id) AS TotalProductsByDepartment, department
FROM Bronze.unClean_products
GROUP BY department;


-- Count the total number of unique brands
SELECT COUNT(DISTINCT brand) AS TotalBrands
FROM Bronze.unClean_products;
