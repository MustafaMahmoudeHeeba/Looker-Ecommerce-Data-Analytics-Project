INSERT INTO Gold.Dim_Date (
    date_key,
    full_date,
    day_num,
    month_num,
    month_name,
    quarter_num,
    year_num,
    day_of_week,
    is_weekend
)
SELECT DISTINCT
    creation_year * 10000 
        + creation_month * 100 
        + creation_day              AS date_key,
    creation_date                  AS full_date,
    creation_day                   AS day_num,
    creation_month                 AS month_num,
    DATENAME(MONTH, creation_date) AS month_name,
    DATEPART(QUARTER, creation_date) AS quarter_num,
    creation_year                  AS year_num,
    DATENAME(WEEKDAY, creation_date) AS day_of_week,
    CASE 
        WHEN DATENAME(WEEKDAY, creation_date) IN ('Friday','Saturday') 
        THEN 1 ELSE 0 
    END AS is_weekend
FROM Silver.Clean_orders
WHERE creation_date IS NOT NULL;



INSERT INTO Gold.Dim_Product (
    product_id,
    product_name,
    brand,
    category,
    department,
    cost,
    retail_price,
    net_profit
)
SELECT DISTINCT
    product_id,
    product_name,
    brand,
    category,
    department,
    cost,
    retail_price,
    net_profit
FROM Silver.Clean_products;



INSERT INTO Gold.Dim_Customer (
    user_id,
    age,
    gender,
    city,
    state,
    country,
    traffic_source,
    account_creation_date
)
SELECT DISTINCT
    user_id,
    age,
    gender,
    city,
    state,
    country,
    traffic_source,
    creation_date
FROM Silver.Clean_users;




INSERT INTO Gold.Dim_Distribution_Center (
    center_id,
    center_name,
    latitude,
    longitude
)
SELECT DISTINCT
    center_id,
    name,
    latitude,
    longitude
FROM Silver.Clean_distribution_centers;




INSERT INTO Gold.Dim_Browser (browser_name)
SELECT DISTINCT
    browser
FROM Silver.Clean_events
WHERE browser IS NOT NULL;


INSERT INTO Gold.Dim_Traffic_Source (traffic_source)
SELECT DISTINCT
    traffic_source
FROM Silver.Clean_users
WHERE traffic_source IS NOT NULL;



INSERT INTO Gold.Fact_Sales (
    product_key,
    customer_key,
    date_key,
    order_id,
    quantity,
    revenue,
    cost,
    profit,
    order_status
)
SELECT
    dp.product_key,
    dc.customer_key,
    dd.date_key,
    o.order_id,
    1 AS quantity,
    oi.retail_price,
    dp.cost,
    (oi.retail_price - dp.cost) AS profit,
    o.status
FROM Silver.Clean_order_items oi
JOIN Silver.Clean_orders o
    ON oi.order_id = o.order_id
JOIN Gold.Dim_Product dp
    ON oi.product_id = dp.product_id
JOIN Gold.Dim_Customer dc
    ON o.user_id = dc.user_id
JOIN Gold.Dim_Date dd
    ON o.creation_date = dd.full_date;






INSERT INTO Gold.Fact_Returns (
    product_key,
    customer_key,
    return_date_key,
    order_id,
    returned_quantity,
    returned_revenue,
    returned_profit
)
SELECT
    dp.product_key,
    dc.customer_key,
    dd.date_key,
    o.order_id,
    1,
    oi.retail_price,
    (oi.retail_price - dp.cost)
FROM Silver.clean_returned_orders r
JOIN Silver.Clean_orders o
    ON r.order_id = o.order_id
JOIN Silver.Clean_order_items oi
    ON o.order_id = oi.order_id
JOIN Gold.Dim_Product dp
    ON oi.product_id = dp.product_id
JOIN Gold.Dim_Customer dc
    ON o.user_id = dc.user_id
JOIN Gold.Dim_Date dd
    ON r.return_date = dd.full_date;





INSERT INTO Gold.Fact_Inventory (
    product_key,
    center_key,
    date_key,
    stock_quantity
)
SELECT
    dp.product_key,
    dc.center_key,
    dd.date_key,
    1
FROM Silver.Clean_inventory_items i
JOIN Gold.Dim_Product dp
    ON i.product_id = dp.product_id
JOIN Gold.Dim_Distribution_Center dc
    ON i.center_id = dc.center_id
JOIN Gold.Dim_Date dd
    ON i.creation_date = dd.full_date;




INSERT INTO Gold.Fact_Customer_Journey (
    customer_key,
    date_key,
    browser_key,
    traffic_source_key,
    event_type,
    session_id,
    sequence_number,
    event_count
)
SELECT
    dc.customer_key,
    dd.date_key,
    db.browser_key,
    ts.traffic_source_key,
    e.event_type,
    e.session_id,
    e.sequence_number,
    1
FROM Silver.Clean_events e
JOIN Gold.Dim_Customer dc
    ON e.user_id = dc.user_id
JOIN Gold.Dim_Browser db
    ON e.browser = db.browser_name
JOIN Gold.Dim_Traffic_Source ts
    ON dc.traffic_source = ts.traffic_source
JOIN Gold.Dim_Date dd
    ON dc.account_creation_date = dd.full_date;



