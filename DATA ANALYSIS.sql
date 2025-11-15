-- What is the total number of order--
SELECT count(*)
FROM orders;

-- Total pizza sold --
SELECT 
SUM(quantity)
FROM order_details;

-- what is average price of pizza
SELECT 
round(AVG(price),2) AS avg_price
FROM pizzas;

-- what is average price of each pizza sizes
SELECT size,
round(AVG(price),2) AS avg_price
FROM pizzas
GROUP BY size;

-- what is the total revenue generated
SELECT 
round(SUM(price*quantity)) AS total_revenue
FROM order_details AS od
JOIN pizzas AS pz
ON pz.pizza_id = od.pizza_id;




-- What is the total revenue generated monthly
SELECT monthname(date) AS month,
	   round(SUM(price*quantity)) AS total_revenue
FROM order_details AS od
JOIN orders AS os
ON od.order_id = os.order_id
JOIN pizzas AS pz
ON pz.pizza_id = od.pizza_id
GROUP BY month;

-- What is the total revenue generated quarterly
SELECT quarter(date) AS quarter,
	   round(SUM(price*quantity)) AS total_revenue
FROM order_details AS od
JOIN orders AS os
ON od.order_id = os.order_id
JOIN pizzas AS pz
ON pz.pizza_id = od.pizza_id
GROUP BY quarter;


-- Which pizza types (and sizes) are the most and least popular based on quantity sold?
SELECT  'Most popular' AS Popularity,  -- most popular --
		od.pizza_id, pz.size, pt.name,
	   SUM(quantity) AS total_quantity
FROM order_details AS od
JOIN pizzas AS pz
ON od.pizza_id = pz.pizza_id
JOIN pizza_types AS pt
ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY Popularity, od.pizza_id, pt.name, pz.size
ORDER BY total_quantity DESC
LIMIT 5;


SELECT 'Least popular' AS Popularity,  -- least popular --
	   od.pizza_id, pz.size, pt.name,
	   SUM(quantity) AS total_quantity
FROM order_details AS od
JOIN pizzas AS pz
ON od.pizza_id = pz.pizza_id
JOIN pizza_types AS pt
ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY od.pizza_id, pt.name, pz.size
ORDER BY total_quantity
LIMIT 5;

-------------- ALTERNATIVELY ---------------
    
WITH pizza_sales AS (
	SELECT pt.name, pz.size, 
	   SUM(quantity) AS total_quantity
FROM order_details AS od
JOIN pizzas AS pz
ON od.pizza_id = pz.pizza_id
JOIN pizza_types AS pt
ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY od.pizza_id, pt.name, pz.size
)

(SELECT 'most popular' AS Popularity,
	   name, size, total_quantity
       FROM pizza_sales
ORDER BY total_quantity DESC 
LIMIT 5)
UNION ALL
(SELECT 'Least popular' AS Popularity,
	   name, size, total_quantity
       FROM pizza_sales
ORDER BY total_quantity
LIMIT 5) ;


-- How do sales differ across pizza categories (Classic, Chicken, Supreme, Veggie)?
SELECT pt.category,
round(SUM(quantity*price)) AS total_sales
FROM pizza_types AS pt
JOIN pizzas AS pz
ON pt.pizza_type_id = pz.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = pz.pizza_id
GROUP BY pt.category
ORDER BY total_sales DESC;


-- How do sales differ across pizza sizes --
SELECT pz.size,
round(SUM(quantity*price)) AS total_sales
FROM pizzas AS pz
JOIN order_details AS od
ON od.pizza_id = pz.pizza_id
GROUP BY pz.size
ORDER BY total_sales DESC;


-- What is the average number of pizzas per order, and does it vary by time or day?
SELECT order_counts.order_id,
DAYNAME(os.date) AS day_of_week,
HOUR(os.time) AS hour_of_day,
round(AVG(pizza_count)) AS avg_pizzas_per_order
FROM 
(       
	SELECT order_id, 
	SUM(quantity) AS pizza_count 
	FROM order_details 
	GROUP BY order_id
    )
	AS order_counts
JOIN orders AS os 
ON order_counts.order_id = os.order_id
GROUP BY order_counts.order_id, DAYNAME(os.date), HOUR(os.time)
ORDER BY avg_pizzas_per_order DESC;


-- How does pizza size affect pricing, and which size provides the highest revenue contribution?

SELECT pz.size AS pizza_size,
round(SUM(price*quantity),2) AS total_revenue,
COUNT(DISTINCT order_id) AS order_count,
SUM(quantity) AS total_pizza_sold
FROM pizzas AS pz
JOIN order_details AS od
ON pz.pizza_id = od.pizza_id
GROUP BY pizza_size
ORDER BY total_revenue DESC;


-- Are there underperforming pizzas that could be promoted or removed from the menu?--
SELECT pz.pizza_id, pt.name,
SUM(quantity) AS total_sold,
round(SUM(price*quantity),2) AS total_revenue
FROM pizzas AS pz
JOIN order_details AS od
ON pz.pizza_id = od.pizza_id
JOIN pizza_types AS pt
ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY pz.pizza_id, pt.name
ORDER BY total_revenue
LIMIT 5;


-- which day of week has the most pizza orders ?
SELECT dayname(date) AS day_of_week,
SUM(quantity) AS total_pizzas_sold,
COUNT(DISTINCT os.order_id) AS total_orders
FROM order_details AS od
JOIN orders AS os
ON od.order_id = os.order_id
GROUP BY day_of_week
ORDER BY total_pizzas_sold DESC;
