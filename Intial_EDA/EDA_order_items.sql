-- Preview top 50 order items sorted by order_id
select top 50 * 
from Bronze.unClean_order_items
order by order_id;


-- Count distinct orders and total number of items
select count(distinct order_id) as NumberOfOrders, 
       count(*) as NumberOfItems
from Bronze.unClean_order_items;


-- Top 10 orders with the highest number of items
select top 10 order_id, 
       count(*) as NumberOfItems
from Bronze.unClean_order_items
group by order_id
order by NumberOfItems desc;
