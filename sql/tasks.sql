CREATE TABLE departments (
 id     SERIAL PRIMARY KEY,
 name   VARCHAR(50) NOT NULL,
 location VARCHAR(50)
);

CREATE TABLE employees (
 id           SERIAL PRIMARY KEY,
 name         VARCHAR(50) NOT NULL,
 position     VARCHAR(50),
 salary       NUMERIC(10,2),
 department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
 manager_id   INTEGER REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE customers (
 id   SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 city VARCHAR(50)
);

CREATE TABLE orders (
 id          SERIAL PRIMARY KEY,
 order_date  DATE NOT NULL,
 amount      NUMERIC(10,2),
 employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
 customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE products (
 id    SERIAL PRIMARY KEY,
 name  VARCHAR(100) NOT NULL,
 price NUMERIC(10,2)
);

CREATE TABLE order_items (
 id         SERIAL PRIMARY KEY,
 order_id   INTEGER REFERENCES orders(id) ON DELETE CASCADE,
 product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
 quantity   INTEGER NOT NULL
);

--1
SELECT E.ID, E.NAME,  COALESCE(D.NAME, 'NO DEPARTMENT') AS DEPARTMENT
FROM EMPLOYEES E 
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.ID 

--2 Сотрудники, у которых есть менеджер (показать имя сотрудника и имя менеджера).
CREATE TABLE managers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO managers (name) VALUES
('Alice Johnson'),
('David Green'),
('Eve Black'),
('Grace Adams');


SELECT E.NAME,  M.NAME  AS MANAGER
FROM EMPLOYEES E 
INNER JOIN MANAGERS M ON E.MANAGER_ID  = M.ID  

--3
SELECT D."NAME" 
FROM DEPARTMENTS D 
LEFT JOIN EMPLOYEES E ON D.ID = E.DEPARTMENT_ID 
WHERE E.ID IS NULL

--4
SELECT O.ID ,
	COALESCE(E."NAME", 'NO EMPLOYEE'),
	COALESCE(C."NAME", 'NO CUSTOMER')
FROM ORDERS O
LEFT JOIN EMPLOYEES E ON O.EMPLOYEE_ID = E.ID 
LEFT JOIN CUSTOMERS C ON O.CUSTOMER_ID  = C.ID 

--5
SELECT O.ID , P."NAME", OI.QUANTITY 
FROM  ORDERS O
LEFT JOIN ORDER_ITEMS OI ON O.ID = OI.ORDER_ID 
LEFT JOIN PRODUCTS P ON OI.PRODUCT_ID = P.ID 

--6
SELECT 
    d.id AS department_id,
    d.name AS department_name,
    COUNT(o.id) AS total_orders
FROM departments d
LEFT JOIN employees e 
    ON d.id = e.department_id
LEFT JOIN orders o 
    ON e.id = o.employee_id
GROUP BY d.id, d.name
ORDER BY d.name;

--7
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    p.id AS product_id,
    p.name AS product_name
FROM customers c
CROSS JOIN products p
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE o.customer_id = c.id
      AND oi.product_id = p.id
)
ORDER BY c.name, p.id;

--8
SELECT 
    p.id,
    p.name,
    p.price
FROM products p
LEFT JOIN order_items oi 
    ON p.id = oi.product_id
WHERE oi.id IS NULL
ORDER BY p.name;

--9
SELECT m.name AS manager_name,
	COALESCE(SUM(o.amount), 0) AS total_sales
FROM managers m
LEFT JOIN employees e 
    ON e.manager_id = m.id
LEFT JOIN orders o 
    ON o.employee_id = e.id
GROUP BY m.name
ORDER BY total_sales DESC;

--10
SELECT 
    COUNT(*) AS total_orders,
    COALESCE(SUM(amount), 0) AS total_revenue
FROM orders;

--11
SELECT 
    d.id AS department_id,
    d.name AS department_name,
    COALESCE(AVG(e.salary), 0) AS avg_salary,
    COALESCE(MAX(e.salary), 0) AS max_salary
FROM departments d
LEFT JOIN employees e 
    ON e.department_id = d.id
GROUP BY d.id, d.name
ORDER BY d.name;

--12
SELECT
    oi.order_id,
    SUM(oi.quantity) AS total_quantity,
    COUNT(DISTINCT oi.product_id) AS distinct_products
FROM order_items oi
GROUP BY oi.order_id;

--13
SELECT
    p.id AS product_id,
    p.name AS product_name,
    SUM(oi.quantity * p.price) AS total_product_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_product_revenue DESC
LIMIT 3;

--14
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders;

--15
SELECT    
    d.name AS department_name,
    COUNT(DISTINCT e.id) AS employee_count,
    COALESCE(AVG(e.salary), 0) AS avg_salary,
    COALESCE(SUM(o.amount), 0) AS total_orders_amount
FROM departments d
LEFT JOIN employees e 
    ON e.department_id = d.id
LEFT JOIN orders o 
    ON o.employee_id = e.id
GROUP BY d.name;

--16
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    AVG(o.amount) AS avg_order_amount
FROM customers c
JOIN orders o 
    ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING AVG(o.amount) > (
    SELECT AVG(amount) FROM orders);

--17

--18
SELECT
    id AS order_id,
    TO_CHAR(order_date, 'DD.MM.YYYY HH24:MI') AS formatted_date
FROM orders
ORDER BY order_date;

--19
SELECT
    id AS order_id,
    order_date,
    amount
FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL ':N days'
ORDER BY order_date;

--20
SELECT
    id,
    name,
    position,
    COALESCE(salary, 0) AS salary,
    CASE 
        WHEN position = 'Sales' THEN COALESCE(salary, 0) * 0.10
        ELSE 0
    END AS bonus,
    COALESCE(salary, 0) + 
    CASE 
        WHEN position = 'Sales' THEN COALESCE(salary, 0) * 0.10
        ELSE 0
    END AS total_compensation
FROM employees
ORDER BY name;