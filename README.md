# StockSense: Inventory, Sales and Supplier Analytics

End-to-end analysis of a multi-location retail business (Kestrel) using MySQL and Power BI. The project covers data quality validation, sales performance, inventory health, and supplier reliability.

## Dashboard Preview
![StockSense Dashboard](dashboard.png)

## Business Problem
Retail teams lose sales to stockouts, tie up cash in slow-moving stock, and depend on suppliers who deliver late. This project answers: what sells, where is stock running out, and which suppliers are hurting availability?

## Dataset
- 11 tables: products, categories, suppliers, locations, sales transactions and items, purchase orders and items, restock events, inventory snapshots, product-location policy
- 5 locations, 33 products, 10 suppliers
- About 7,000 sales transactions (Dec 2024 to Jun 2026) and 9,000 inventory snapshots

## Tools Used
- MySQL (joins, subqueries, window functions, CTEs)
- Power BI (DAX, interactive dashboard)
- Excel (source data)

## Project Phases
| Phase | Focus | File |
|-------|-------|------|
| 1 | Data quality and business overview | `sql/phase_1_data_quality.sql` |
| 2 | Sales and product performance | `sql/phase_2_sales_performance.sql` |
| 3 | Inventory health and stockout analysis | `sql/phase_3_inventory_health.sql` |
| 4 | Supplier reliability and procurement | `sql/phase_4_supplier_reliability.sql` |

## Key Insights
- Completed sales generated about Rs 1.38 crore in net revenue from 12,896 units sold.
- Aero Fry 4L Air Fryer is the top revenue product (about Rs 22.6 lakh), well ahead of PureAir Room Purifier (about Rs 11.8 lakh).
- Kestrel Delhi Flagship contributes the most revenue (about Rs 46.8 lakh), while Hyderabad Fulfilment Centre contributes the least (about Rs 9.7 lakh).
- In-store sales bring in about 60% of revenue and online about 40%.
- Stockouts are widespread: BassPods Bluetooth Earbuds and Aero Fry Air Fryer have the most stockout days, so high-demand products are running out most often.
- Only about 33% of received restock items arrive on or before the expected date. Delta Personal Care Ltd delivered every order late.
- 22 of 33 products have no secondary supplier, so a single late supplier can cause a stockout.
- About 4.3% of received units (471) were rejected in quality inspection.
- About 794 units were lost to shrinkage, damage or adjustments.

## Recommendations
- Add secondary suppliers for products that depend on late suppliers.
- Raise reorder points for high-demand products with frequent stockouts.
- Review contracts with suppliers that deliver late most often.

## Repository Structure
