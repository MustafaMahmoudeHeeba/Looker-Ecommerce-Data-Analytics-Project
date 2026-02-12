SELECT TOP 50 *
FROM Bronze.unClean_inventory_items

EXEC sp_help 'Bronze.unClean_inventory_items'

-- Count NULL values in each column to check data quality
SELECT	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END )AS TotalNulls_id ,
		SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_id,
		SUM(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END )AS TotalNulls_created_at,
		SUM(CASE WHEN cost IS NULL THEN 1 ELSE 0 END )AS TotalNulls_cost,
		SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_category,
		SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_name,
		SUM(CASE WHEN product_brand IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_brand,
		SUM(CASE WHEN product_retail_price IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_retail_price,
		SUM(CASE WHEN product_department IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_department,
		SUM(CASE WHEN product_sku IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_sku,
		SUM(CASE WHEN product_distribution_center_id IS NULL THEN 1 ELSE 0 END )AS TotalNulls_product_distribution_center_id
From Bronze.unClean_inventory_items

-- Count the total number of inventory items
SELECT COUNT(*) AS TotalInventoryItems
FROM Bronze.unClean_inventory_items;


-- Show the top 10 most frequent product SKUs
SELECT TOP 10 COUNT(product_sku) AS NumberOfItems, product_sku
FROM Bronze.unClean_inventory_items
GROUP BY product_sku
ORDER BY COUNT(product_sku) DESC;


-- Count the total number of unique products (by product_id, SKU, and cost)
WITH VirtualWithoutDuplication AS (
    SELECT product_id, product_sku, cost
    FROM Bronze.unClean_inventory_items
    GROUP BY product_id, product_sku, cost
)
SELECT COUNT(*) AS TotalUniqueProducts
FROM VirtualWithoutDuplication;


-- Count the total number of unique product categories
SELECT COUNT(DISTINCT product_category) AS TotalUniqueCategories
FROM Bronze.unClean_inventory_items;


-- Count the total number of unique product brands
SELECT COUNT(DISTINCT product_brand) AS TotalUniqueBrands
FROM Bronze.unClean_inventory_items;


-- Count the total number of unique distribution centers
SELECT COUNT(DISTINCT product_distribution_center_id) AS TotalUniqueDistributionCenters
FROM Bronze.unClean_inventory_items;
