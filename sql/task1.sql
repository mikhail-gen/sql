CREATE TABLE sales (
   id SERIAL PRIMARY KEY,
   region VARCHAR(20),
   amount BIGINT,
   sale_date DATE
);

INSERT INTO sales (region, amount, sale_date) VALUES
('North', 1000, '2024-01-01'),
('South', 700, '2024-01-02'),
('North', 500, '2024-01-03'),
('West', NULL, '2024-01-04'),
('South', 900, '2024-01-05'),
('North', 1500, '2024-01-06');

--1
select region, SUM(s.amount) AS total_amount
from sales s
group by s.region

--2
select region, AVG(s.amount) AS avg_amount
from sales s
group by s.region
having count(s.sale_date)>1

--3
select region, sum(s.amount) AS total_amount
from sales s
group by s.region
having sum(s.amount) is not null
order by total_amount desc
limit 1

--4
select
    COUNT(s.id) AS total_sales_count,
    (
        SELECT COUNT(tnnsc.id)
        FROM sales tnnsc
        WHERE tnnsc.amount IS NOT NULL
    ) AS total_not_null_sales_count
from sales s;

--5
select
    s.region,
    SUM(s.amount) AS total_amount
from sales s
group by s.region
having sum(s.amount) > (
    SELECT AVG(region_total)
    FROM (
        SELECT SUM(s2.amount) AS region_total
        FROM sales s2
        GROUP BY s2.region
    ) sub
);