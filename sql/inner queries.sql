use placement;

drop table  Employee;
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2),
    city VARCHAR(50),
    department VARCHAR(50),
    phone_number VARCHAR(15)
);
INSERT INTO Employee (id, name, salary, city, department, phone_number) VALUES
(0, 'Alice', 60000, 'New York', 'HR', '1234567890'),
(2, 'Bob', 75000, 'Los Angeles', 'Finance', '2345678901'),
(3, 'Charlie', 50000, 'Chicago', 'IT', '3456789012'),
(4, 'Diana', 90000, 'New York', 'Marketing', '4567890123'),
(5, 'Eve', 40000, 'Houston', 'HR', '5678901234'),
(6, 'Frank', 80000, 'San Francisco', 'IT', '6789012345'),
(7, 'Grace', 70000, 'Chicago', 'Finance', '7890123456'),
(8, 'Hank', 45000, 'New York', 'IT', '8901234567'),
(9, 'Ivy', 95000, 'Los Angeles', 'Marketing', '9012345678'),
(10, 'Jack', 55000, 'Houston', 'HR', '0123456789'),
(11, 'Karen', 62000, 'San Francisco', 'Finance', '1231231234'),
(12, 'Leo', 72000, 'Chicago', 'IT', '2342342345'),
(13, 'Mia', 83000, 'New York', 'Marketing', '3453453456'),
(14, 'Nina', 67000, 'Los Angeles', 'HR', '4564564567'),
(15, 'Oscar', 47000, 'Houston', 'IT', '5675675678'),
(16, 'Paul', 93000, 'San Francisco', 'Marketing', '6786786789'),
(17, 'Quinn', 49000, 'New York', 'Finance', '7897897890'),
(18, 'Rita', 71000, 'Los Angeles', 'HR', '8908908901'),
(19, 'Steve', 85000, 'Chicago', 'Finance', '9019019012'),
(20, 'Tina', 58000, 'Houston', 'IT', '0120120123');

select  *from Employee;

-- List employees in departments where the average salary is above 70,000
select * from Employee where department in
(select department  from Employee group by department having avg(salary)>70000);


-- select employees with highest salaries
select name, salary 
from Employee
where salary = (select max(salary) from Employee);

-- Find employees earning less than the average salary of their city

SELECT name, salary, city
FROM Employee e1
WHERE salary < (
    SELECT AVG(salary)
    FROM Employee e2
    WHERE e1.city = e2.city
);

-- 5. List the departments that have more than 3 employees
select department,count(*) 
from Employee
group by department
having count(*)>3;

-- 6. Find employees who belong to cities with more than 5 employees
select name,city,Emp_count from(
select *,row_number() over(partition by city) as Emp_count from Employee)x where Emp_count>3;

select name , city from Employee
where city in(
select city
from Employee
group by city
having count(*)>5
);

-- Find employees with a salary above the department average
select * from
(select *,avg(salary) over(partition by department ) as dept_avg 
from Employee)x
where salary>dept_avg;

select name,salary,department from Employee e1 where salary>
(select avg(salary) from Employee e2 where e1.department = e2.department
);

SELECT name, department, salary
FROM Employee e1
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee e2
    WHERE e1.department = e2.department
);

--  Find cities where the total salary exceeds 200,000
select city from Employee
group by city
having sum(salary)>200000;

-- 10. Find the employee(s) with the second-highest salary
select * from Employee 
where salary =(
	select max(salary)
	from Employee
	where salary <(
		select max(salary) 
        from Employee
        where salary<(select max(salary) from Employee)
        )
);

-- Find the names of employees in the same department as "Alice"
select name from employee
where department = (select department from Employee where name = 'Alice');

-- List departments with total salaries greater than their city’s average total salary
WITH dept_totals AS (
    SELECT city,
           department,
           SUM(salary) AS total_salary
    FROM Employee
    GROUP BY city, department
)
SELECT department
FROM (
    SELECT *,
           AVG(total_salary) OVER(PARTITION BY city) AS city_avg_total
    FROM dept_totals
) x
WHERE total_salary > city_avg_total;




SELECT department, SUM(salary) AS total_department_salary
FROM Employee e1
GROUP BY department
HAVING SUM(salary) > (
    SELECT AVG(total_salary)
    FROM (
        SELECT city, SUM(salary) AS total_salary
        FROM Employee
        GROUP BY city
    ) AS CitySalaries
);

-- Find employees earning more than the average salary in their city
select * 
from Employee e1
where salary >(
	select avg(salary)
    from Employee e2
    where e1.city = e2.city
);

-- List the departments with at least 2 employees earning above 80,000
select department 
from Employee
where salary>80000
group by department
having count(*)>=2;

-- Find employees whose salary is above the overall average salary
select * from Employee
where salary >(
	select avg(salary) from Employee
);

-- Find employees who earn less than the minimum salary of the IT department
select name,salary from Employee
where salary<(
	select min(salary) as dept_min_sal
    from Employee
    where department = 'IT'
);

-- top 3 salaries from table
select distinct salary
from Employee
order by salary desc
limit 3;

-- lowest 3 salaries
select distinct salary
from Employee
order by salary asc
limit 3;

-- dense_rank
-- Query to Find the Top Salary Using DENSE_RANK()
SELECT name, salary
FROM (
    SELECT name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rank1
    FROM Employee
) ranked_salaries
WHERE rank1 = 1;
-- Explanation:

    -- DENSE_RANK() OVER (ORDER BY salary DESC):
    --    This assigns a rank to each employee based on their salary in descending order.
    --    If multiple employees have the same salary, they are given the same rank.

   -- ranked_salaries Subquery:
    --    Adds a new column, rank, showing the dense rank of each employee.

  --  WHERE rank = 1:
      --  Filters the rows where the rank is 1, which corresponds to the top salary.

select name,salary 
from(
select name, salary, dense_rank() over (order by salary desc)
as ranks 
from employee
)ranks
limit 3;

-- Find the second lowest salary in the entire table
select salary from(select salary,dense_rank() over (order by salary asc) as ranks from Employee)ranks where ranks=2;

-- Find Employees Earning More Than the Average Salary in Their Department


select name,salary,department from Employee e1 where salary>
(select avg(salary) from Employee e2 where e1.department = e2.department);

select * from Employee;
