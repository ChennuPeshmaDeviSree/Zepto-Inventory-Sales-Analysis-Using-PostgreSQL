--Top 3 highest MRP products in each category.
WITH product_rank AS (
    SELECT
        category,
        name,
        mrp,
        RANK() OVER(PARTITION BY category ORDER BY mrp DESC) AS rnk
    FROM zepto
)
SELECT *
FROM product_rank
WHERE rnk <= 3;

--Highest Discount Product in Each Category.
WITH discount_rank AS (
    SELECT
        category,
        name,
        discountpercent,
        DENSE_RANK() OVER(
            PARTITION BY category
            ORDER BY discountpercent DESC
        ) AS rnk
    FROM zepto
)
SELECT *
FROM discount_rank
WHERE rnk = 1;

--Category Revenue Ranking
SELECT
    category,
    SUM(discountedsellingprice * availablequantity) AS revenue,
    RANK() OVER(
        ORDER BY SUM(discountedsellingprice * availablequantity) DESC
    ) AS revenue_rank
FROM zepto
GROUP BY category;

--Rename column name
ALTER TABLE zepto
RENAME COLUMN weightingems TO weightingms;

--Revenue Contribution %
SELECT
    category,
    ROUND(
        SUM(discountedsellingprice * availablequantity) * 100.0 /
        SUM(SUM(discountedsellingprice * availablequantity)) OVER(),
        2
    ) AS revenue_percentage
FROM zepto
GROUP BY category
ORDER BY revenue_percentage DESC;

--Top 5 Products by Revenue
SELECT
    name,
    category,
    (discountedsellingprice * availablequantity) AS revenue
FROM zepto
ORDER BY revenue DESC
LIMIT 5;

--Out of Stock Analysis
SELECT
    category,
    COUNT(*) AS out_of_stock_products
FROM zepto
WHERE outofstock = TRUE
GROUP BY category
ORDER BY out_of_stock_products DESC;

--Average Discount by Category
-- Which categories offer the highest average discount?
SELECT
    category,
    ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

--Products with Highest Inventory Value.
SELECT
    name,
    category,
    (discountedsellingprice * availablequantity) AS inventory_value
FROM zepto
ORDER BY inventory_value DESC
LIMIT 10;

--Count Products in Each Category.
SELECT
    category,
    COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC;

--Categories with Most Out-of-Stock Products.
select category ,count(*) as out_of_stock_products 
from zepto
where outofstock=TRUE
group by category
order by out_of_stock_products desc;