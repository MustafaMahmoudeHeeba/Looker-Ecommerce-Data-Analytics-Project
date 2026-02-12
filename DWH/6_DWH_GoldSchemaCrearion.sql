create or alter procedure Goald_tables 
as
Begin

CREATE TABLE Gold.Dim_Date (
    date_key        INT PRIMARY KEY,      -- YYYYMMDD
    full_date       DATE,
    day_num         INT,
    month_num       INT,
    month_name      VARCHAR(20),
    quarter_num     INT,
    year_num        INT,
    day_of_week     VARCHAR(15),
    is_weekend      BIT
);



CREATE TABLE Gold.Dim_Product (
    product_key     INT IDENTITY PRIMARY KEY,
    product_id      INT,                  -- Business Key
    product_name    VARCHAR(255),
    brand           VARCHAR(100),
    category        VARCHAR(100),
    department      VARCHAR(100),
    cost            DECIMAL(10,2),
    retail_price    DECIMAL(10,2),
    net_profit      DECIMAL(10,2)
);



CREATE TABLE Gold.Dim_Customer (
    customer_key        INT IDENTITY PRIMARY KEY,
    user_id             INT,              -- Business Key
    age                 INT,
    gender              VARCHAR(20),
    city                VARCHAR(100),
    state               VARCHAR(100),
    country             VARCHAR(100),
    traffic_source      VARCHAR(100),
    account_creation_date DATE
);


CREATE TABLE Gold.Dim_Distribution_Center (
    center_key      INT IDENTITY PRIMARY KEY,
    center_id       INT,                  -- Business Key
    center_name     VARCHAR(255),
    latitude        DECIMAL(9,6),
    longitude       DECIMAL(9,6)
);




CREATE TABLE Gold.Dim_Browser (
    browser_key     INT IDENTITY PRIMARY KEY,
    browser_name    VARCHAR(100)
);


CREATE TABLE Gold.Dim_Traffic_Source (
    traffic_source_key INT IDENTITY PRIMARY KEY,
    traffic_source     VARCHAR(100)
);


CREATE TABLE Gold.Fact_Sales (
    sales_key      BIGINT IDENTITY PRIMARY KEY,

    -- Foreign Keys
    product_key    INT,
    customer_key   INT,
    date_key       INT,

    -- Degenerate Dimension
    order_id       INT,

    -- Measures
    quantity       INT DEFAULT 1,
    revenue        DECIMAL(10,2),
    cost           DECIMAL(10,2),
    profit         DECIMAL(10,2),

    -- Supporting Attributes
    order_status   VARCHAR(50),

    CONSTRAINT fk_sales_product  FOREIGN KEY (product_key)  REFERENCES Gold.Dim_Product(product_key),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_key) REFERENCES Gold.Dim_Customer(customer_key),
    CONSTRAINT fk_sales_date     FOREIGN KEY (date_key)     REFERENCES Gold.Dim_Date(date_key)
);




CREATE TABLE Gold.Fact_Returns (
    return_key     BIGINT IDENTITY PRIMARY KEY,

    -- Foreign Keys
    product_key    INT,
    customer_key   INT,
    return_date_key INT,

    -- Degenerate Dimension
    order_id       INT,

    -- Measures
    returned_quantity INT DEFAULT 1,
    returned_revenue  DECIMAL(10,2),
    returned_profit   DECIMAL(10,2),

    CONSTRAINT fk_returns_product  FOREIGN KEY (product_key) REFERENCES Gold.Dim_Product(product_key),
    CONSTRAINT fk_returns_customer FOREIGN KEY (customer_key) REFERENCES Gold.Dim_Customer(customer_key),
    CONSTRAINT fk_returns_date     FOREIGN KEY (return_date_key) REFERENCES Gold.Dim_Date(date_key)
);



CREATE TABLE Gold.Fact_Customer_Journey (
    journey_key        BIGINT IDENTITY PRIMARY KEY,

    -- Foreign Keys
    customer_key       INT,
    date_key           INT,
    browser_key        INT,
    traffic_source_key INT,

    -- Event Attributes
    event_type         VARCHAR(100),
    session_id         VARCHAR(255),
    sequence_number    INT,

    -- Measure
    event_count        INT DEFAULT 1,

    CONSTRAINT fk_journey_customer FOREIGN KEY (customer_key) REFERENCES Gold.Dim_Customer(customer_key),
    CONSTRAINT fk_journey_date     FOREIGN KEY (date_key)     REFERENCES Gold.Dim_Date(date_key),
    CONSTRAINT fk_journey_browser  FOREIGN KEY (browser_key)  REFERENCES Gold.Dim_Browser(browser_key),
    CONSTRAINT fk_journey_traffic  FOREIGN KEY (traffic_source_key) REFERENCES Gold.Dim_Traffic_Source(traffic_source_key)
);




End;


exec Goald_tables

