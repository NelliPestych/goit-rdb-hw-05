-- ДЗ5: Вкладені запити. Повторне використання коду

-- Завдання 1: вкладений запит у SELECT (order_details + customer_id з orders)
SELECT *,
       (SELECT o.customer_id FROM orders o WHERE o.id = od.order_id) AS customer_id
FROM order_details od;

-- Завдання 2: вкладений запит у WHERE (shipper_id = 3)
SELECT *
FROM order_details od
WHERE od.order_id IN (
  SELECT id FROM orders WHERE shipper_id = 3
);

-- Завдання 3: вкладений запит у FROM для обчислення середнього quantity при quantity > 10
SELECT order_id, AVG(quantity) AS avg_quantity
FROM (
  SELECT * FROM order_details WHERE quantity > 10
) AS filtered_details
GROUP BY order_id;

-- Завдання 4: те саме як в завданні 3, але з WITH
WITH temp AS (
  SELECT * FROM order_details WHERE quantity > 10
)
SELECT order_id, AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- Завдання 5: створення та використання функції
DROP FUNCTION IF EXISTS divide_quantity;
DELIMITER $$

CREATE FUNCTION divide_quantity(x FLOAT, y FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN
  RETURN x / y;
END$$

DELIMITER ;

-- Використання функції для quantity
SELECT id, product_id, order_id,
       quantity,
       divide_quantity(quantity, 2) AS divided_quantity
FROM order_details;



