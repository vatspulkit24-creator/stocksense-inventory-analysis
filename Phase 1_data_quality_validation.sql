use stocksense;
-- date - 26/10/2026
-- Phase 1 — Data Quality & Business Overview

-- 1. How many records are present in each database table?

select "categories", count(*) from categories as total_records
union all 
select "inventory_snapshots",count(*) from inventory_snapshots
union all 
select "locations" , count(*) from locations
union all 
select "product_location_policy",count(*) from product_location_policy
union all 
select "product_restock_events" , count(*) from product_restock_events
union all 
select "products", count(*) from products
union all
select "purchase_order_items",count(*) from purchase_order_items
union all 
select "purchase_orders" , count(*) from purchase_orders
union all 
select "sales_transaction_items" , count(*) from sales_transaction_items
union all
select "sales_transactions" , count(*) from sales_transactions
union all 
select "suppliers",count(*) from suppliers;

--  2 Are there any duplicate IDs or duplicate business records in the dataset?
select 'categories' as table_name, category_id as duplicate_id, count(*) as total
from categories
group by category_id
having count(*) > 1

union all

select 'inventory_snapshots', snapshot_id, count(*)
from inventory_snapshots
group by snapshot_id
having count(*) > 1

union all

select 'locations', location_id, count(*)
from locations
group by location_id
having count(*) > 1

union all

select 'product_location_policies', product_id, count(*)
from product_location_policy
group by product_id
having count(*) > 1

union all

select 'product_restock_events', po_item_id, count(*)
from product_restock_events
group by po_item_id
having count(*) > 1

union all

select 'products', product_id, count(*)
from products
group by product_id
having count(*) > 1

union all

select 'purchase_order_items', po_item_id, count(*)
from purchase_order_items
group by po_item_id
having count(*) > 1

union all

select 'purchase_orders', purchase_order_id, count(*)
from purchase_orders
group by purchase_order_id
having count(*) > 1

union all

select 'sales_transaction_items', sale_item_id, count(*)
from sales_transaction_items
group by sale_item_id
having count(*) > 1

union all

select 'sales_transactions', transaction_id, count(*)
from sales_transactions
group by transaction_id
having count(*) > 1

union all

select 'suppliers', supplier_id, count(*)
from suppliers
group by supplier_id
having count(*) > 1;

-- 3 How many NULL values exist in important business columns?
select 'products' as table_name,
sum(product_id is null) as null_col1
from products

union all

select 'inventory_snapshots',
sum(snapshot_date is null)
from inventory_snapshots

union all

select 'locations',
sum(location_name is null)
from locations

union all

select 'categories',
sum(category_name is null)
from categories

union all

select 'suppliers',
sum(supplier_name is null)
from suppliers

union all

select 'purchase_orders',
sum(order_date is null)
from purchase_orders

union all

select 'purchase_order_items',
sum(purchase_order_id is null)
from purchase_order_items

union all

select 'sales_transactions',
sum(location_id is null)
from sales_transactions

union all

select 'sales_transaction_items',
       sum(transaction_id is null)
from sales_transaction_items

union all

select 'product_location_policy',
       sum(location_id is null)
from product_location_policy

union all

select 'product_restock_events',
sum(po_item_id is null)
from product_restock_events;

-- 4 What is the distribution of products, categories, suppliers, and warehouses?
select 'products',count(*) as total
from products

union all

select 'categories', count(*)
from categories

union all

select 'suppliers', count(*)
from suppliers

union all

select "location", count(*)
from locations;

-- 5 What is the overall date range of the dataset, and how many sales transactions occur each month?
select
date_format(transaction_ts, '%Y-%m') as month,
count(*) as total_transactions
from sales_transactions
group by date_format(transaction_ts, '%Y-%m')
order by month;

-- 6 What are the counts and percentages of completed, cancelled, and returned transactions?
select transaction_status,
count(*) as total_transactions
from sales_transactions
where transaction_status in ('COMPLETED', 'CANCELLED', 'RETURNED')
group by transaction_status
order by transaction_status;

-- 7 Are the relationships between sales items, purchase orders, inventory snapshots, and their related tables valid?
select count(*) as valid_sales_items
from sales_transaction_items si
inner join sales_transactions st
on si.transaction_id = st.transaction_id
where st.transaction_id is null;

select count(*) as valid_purchase_items
from purchase_order_items poi
inner join purchase_orders po
on poi.purchase_order_id = po.purchase_order_id
where po.purchase_order_id is null;

select count(*) as valid_inventory_products
from inventory_snapshots i
inner join products p
on i.product_id = p.product_id
where p.product_id is null;


