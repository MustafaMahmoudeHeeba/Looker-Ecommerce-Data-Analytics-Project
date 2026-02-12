CREATE OR ALTER PROCEDURE Load_data
AS
BEGIN
    -- Load Distribution Centers
    INSERT INTO Silver.Clean_distribution_centers 
    (
        center_id,
        [name],
        latitude,
        longitude 
    )
    SELECT 
        cast(cast (id as float )as int ) , 
        name, 
        latitude, 
        longitude
    FROM Bronze.unClean_distribution_centers;


    -- Load Events
    INSERT INTO Silver.Clean_events
    (
        event_id, 
        [user_id],
        sequence_number,
        [session_id],
        ip_address, 
        browser,
        uri,
        event_type
    )
    SELECT 
         cast(cast (id as float )as int ) , 
        cast(cast (user_id as float )as int ) , 
        sequence_number,
        session_id,
        ip_address,
       browser,
        uri,
        event_type
    FROM Bronze.unClean_events;


    -- Load Inventory Items
    INSERT INTO Silver.Clean_inventory_items
    (
        inventory_item_id,
        product_id, 
        creation_time,
        sale_time,
     center_id 
    )
    SELECT 
         cast(cast (id as float )as int ) , 
        cast(cast (product_id as float )as int ) , 
        created_at, 
        sold_at, 
        product_distribution_center_id
    FROM Bronze.unClean_inventory_items;


    -- Load Order Items
    INSERT INTO Silver.Clean_order_items
    (
        order_id,
        [user_id],
        product_id,
        inventory_item_id,
        retail_price  
    )
    SELECT 
        cast(cast( order_id as float) as int),  
		cast(cast( user_id as float) as int),  
        product_id,
        inventory_item_id,
        sale_price
    FROM Bronze.unClean_order_items;


    -- Load Orders
    INSERT INTO Silver.Clean_orders
    (
        order_id,
        [user_id], 
        status,
        creation_time,
        return_time,
        arrival_time,
        total_items  
    )
    SELECT 
        cast(cast( order_id as float) as int), 
		cast(cast( user_id as float) as int),  
        status, 
        created_at, 
        returned_at,
        delivered_at, 
        num_of_item
    FROM Bronze.unClean_orders;


    -- Load Products
    INSERT INTO Silver.Clean_products
    (
        product_id,
        cost,
        category,
        product_name, 
        brand,
        retail_price,
        department,
        SKU
    )
    SELECT 
         cast(cast (id as float )as int ) , 
        cost, 
        category, 
        name,
        brand,
        retail_price,
        department,
        sku
    FROM Bronze.unClean_products;


    -- Load Users
    INSERT INTO Silver.Clean_users
    (
        [user_id],
        f_name,
        l_name,
        email,
        age, 
        gender,
        [state],
        street_address,
        postal_code,
        city,
        country,
        latitude,
        longitude, 
        traffic_source,
        creation_time  
    )
    SELECT 
        cast(cast (id as float )as int ) , 
        first_name, 
        last_name,
        email, 
        age, 
        gender,
        state, 
        street_address,
        postal_code, 
        city, 
        country,
        latitude,
        longitude,
        traffic_source,
        created_at
    FROM Bronze.unClean_users;
END;


EXEC Load_data

