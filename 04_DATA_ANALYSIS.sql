--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;


--Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;


--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;


--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


--09.Are there products where the discounted selling price does not match the MRP and discount percentage?
SELECT sku_id, name, mrp, discountPercent, discountedSellingPrice,
       ROUND(mrp * (1 - discountPercent/100), 2) AS expected_price
FROM zepto
WHERE ABS(discountedSellingPrice - ROUND(mrp * (1 - discountPercent/100), 2)) > 0.01;


--10.Which products give the highest absolute rupee discount (MRP – selling price)?
SELECT name, mrp, discountedSellingPrice,
       ROUND(mrp - discountedSellingPrice, 2) AS absolute_discount
FROM zepto
ORDER BY absolute_discount DESC
LIMIT 10;


--11.What is the average discount percentage for in‑stock vs. out‑of‑stock products?
SELECT outOfStock,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY outOfStock;


--12.Find products that are out of stock but still have a positive available quantity.
SELECT sku_id, name, availableQuantity, outOfStock
FROM zepto
WHERE outOfStock = TRUE AND availableQuantity > 0;


--13.Rank products within each category by price per gram (best value first).
WITH price_per_gram AS (
    SELECT category, name, weightInGms, discountedSellingPrice,
           ROUND(discountedSellingPrice / NULLIF(weightInGms, 0), 2) AS ppg,
           RANK() OVER (PARTITION BY category ORDER BY discountedSellingPrice / NULLIF(weightInGms, 0)) AS rank
    FROM zepto
    WHERE weightInGms > 0
)
SELECT category, name, weightInGms, discountedSellingPrice, ppg
FROM price_per_gram
WHERE rank <= 3
ORDER BY category, rank;


--14. What is the total inventory value (at MRP and at discounted price) per category?
SELECT category,
       SUM(mrp * availableQuantity) AS total_mrp_value,
       SUM(discountedSellingPrice * availableQuantity) AS total_discounted_value,
       ROUND(SUM(mrp * availableQuantity) - SUM(discountedSellingPrice * availableQuantity), 2) AS total_discount_given
FROM zepto
GROUP BY category
ORDER BY total_discounted_value DESC;


--15.List products that have the same name but different categories or prices.
SELECT name,
       COUNT(DISTINCT category) AS distinct_categories,
       COUNT(DISTINCT mrp) AS distinct_mrps,
       COUNT(DISTINCT discountedSellingPrice) AS distinct_prices
FROM zepto
GROUP BY name
HAVING COUNT(DISTINCT category) > 1
    OR COUNT(DISTINCT mrp) > 1
    OR COUNT(DISTINCT discountedSellingPrice) > 1;


--16.What is the distribution of products across weight categories (Low, Medium, Bulk) for each category?
SELECT category,
       CASE WHEN weightInGms < 1000 THEN 'Low'
            WHEN weightInGms < 5000 THEN 'Medium'
            ELSE 'Bulk'
       END AS weight_category,
       COUNT(*) AS product_count
FROM zepto
GROUP BY category, weight_category
ORDER BY category, weight_category;


--17. Find the top 5 most expensive products (by MRP) that are currently in stock.
SELECT name, mrp, discountedSellingPrice, category
FROM zepto
WHERE outOfStock = FALSE
ORDER BY mrp DESC
LIMIT 5;


--18.Products with a discount of more than 50% and still in stock – which categories do they belong to?
SELECT category, COUNT(*) AS high_discount_products
FROM zepto
WHERE discountPercent > 50 AND outOfStock = FALSE
GROUP BY category
ORDER BY high_discount_products DESC;


--19.Calculate the median discount percentage per category.
WITH discount_ranks AS (
    SELECT category, discountPercent,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY discountPercent) AS row_num,
           COUNT(*) OVER (PARTITION BY category) AS total
    FROM zepto
)
SELECT category,
       AVG(discountPercent) AS median_discount
FROM discount_ranks
WHERE row_num IN (FLOOR((total+1)/2), CEIL((total+1)/2))
GROUP BY category
ORDER BY median_discount DESC;


--20.Identify products that have a low stock (availableQuantity < 10) but are not marked out of stock.
SELECT sku_id, name, category, availableQuantity
FROM zepto
WHERE availableQuantity < 10 AND outOfStock = FALSE
ORDER BY availableQuantity;