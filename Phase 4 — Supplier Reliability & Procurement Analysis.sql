-- Phase 4 — Supplier Reliability & Procurement Analysis
-- 28/10/2026
-- 26 Which suppliers receive the highest number of purchase orders?
select s.supplier_name,
count(po.purchase_order_id) as total_orders
from suppliers s
join purchase_orders po
on s.supplier_id = po.supplier_id
group by s.supplier_id, s.supplier_name
order by total_orders desc;

-- 27 What is the average actual delivery lead time for each supplier?
select s.supplier_name,
avg(datediff(r.received_date, po.order_date)) as avg_lead_time_days
from suppliers s
join purchase_orders po on s.supplier_id = po.supplier_id
join purchase_order_items poi on po.purchase_order_id = poi.purchase_order_id
join product_restock_events r on poi.po_item_id = r.po_item_id
where r.received_date is not null
group by s.supplier_id, s.supplier_name
order by avg_lead_time_days;

-- 28 What percentage of eligible purchase orders are received on or before their expected delivery dates?
select distinct
100.0 * sum(case
when r.received_date <= po.expected_delivery_date then 1
else 0
end) over ()
/ count(*) over () as on_time_percentage
from purchase_orders po
join purchase_order_items poi on po.purchase_order_id = poi.purchase_order_id
join product_restock_events r on poi.po_item_id = r.po_item_id
where po.expected_delivery_date is not null
and r.received_date is not null;

-- 29 Which suppliers have the highest frequency of late deliveries?
select s.supplier_name, count(distinct po.purchase_order_id) as late_orders
from suppliers s
inner join purchase_orders po on s.supplier_id = po.supplier_id
inner join purchase_order_items poi on po.purchase_order_id = poi.purchase_order_id
inner join product_restock_events r on poi.po_item_id = r.po_item_id
where r.received_date > po.expected_delivery_date
group by s.supplier_id, s.supplier_name
order by late_orders desc;

-- 30 Which purchase-order items are partially delivered or short-closed?
select poi.po_item_id, poi.product_id,
poi.ordered_qty, sum(r.received_qty) as received_qty
from purchase_order_items poi
left join product_restock_events r on poi.po_item_id = r.po_item_id
group by poi.po_item_id, poi.product_id, poi.ordered_qty
having received_qty < poi.ordered_qty;

-- 31 What percentage of received units are rejected during quality inspection?
select sum(rejected_qty) * 100.0 /
nullif(sum(received_qty), 0) as rejection_pct
from product_restock_events;

-- 32 Which products do not have a secondary supplier?
select product_id, product_name
from products
where secondary_supplier_id is null;

-- 33 What relationship, if any, exists between supplier delivery delays and inventory stockout frequency?
select s.supplier_name,
avg(datediff(r.received_date, po.expected_delivery_date)) as avg_delay_days,
sum(i.stockout_days) as total_stockout_days
from suppliers s
inner join purchase_orders po on s.supplier_id = po.supplier_id
inner join purchase_order_items poi on po.purchase_order_id = poi.purchase_order_id
inner join product_restock_events r on poi.po_item_id = r.po_item_id
inner join inventory_snapshots i on poi.product_id = i.product_id
where r.received_date > po.expected_delivery_date
group by s.supplier_id, s.supplier_name
order by avg_delay_days desc;


