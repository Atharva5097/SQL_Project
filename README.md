# Supply Chain Analytics SQL Case Study
Optimizing Warehouse Operations & Procurement Efficiency through Advanced SQL Analytics
# Project Overview
This project analyzes a realistic supply chain dataset simulating procurement, warehouse operations, and delivery workflows. Using advanced SQL techniques such as window functions, partitioning, CTEs, joins, subqueries, and aggregations, it uncovers operational bottlenecks, vendor performance trends, inventory movement insights, and delivery compliance metrics.

The goal is to equip supply chain managers with data-driven insights to improve procurement lead times, warehouse throughput, and on-time delivery, enhancing overall supply chain efficiency.
# 🔧 Tools & Skills Demonstrated
Database: SQL
SQL Techniques:
- Common Table Expressions (CTEs)
- Window functions (ROW_NUMBER(), RANK(), LAG(), LEAD(), AVG() OVER())
- Partitioning using PARTITION BY
- Multiple types of joins (INNER, LEFT, RIGHT)
- Subqueries and correlated subqueries
- Aggregations and GROUP BY with HAVING

# Dataset Summary
- orders: Master order-level data
- order_items: Line item-level order details
- products: Product catalog
- suppliers: Supplier master by region

# 📈 Business Questions & SQL Solutions
# 1. Which vendors have the best on-time delivery performance and how does this vary by product category?
Identifies top-performing vendors and categories with delivery delays, enabling targeted vendor management.
## 🧠 View SQL Code
```sql
SELECT vendor_id, 
       product_category,
       COUNT(*) AS total_orders,

