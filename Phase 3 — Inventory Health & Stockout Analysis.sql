-- Phase 3 — Inventory Health & Stockout Analysis
-- 27/10/2026
-- 16 What is the latest available inventory quantity for each product at each location
select
p.product_name,
l.location_name,
i.closing_on_hand,
i.snapshot_date
from (
select *,
row_number() over (
partition by product_id, location_id
order by snapshot_date desc
) as rn
from inventory_snapshots
) i
join products p
on i.product_id = p.product_id
join locations l
on i.location_id = l.location_id
where rn = 1
order by p.product_name, l.location_name;

-- 17 Which products have stock levels below their reorder points?
select p.product_name, l.location_name,
i.closing_on_hand, pol.reorder_point
from inventory_snapshots i
join products p on i.product_id = p.product_id
join locations l on i.location_id = l.location_id
join product_location_policy pol
on i.product_id = pol.product_id
and i.location_id = pol.location_id
where i.snapshot_date = (
select max(i2.snapshot_date)
from inventory_snapshots i2
where i2.product_id = i.product_id
and i2.location_id = i.location_id)
and i.closing_on_hand < pol.reorder_point;

-- 18 which product-location combinations currently have zero stock?
select p.product_name, l.location_name,
i.closing_on_hand
from inventory_snapshots i
join products p on i.product_id = p.product_id
join locations l on i.location_id = l.location_id
where i.snapshot_date = (
select max(i2.snapshot_date)
from inventory_snapshots i2
where i2.product_id = i.product_id
and i2.location_id = i.location_id )
and i.closing_on_hand = 0;

-- 19 which products and locations experience the highest number of stockout days?
select p.product_name, l.location_name,
sum(i.stockout_days) as stockout_days
from inventory_snapshots i
join products p on i.product_id = p.product_id
join locations l on i.location_id = l.location_id
group by p.product_id, p.product_name,
l.location_id, l.location_name
order by stockout_days desc;

-- 20 Which products have high inventory investment but low sales velocity?
select p.product_name,
sum(i.closing_on_hand * p.unit_cost) as inventory_value,
coalesce(s.units_sold, 0) as units_sold
from inventory_snapshots i
join products p on i.product_id = p.product_id
left join (
select si.product_id, sum(si.quantity) as units_sold
from sales_transaction_items si
join sales_transactions st on si.transaction_id = st.transaction_id
where st.transaction_status = 'COMPLETED'
group by si.product_id
) s on p.product_id = s.product_id
group by p.product_id, p.product_name, s.units_sold
order by inventory_value desc, units_sold asc;

-- 21 Which products qualify as slow-moving inventory based on a documented business rule?
select p.product_id, p.product_name
from products p
where not exists (
select 1
from sales_transaction_items si
join sales_transactions st
on si.transaction_id = st.transaction_id
where si.product_id = p.product_id
and st.transaction_status = 'COMPLETED'
and st.transaction_ts > (
select max(transaction_ts)
from sales_transactions
) - interval 90 day
);

-- 22 What are the inventory value and storage capacity utilization for each location?
select l.location_name,
sum(i.closing_on_hand * p.unit_cost) as inventory_value,
sum(i.closing_on_hand) as stock_units,
sum(i.closing_on_hand) * 100.0 /
l.storage_capacity_units as capacity_utilization_pct
from inventory_snapshots i
join products p on i.product_id = p.product_id
join locations l on i.location_id = l.location_id
where i.snapshot_date = (
select max(i2.snapshot_date)
from inventory_snapshots i2
where i2.product_id = i.product_id
and i2.location_id = i.location_id
)
group by l.location_id, l.location_name, l.storage_capacity_units;

-- 23 how many units of inventory have been recorded as shrinkage, damage, or adjustment losses?
select l.location_name,
       sum(-i.adjustment_units) as loss_units
from inventory_snapshots i
join locations l on i.location_id = l.location_id
group by l.location_id, l.location_name
order by loss_units desc;

-- 24 Which products have the highest demand variability?

-- 25 How accurate are the planner's daily-demand assumptions compared with actual observed demand?





