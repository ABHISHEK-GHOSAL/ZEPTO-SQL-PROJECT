<h1>Data Cleaning Steps Performed</h1>
Step	Description
1 Removed rows where mrp or discountedSellingPrice is zero (invalid pricing).
2 Converted prices from paise to rupees (i.e., divided by 100) for accurate monetary representation.
3 Checked for NULL values across all columns – none found in the cleaned dataset.
4 Identified duplicate product names to review potential data entry issues.



<h1>Business Questions & Analysis (20 Queries)</h1>
The project answers 20 critical business questions, divided into logical categories:

<h1>Exploratory & Descriptive</h1>
#	Question
Q1	What are the top 10 best‑value products based on the highest discount percentage?
Q2	Which high‑MRP products (>₹300) are currently out of stock?
Q3	What is the estimated revenue per category (at discounted selling price)?
Q4	Which products have MRP > ₹500 and a discount < 10%?
Q5	Which top 5 categories offer the highest average discount?


<h1>Weight & Value‑for‑Money</h1>
#	Question
Q6	What is the price per gram for products above 100g, sorted by best value?
Q7	How are products grouped into Low (<1kg), Medium (1–5kg), and Bulk (>5kg) weight categories?
Q8	What is the total inventory weight per category?
Q13	Rank products within each category by price per gram (best value first).
Q16	What is the distribution of weight categories (Low/Medium/Bulk) across each product category?

<h1>Pricing & Discount Integrity</h1>
#	Question
Q9	Are there products where the discountedSellingPrice does not match the MRP and discount% calculation? (Integrity check)
Q10	Which products offer the highest absolute rupee discount (MRP – selling price)?
Q11	What is the average discount for in‑stock vs. out‑of‑stock products?
Q18	Which categories have the most products with >50% discount that are still in stock?
Q19	What is the median discount percentage per category? (More robust than average)

<h1>Inventory & Stock Management</h1>
#	Question
Q12	Are there products marked out‑of‑stock but still having a positive availableQuantity? (Inconsistency check)
Q17	What are the top 5 most expensive products (by MRP) that are currently in stock?
Q20	Which products have low stock (<10 units) but are not marked out of stock? (Restocking alert)

<h1>Revenue & Category Performance</h1>
#	Question
Q14	What is the total inventory value (at MRP and discounted price) per category?
Q15	Which product names appear under multiple categories or have inconsistent MRP/prices? (Duplicate integrity)




<h1>Key Insights (Expected Outcomes)</h1>
High‑value gaps: Several high‑MRP products are out of stock, indicating lost revenue opportunities.

Discount sweet spots: Categories like Beverages and Snacks often show the highest average discounts.

Pricing errors: A few products show mismatches between MRP, discount%, and selling price – flagged for review.

Weight segmentation: The majority of products fall into the "Low" weight category (<1kg), with a few Bulk items driving total inventory weight.

Revenue leaders: Certain categories (e.g., Groceries) dominate total estimated revenue, while others underperform.

Restocking alerts: Several products with low quantity are not flagged as out‑of‑stock – useful for operational teams.

<h1>Tools & Technologies</h1>
Database: PostgreSQL

Language: SQL (DDL, DML, Analytical Functions, CTEs, Window Functions)

Environment: pgAdmin / DBeaver / psql CLI

<h1>Future Scope / Improvements</h1>
Connect to a visualization tool (e.g., Tableau, Power BI, or Metabase) for dashboards.

Integrate with Python (pandas/matplotlib) for advanced statistical analysis.

Add time‑series tracking (e.g., discount changes over time) for dynamic pricing insights.

Automate data quality checks using stored procedures or scheduled jobs.

