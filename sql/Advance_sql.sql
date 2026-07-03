drop database cop;
create database cop;
use cop;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT,
    signup_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES
(1,'Amit','Delhi',25,'2023-01-10'),
(2,'Sara','Mumbai',30,'2022-12-05'),
(3,'John','Bangalore',28,'2023-02-15'),
(4,'Ali','Hyderabad',35,'2021-11-20'),
(5,'Neha','Chennai',27,'2023-03-01'),
(6,'Ravi','Delhi',40,'2020-07-19'),
(7,'Priya','Mumbai',22,'2023-04-12'),
(8,'Kiran','Hyderabad',31,'2022-05-22'),
(9,'David','Bangalore',29,'2023-01-25'),
(10,'Meena','Chennai',33,'2021-09-10'),
(11,'Arjun','Delhi',26,'2022-08-18'),
(12,'Fatima','Hyderabad',24,'2023-02-28'),
(13,'Rahul','Mumbai',37,'2020-06-30'),
(14,'Sneha','Chennai',21,'2023-03-14'),
(15,'Vikram','Bangalore',45,'2019-12-11'),
(16,'Zoya','Delhi',23,'2023-04-01'),
(17,'Imran','Hyderabad',34,'2022-07-07'),
(18,'Pooja','Mumbai',29,'2023-01-19'),
(19,'Nikhil','Chennai',32,'2021-10-05'),
(20,'Ananya','Bangalore',27,'2023-03-30');

INSERT INTO Products VALUES
(101,'Laptop','Electronics',70000),
(102,'Mobile','Electronics',30000),
(103,'Tablet','Electronics',25000),
(104,'Headphones','Accessories',2000),
(105,'Shoes','Fashion',4000),
(106,'Watch','Fashion',8000),
(107,'Backpack','Accessories',1500),
(108,'Keyboard','Electronics',1200),
(109,'Mouse','Electronics',800),
(110,'T-shirt','Fashion',1000),
(111,'Jeans','Fashion',2500),
(112,'Charger','Accessories',600);


INSERT INTO Orders VALUES
(1,1,101,1,'2023-05-01'),
(2,2,102,2,'2023-05-03'),
(3,3,104,3,'2023-05-04'),
(4,1,105,1,'2023-05-05'),
(5,4,101,2,'2023-05-06'),
(6,5,110,1,'2023-05-07'),
(7,6,103,1,'2023-05-08'),
(8,7,108,2,'2023-05-09'),
(9,8,111,1,'2023-05-10'),
(10,2,112,5,'2023-05-11');

select * from Customers;
select * from Orders;
select * from Products;


/*Top 3 Customers by Total Spending : rank total spending of each customers in desc and fetch rank<=3*/

select * from
(select c.customer_id,c.name,sum(o.quantity*p.price) as total_spending, dense_rank() over(order by sum(o.quantity*p.price) desc) as rnk 
from Customers c join Orders o on c.customer_id=o.customer_id join Products p on p.product_id = o.product_id
group by customer_id,name)x
where rnk<=3;


/*Running Total of Customer Spending by date*/

select customer_id,o.order_date,sum(p.price*o.quantity) over(order by order_date) as running_total 
from Products p join Orders o on o.product_id = p.product_id;

/*Most Sold Product in Each Category*/

select * from
(select category,product_name,sum(quantity) as total_quantity,
dense_rank() over(partition by category order by sum(quantity) desc) as rnk 
from Orders join Products on Orders.product_id = Products.product_id 
group by category,product_name)x
where rnk=1;

/*top selling products overall*/
select p.product_name,sum(o.quantity) as total_quantity,rank() over(order by sum(o.quantity) desc) as rnk 
from Orders o join Products p on o.product_id= p.product_id group by product_name;

/*Monthly Revenue Trend*/
select month(order_date),sum(quantity*price) as revenue,
lag(sum(quantity*price)) over(order by month(order_date)) as prev_month
from Orders join products on Orders.product_id = Products.product_id
group by month(order_date);

/*percentage contribtion of each product*/
SELECT
    p.product_name,
    SUM(o.quantity * p.price) AS revenue,
    ROUND(
        SUM(o.quantity * p.price) * 100.0 /
        SUM(SUM(o.quantity * p.price)) OVER(),
        2
    ) AS contribution_pct
