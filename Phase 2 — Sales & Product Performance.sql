-- Phase 2 — Sales & Product Performance
-- 27/10/2026
-- 1 Which 10 products generate the highest net sales revenue?

select product_name,product_id,
SUM(unit_cost * unit_price * (1 - units_per_case / 100)) AS net_revenue
from products
group by product_name,product_id
order by net_revenue desc
limit 10 ;

-- 2 Which product categories generate the highest total revenue?
select product_name,product_id,
SUM(unit_cost * unit_price * (1 - units_per_case / 100)) AS net_revenue
from products
group by product_name,product_id
order by net_revenue desc
limit 1;

-- 3 Which products sell the highest number of units?
select product_name,
sum(unit_cost) as highest_unit
from products 
group by product_name
order by highest_unit desc 
limit 1;

-- 11 What are the average selling price and gross margin percentage for each product category?
select category_id, 
avg(unit_price) as avg_selling_price,
avg((unit_price - unit_cost) / unit_price) * 100 as gross_margin_pct
from products 
group by category_id;

-- 12 What is the difference between list-price revenue and actual discounted revenue?
select 
sum(unit_price*unit_cost) as list_price_revenue,
sum(unit_price*unit_cost * (1- units_per_case / 100)) as actual_discounted_revenue,
sum(unit_price * unit_cost) - 
sum(unit_price * unit_cost * (1 - units_per_case / 100 )) as revenue_diffrence
from products;

-- 13 What are the monthly trends in revenue and units sold?
select year(st.transaction_ts) as year,
month(st.transaction_ts) as month,
sum(sti.quantity * p.unit_price) as revenue ,
sum(sti.quantity) as unit_sold
from sales_transactions st 
inner join sales_transaction_items sti 
on st.transaction_id = sti.transaction_id
join products p 
on sti.product_id = p.product_id
group by (st.transaction_ts), (st.transaction_ts)
order by year,month;

-- 14 Which products show a month-over-month decline in sales?
select
p.product_name,
month(st.transaction_ts) as month,
sum(sti.quantity) as units_sold,
lag(sum(sti.quantity)) over (
partition by p.product_id
order by month(st.transaction_ts)
) as previous_sales
from products p
join sales_transaction_items sti
on p.product_id = sti.product_id
join sales_transactions st
on st.transaction_id = sti.transaction_id
group by p.product_id, p.product_name, month(st.transaction_ts)
order by month; 

-- 15 Which locations and sales channels contribute the most to total revenue?
select
l.location_name,
st.sales_channel,
sum(sti.quantity * p.unit_price) as total_revenue
from sales_transactions st
join sales_transaction_items sti
on st.transaction_id = sti.transaction_id
join products p
on sti.product_id = p.product_id
join locations l
on st.location_id = l.location_id
group by l.location_name, st.sales_channel
order by total_revenue desc;




