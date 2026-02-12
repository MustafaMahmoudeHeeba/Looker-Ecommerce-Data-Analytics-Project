CREATE OR ALTER PROCEDURE tables_Bronze
AS
BEGIN
    -- Distribution Centers
    DROP TABLE IF EXISTS Bronze.unClean_distribution_centers;
    SELECT * 
    INTO Bronze.unClean_distribution_centers
    FROM testData.Bronze.distribution_centers;

    -- Events
    DROP TABLE IF EXISTS Bronze.unClean_events;
    SELECT * 
    INTO Bronze.unClean_events
    FROM testData.Bronze.events;

    -- Inventory Items
    DROP TABLE IF EXISTS Bronze.unClean_inventory_items;
    SELECT * 
    INTO Bronze.unClean_inventory_items
    FROM testData.Bronze.inventory_items;

    -- Order Items
    DROP TABLE IF EXISTS Bronze.unClean_order_items;
    SELECT * 
    INTO Bronze.unClean_order_items
    FROM testData.Bronze.order_items;

    -- Orders
    DROP TABLE IF EXISTS Bronze.unClean_orders;
    SELECT * 
    INTO Bronze.unClean_orders
    FROM testData.Bronze.orders;

    -- Products
    DROP TABLE IF EXISTS Bronze.unClean_products;
    SELECT * 
    INTO Bronze.unClean_products
    FROM testData.Bronze.products;

    -- Users
    DROP TABLE IF EXISTS Bronze.unClean_users;
    SELECT * 
    INTO Bronze.unClean_users
    FROM testData.Bronze.users;
END;
GO


EXEC tables_Bronze