--1
select
	name,
	salary
from
	employees e
where
	salary > (
	select
		AVG(salary)
	from
		employees e2);

--2
select
	p."name" ,
	p.price
from
	products p
where
	p.price >
(
	select
		AVG(p2.price)
	from
		products p2);

--3
select
	d."name"
from
	departments d
where
	id in (
	select
		department_id
	from
		employees e
	where
		salary > 10000);

--4
select
	p.id,
	p.name,
	coalesce((
        select SUM(oi.quantity)
        from order_items oi
        where oi.product_id = p.id
    ), 0) as total_sold
from
	products p
order by
	total_sold desc
limit 3;

--5
select
	c.name,
	(
	select
		count(*)
	from
		orders o
	where
		o.customer_id = c.id
    ) as orders_count
from
	customers c;

--6
explain analyse select
	d.name,
	coalesce((
	select
		AVG(e.salary)
	from
		employees e
	where
		e.department_id = d.id
    ), 0) as avg_salary
from
	departments d;

explain analyse select
	d.id,
	d.name,
	coalesce(sub.avg_salary, 0) as avg_salary
from
	departments d
left join (
	select
		e.department_id,
		AVG(e.salary) as avg_salary
	from
		employees e
	group by
		e.department_id
) as sub on
	d.id = sub.department_id;

--7
select
	c.name,
from
	customers c
where
	not exists (
	select
		1
	from
		orders o
	where
		o.customer_id = c.id
);

--8
select
	e.id,
	e.name,
	e.position,
	e.salary
from
	employees e
where
	e.salary > (
	select
		MAX(m.salary)
	from
		employees m
	where
		m.id in (
		select
			distinct manager_id
		from
			employees
		where
			manager_id is not null
    )
);

--9
select
	d.id,
	d.name
from
	departments d
where
	(
	select
		MIN(e.salary)
	from
		employees e
	where
		e.department_id = d.id
) > 5000;