FROM Orders o
JOIN Products p
ON o.product_id = p.product_id
GROUP BY p.product_name;


/*rank customers within each city*/

select name,city,spending,
rank() over(partition by city order by spending ) as city_rnk 
from 
(select c.name,c.city,sum(p.price*o.quantity) as spending
from Customers c join Orders o on c.customer_id = o.customer_id 
join Products p on p.product_id = o.product_id
group by c.name,c.city)x ;


/*sevond highest spending customer */
select *
from
(select c.name,sum(p.price*o.quantity) as spending,
dense_rank() over(order by sum(o.quantity*p.price) desc) as rnk
from Customers c join Orders o on c.customer_id = o.customer_id
join Products p on p.product_id = o.product_id
group by c.name)x 
where rnk=2;

/*top two products in each category by revenue*/

select * 
from
(select p.product_name,p.category,sum(o.quantity*p.price) as revenue,
dense_rank() over(partition by category order by sum(o.quantity*p.price)) as rnk
from Products p join Orders o 
on p.product_id = o.product_id 
group by p.product_name,p.category)x
where rnk<=2;


/*Customers who bought products from more than one category*/

SELECT c.customer_id,
       c.name,
       COUNT(DISTINCT p.category) AS category_count
FROM Customers c
JOIN Orders o
  ON c.customer_id = o.customer_id
JOIN Products p
  ON o.product_id = p.product_id
GROUP BY c.customer_id,c.name
HAVING COUNT(DISTINCT p.category) > 1;


/*Customer who purchased the maximum number of distinct products*/

select * from 
(select c.name,c.customer_id,count(distinct product_name) as no_of_dist_prod,
rank() over (order by count(distinct p.product_name) desc ) as rnk
from Customers c
JOIN Orders o
  ON c.customer_id = o.customer_id
JOIN Products p
  ON o.product_id = p.product_id
GROUP BY c.customer_id,c.name)x
where rnk=1;

/*Product purchased by the highest number of customers*/

select * from 
(select p.product_name,count(distinct c.customer_id),
dense_rank() over(order by count(distinct c.customer_id) desc) as rnk
from Customers c
JOIN Orders o
  ON c.customer_id = o.customer_id
JOIN Products p
  ON o.product_id = p.product_id 
group by p.product_name)x
where rnk=1;

/*Category with maximum average order value*/

select *
from 
(select p.category,avg(p.price*o.quantity) as avg_order_value,dense_rank() 
over(order by avg(p.price*o.quantity) desc) as rnk
from 
Products p join Orders o on p.product_id = o.product_id
group by p.category)x
where rnk=1;

/*Customers whose spending is above 50000*/
select * 
from
(select c.name,c.customer_id,sum(o.quantity*p.price) as spending
from 
Customers c JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id 
group by c.name,c.customer_id)x
where spending>50000;

/*Customers whose spending is above average customer spending*/

select * 
from
(select c.name,c.customer_id,sum(o.quantity*p.price) as spending
from 
Customers c JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id 
group by c.name,c.customer_id)x
where spending>
(select avg(spending) from
	( select c.name,c.customer_id,sum(o.quantity*p.price) as spending 
    from
	Customers c JOIN Orders o ON c.customer_id = o.customer_id
	JOIN Products p ON o.product_id = p.product_id 
    group by c.name,c.customer_id)y
);
	
/*divide customers into 4 segments based on their spending from highest to lowest*/
SELECT customer_id,
       name,
       spending,
       NTILE(4) OVER(
           ORDER BY spending DESC
       ) bucket
FROM (
    SELECT c.customer_id,
           c.name,
           SUM(p.price * o.quantity) spending
    FROM Customers c
    JOIN Orders o
      ON c.customer_id = o.customer_id
    JOIN Products p
      ON o.product_id = p.product_id
    GROUP BY c.customer_id,c.name
) x;

/******************************************CTEs*************************************************/
/*top 3 customers by total spending*/
with spending_table as (
select c.customer_id,c.name,sum(o.quantity*p.price) as total_spending, dense_rank() over(order by sum(o.quantity*p.price) desc) as rnk 
from Customers c join Orders o on c.customer_id=o.customer_id join Products p on p.product_id = o.product_id
group by customer_id,name
)
select * from spending_table where rnk<=3;


