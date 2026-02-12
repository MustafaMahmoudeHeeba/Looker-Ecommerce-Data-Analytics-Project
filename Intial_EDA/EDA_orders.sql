Select top 50 *
from Bronze.unClean_orders

EXEC sp_help 'Bronze.unClean_orders';

-- Count total number of orders
select count(*) as NumberOfOrders
from Bronze.unClean_orders;


-- List all distinct order statuses
select distinct status 
from Bronze.unClean_orders;

