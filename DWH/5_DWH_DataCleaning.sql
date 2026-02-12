/* =========================================================
   Clean Inventory Items
   ========================================================= */

-- View the first 10 records from the Clean Inventory Items table
SELECT TOP 10 * 
FROM Silver.Clean_inventory_items;

-- Add date-related columns derived from creation_time and sale_time
ALTER TABLE Silver.Clean_inventory_items
ADD 
    creation_date DATE,
    creation_day INT,
    creation_month INT,
    creation_year INT,
    sale_date DATE,
    sale_day INT,
    sale_month INT,
    sale_year INT;

-- Populate the newly added date columns
UPDATE Silver.Clean_inventory_items
SET 
    creation_date = SUBSTRING(creation_time, 1, 10),
    sale_date     = SUBSTRING(sale_time, 1, 10),
    creation_day   = DAY(creation_date),
    creation_month = MONTH(creation_date),
    creation_year  = YEAR(creation_date),
    sale_day       = DAY(sale_date),
    sale_month     = MONTH(sale_date),
    sale_year      = YEAR(sale_date);

-- Drop original creation timestamp column
ALTER TABLE Silver.Clean_inventory_items
DROP COLUMN creation_time;



/* =========================================================
   Clean Events
   ========================================================= */

-- View first 500 rows from Clean Events table
SELECT TOP 500 *
FROM Silver.Clean_events;

-- Remove events with missing user_id
DELETE 
FROM Silver.Clean_events
WHERE user_id IS NULL;

-- Remove duplicate events based on sequence_number and ip_address
WITH forDuplicatio AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY sequence_number, ip_address
               ORDER BY ip_address
           ) AS rowNum
    FROM Silver.Clean_events
)
DELETE 
FROM forDuplicatio
WHERE rowNum > 1;

-- Enforce NOT NULL constraint on user_id
ALTER TABLE Silver.Clean_events
ALTER COLUMN user_id INT NOT NULL;



/* =========================================================
   Clean Products
   ========================================================= */

-- View all records from Clean Products table
SELECT TOP 500 * 
FROM Silver.Clean_products;

-- Delete products that do not exist in inventory items
DELETE 
FROM Silver.Clean_products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM Silver.Clean_inventory_items
);

-- Add net profit column
ALTER TABLE Silver.Clean_products
ADD net_profit DECIMAL(5, 2);

-- Calculate net profit
UPDATE Silver.Clean_products
SET net_profit = retail_price - cost;



/* =========================================================
   Clean Orders
   ========================================================= */

-- Remove orders that are not completed or returned
DELETE 
FROM Silver.Clean_orders
WHERE status IN ('Processing', 'Cancelled', 'Shipped');

-- View cleaned orders table
SELECT * 
FROM Silver.Clean_orders;

-- Add date parts for creation, return, and arrival timestamps
ALTER TABLE Silver.Clean_orders
ADD 
    creation_date DATE,
    creation_day INT,
    creation_month INT,
    creation_year INT,
    return_date DATE,
    return_day INT,
    return_month INT,
    return_year INT,
    arrival_date DATE,
    arrival_day INT,
    arrival_month INT,
    arrival_year INT;

-- Populate date columns
UPDATE Silver.Clean_orders
SET 
    creation_date  = SUBSTRING(creation_time, 1, 10),
    creation_day   = DAY(creation_date),
    creation_month = MONTH(creation_date),
    creation_year  = YEAR(creation_date),

    return_date    = SUBSTRING(return_time, 1, 10),
    return_day     = DAY(return_date),
    return_month   = MONTH(return_date),
    return_year    = YEAR(return_date),

    arrival_date   = SUBSTRING(arrival_time, 1, 10),
    arrival_day    = DAY(arrival_date),
    arrival_month  = MONTH(arrival_date),
    arrival_year   = YEAR(arrival_date);

-- Add hour columns
ALTER TABLE Silver.Clean_orders
ADD 
    creation_hour INT,
    return_hour INT,
    arrival_hour INT;

-- Extract hour from timestamp strings
UPDATE Silver.Clean_orders
SET 
    creation_hour = SUBSTRING(creation_time, 12, 2), 
    return_hour   = SUBSTRING(return_time, 12, 2),
    arrival_hour  = SUBSTRING(arrival_time, 12, 2);

-- Drop original timestamp columns
ALTER TABLE Silver.Clean_orders
DROP COLUMN creation_time, return_time, arrival_time;



/* =========================================================
   Clean Users
   ========================================================= */

-- View first 500 records from Clean Users
SELECT TOP 500 *
FROM Silver.Clean_users;

-- Normalize gender values
UPDATE Silver.Clean_users 
SET gender = CASE 
    WHEN gender = 'F' THEN 'Female'
    WHEN gender = 'M' THEN 'Male'
END;

-- Add date parts for user creation time
ALTER TABLE Silver.Clean_users
ADD 
    creation_date DATE,
    creation_day INT,
    creation_month INT,
    creation_year INT;

-- Populate date fields
UPDATE Silver.Clean_users
SET 
    creation_date  = SUBSTRING(creation_time, 1, 10),
    creation_day   = DAY(creation_date),
    creation_month = MONTH(creation_date),
    creation_year  = YEAR(creation_date);

-- Add and populate hour column
ALTER TABLE Silver.Clean_users
ADD creation_hour INT;

UPDATE Silver.Clean_users
SET creation_hour = SUBSTRING(creation_time, 12, 2);

-- Drop original timestamp column
ALTER TABLE Silver.Clean_users
DROP COLUMN creation_time;

-- Remove duplicate users based on full name and email
WITH dropDuplication AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY f_name, l_name, email
               ORDER BY email
           ) AS RowNum
    FROM Silver.Clean_users
)
DELETE
FROM dropDuplication
WHERE RowNum > 1;



/* =========================================================
   Returned Orders (Separated Table)
   ========================================================= */

-- Create a separate table for returned orders only
SELECT 
    order_id,
    return_date,
    return_day,
    return_month,
    return_year,
    return_hour
INTO Silver.clean_returned_orders
FROM Silver.clean_orders 
WHERE return_date IS NOT NULL;

-- Remove return-related columns from main orders table
ALTER TABLE Silver.clean_orders 
DROP COLUMN 
    return_date,
    return_day,
    return_month,
    return_year,
    return_hour;



/* =========================================================
   Sold Inventory Items (Separated Table)
   ========================================================= */

-- View inventory items after cleaning
SELECT * 
FROM Silver.clean_inventory_items;

-- Create a table that contains only sold inventory items
SELECT 
    product_id,
    sale_time,
    sale_date,
    sale_day,
    sale_month,
    sale_year
INTO Silver.clean_saled_inventory_items
FROM Silver.clean_inventory_items
WHERE sale_time IS NOT NULL;

-- Remove sale-related columns from inventory items table
ALTER TABLE Silver.clean_inventory_items
DROP COLUMN  
    sale_time,
    sale_date,
    sale_day,
    sale_month,
    sale_year;