/*customers whose spending is above avg customer spendimg*/

/*solution 1:
		this solution uses two inner qeries or two derived tables
        x:  to compute each customer's Spending , y: to find avg  customer spending
        its considered less effieient coz it does the same computation of finding customerSpending twice*/
select * 
from
(select c.name,c.customer_id,sum(o.quantity*p.price) as spending
from 
Customers c JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id 
group by c.name,c.customer_id)x
where spending>
(select avg(spending) from
	( select c.name,c.customer_id,sum(o.quantity*p.price) as spending 
    from
	Customers c JOIN Orders o ON c.customer_id = o.customer_id
	JOIN Products p ON o.product_id = p.product_id 
    group by c.name,c.customer_id)y
);

/*solution 2:
			uses a cte to , a temporary result set that can be re-used but since the inner query is 
            independent of outer query, it computes avg for each comparison 
            again its less effiecint*/
            
with spending_cte as
(select c.customer_id,c.name,sum(o.quantity*p.price) as total_spending
from
Customers c join Orders o 
on c.customer_id = o.customer_id 
join Products p 
on p.product_id = o.product_id
group by c.customer_id,name)
select * from spending_cte 
where total_spending>(select avg(total_spending) from spending_cte);

/*Solution 3
			this uses a cte and a window function and is considered as most elegant solution coz 
            it computes avg only one*/
with spending_cte as (
    select c.customer_id,
           c.name,
           sum(o.quantity*p.price) as total_spending
    from Customers c
    join Orders o on c.customer_id = o.customer_id
    join Products p on p.product_id = o.product_id
    group by c.customer_id, c.name
)
select name  /*or other colums can also be fetched*/
from (
    select *,
           avg(total_spending) over() as avg_spending
    from spending_cte
)x
where total_spending > avg_spending;

/*highest revenue product*/
with revenue_cte as (
	select p.product_id,p.product_name,sum(o.quantity*p.price) as revenue
    from 
    Products p join Orders o
    on p.product_id = o.product_id
    group by p.product_id,p.product_name
)
select * from
(select *,dense_rank() over (order by revenue desc) as rnk
from revenue_cte)x
where rnk=1;

/*revenue contribution by each category*/

WITH category_revenue AS (
    SELECT
        p.category,
        SUM(o.quantity * p.price) revenue
    FROM Orders o
    JOIN Products p
        ON o.product_id=p.product_id
    GROUP BY p.category
)

SELECT
    category,
    revenue,
    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER(),
        2
    ) contribution_pct
FROM category_revenue;


/*categorize customers into 4 segments based on their spending in desc order*/

with segment_cte as (
	select c.customer_id,c.name,sum(o.quantity*p.price) as spending
    from
    Customers c join Orders o 
    on c.customer_id = o.customer_id join Products p
    on p.product_id = o.product_id
    group by c.customer_id,c.name
)
select *,ntile(4) over(order by spending desc) as segments
from segment_cte;


/*Customer's First and Latest Order*/
select * from Orders;
WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY order_date
        ) first_rn,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) last_rn
    FROM Orders
)
SELECT *
FROM customer_orders
WHERE first_rn = 1
   OR last_rn = 1;

/*same query in a single row */
SELECT
    customer_id,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM Orders
GROUP BY customer_id;

/*monthly revenue trend*/
with revenueTrend_cte as
(select month(o.order_date) as month_number,sum(o.quantity*p.price) as revenue
from Products p join Orders o
on p.product_id = o.product_id
group by month_number)
select *,lag(revenue) over(order by month_number) as previous_month_revenue
from revenueTrend_cte;

/*running revenue by date*/

with runningRevenue_cte as
(select o.order_date,sum(o.quantity*p.price) as revenue
from Products p join Orders o 
on p.product_id = o.product_id
group by o.order_date)
select order_date, sum(revenue) over(order by order_date) as runningRevenue
from runningRevenue_cte;

/* percentage revenue contribution by category*/

with contribution_cte as
(select p.category,sum(o.quantity*p.price) as revenue
from Products p join Orders o 
on p.product_id = o.product_id
group by p.category)
select *,(revenue/(select sum(revenue) from contribution_cte))*100 as percentage_contribution
from contribution_cte;




