use placement;

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    total_price DECIMAL(10, 2)
);

-- Insert sample data into Sales table

INSERT INTO Sales (sale_id, product_id, quantity_sold, sale_date, total_price) VALUES
(1, 101, 5, '2024-01-01', 2500.00),
(2, 102, 3, '2024-01-02', 900.00),
(3, 103, 2, '2024-01-02', 60.00),
(4, 104, 4, '2024-01-03', 80.00),
(5, 105, 6, '2024-01-03', 90.00);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

-- Insert sample data into Products table

INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
(101, 'Laptop', 'Electronics', 500.00),
(102, 'Smartphone', 'Electronics', 300.00),
(103, 'Headphones', 'Electronics', 30.00),
(104, 'Keyboard', 'Electronics', 20.00),
(105, 'Mouse', 'Electronics', 15.00);
select * from Products;
select * from Sales;

-- Calculate the total revenue generated from sales of products in the 'Electronics' category.
select sum(sales.total_price) as Total_Revenue 
from Sales
join Products on Sales.product_id=Products.product_id;

-- 17. Retrieve the product_name and unit_price from the Products table, filtering the unit_price to show only values between $20 and $600.
select product_name, unit_price 
from Products
where unit_price between 20 and 600;


-- Retrieve the product_name and category from the Products table, ordering the results by category in ascending order.
-- Calculate the total quantity_sold of products in the 'Electronics' category.
select sum(Sales.quantity_sold) as Total_quantity_sold
from Sales join Products
on Sales.product_id=Products.product_id
where Products.category = 'Electronics';

--  Retrieve the product_name and total_price from the Sales table, calculating the total_price as quantity_sold multiplied by unit_price.
select * from Sales;
select * from Products;
select product_name ,  quantity_sold*unit_price
as total_price
from Sales join Products
on Sales.product_id = Products.product_id;
 
-- Calculate the total revenue generated from sales for each product category.
select category, sum(total_price) as revenue 
from Sales
join Products on Sales.product_id=Products.product_id
group by category;

--  Find the product category with the highest average unit price.
select category , avg(unit_price) 
as avg_unit_price
from Products
group by category
order by avg_unit_price desc
limit 1;

-- Identify products with total sales exceeding 30.
select product_name,quantity_sold from Products
join Sales on Products.product_id=Sales.product_id
having quantity_sold>30;

-- Count the number of sales made in each month.
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month, COUNT(*) AS sales_count
FROM Sales s
GROUP BY month;

-- Determine the average quantity sold for products with a unit price greater than $100.
select * from Sales;
select * from Products;

select avg(Sales.quantity_sold) as avg_quantity_sold 
from Sales join Products
on Sales.product_id=Products.product_id 
where unit_price>100;

-- Retrieve the product name and total sales revenue for each product.
select product_name, sum(total_price) as revenue
from Sales s join Products p
on s.product_id=p.product_id
group by product_name;

-- 7. List all sales along with the corresponding product names.
 select * from Sales;
select * from products;
SELECT s.sale_id, p.product_name
FROM Sales s
JOIN Products p ON s.product_id = p.product_id;

--  Retrieve the product name and total sales revenue for each product.
select product_name , sum(total_price) as total_sales_revenue
from Sales s join Products p
on  s.product_id=p.product_id
group by product_name;

-- nested queries
select total_price, 
(select avg(total_price) from Sales) as AVG_total_price
 from Sales 
where total_price < (select avg(total_price) from Sales);


