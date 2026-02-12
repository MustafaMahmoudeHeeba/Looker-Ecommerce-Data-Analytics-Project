CREATE OR ALTER PROCEDURE tables_creation 
AS
BEGIN

    -- Clean Distribution Centers
    IF OBJECT_ID(N'Silver.Clean_distribution_centers', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_distribution_centers;

    CREATE TABLE Silver.Clean_distribution_centers 
    (
        center_id INT,
        [name] NVARCHAR(50),
        latitude DECIMAL(10,7),
        longitude DECIMAL(10,7)
    );

    -- Clean Events
    IF OBJECT_ID(N'Silver.Clean_events', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_events;

    CREATE TABLE Silver.Clean_events
    (
        event_id INT, 
        [user_id] INT,
        sequence_number TINYINT,
        [session_id] NVARCHAR(100),
        ip_address NVARCHAR(20), 
        browser NVARCHAR(50),
        uri NVARCHAR(100),
        event_type NVARCHAR(50) 
    );

    -- Clean Inventory Items
    IF OBJECT_ID(N'Silver.Clean_inventory_items', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_inventory_items;

    CREATE TABLE Silver.Clean_inventory_items
    (
        inventory_item_id INT,
        product_id INT, 
        creation_time NVARCHAR(50),
        sale_time NVARCHAR(50),
      center_id INT
    );

    -- Clean Order Items
    IF OBJECT_ID(N'Silver.Clean_order_items', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_order_items;

    CREATE TABLE Silver.Clean_order_items
    (
        order_id INT,
        [user_id] INT,
        product_id INT,
        inventory_item_id INT,
        retail_price DECIMAL(10,2) 
    );

    -- Clean Orders
    IF OBJECT_ID(N'Silver.Clean_orders', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_orders;

    CREATE TABLE Silver.Clean_orders
    (
        order_id INT,
        [user_id] INT, 
        status NVARCHAR(50),
        creation_time NVARCHAR(50),
        return_time NVARCHAR(50),
        arrival_time NVARCHAR(50),
        total_items INT 
    );

    -- Clean Products
    IF OBJECT_ID(N'Silver.Clean_products', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_products;

    CREATE TABLE Silver.Clean_products
    (
        product_id INT,
        cost DECIMAL(10,2),
        category NVARCHAR(50),
        product_name NVARCHAR(500), 
        brand NVARCHAR(50),
        retail_price DECIMAL(10,2),
        department NVARCHAR(50),
        SKU NVARCHAR(100),
    );

    -- Clean Users
    IF OBJECT_ID(N'Silver.Clean_users', N'U') IS NOT NULL
        DROP TABLE Silver.Clean_users;

    CREATE TABLE Silver.Clean_users
    (
        [user_id] INT,
        f_name NVARCHAR(50),
        l_name NVARCHAR(50),
        email NVARCHAR(50),
        age INT, 
        gender NVARCHAR(50),
        [state] NVARCHAR(50),
        street_address NVARCHAR(50),
        postal_code NVARCHAR(50),
		city VARCHAR(50),
        country NVARCHAR(50),
        latitude DECIMAL(10,7),
        longitude DECIMAL(10,7), 
        traffic_source NVARCHAR(50),
        creation_time NVARCHAR(50) 
    );

END;


EXEC tables_creation