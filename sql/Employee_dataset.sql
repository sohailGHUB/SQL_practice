use fa2;
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
select * from Employee;

-- aaise employees jinke dept ki avg salary>70000 hai 
-- List employees in departments where the average salary is above 70,000 (sub query inside IN should contain only one column)
select * from Employee where department in (select department
from Employee group by department having avg(salary)>70000); 

-- select employees with highest salaries
select * from Employee where salary=(select max(salary) from Employee); 

-- Find employees earning less than the average salary of their city
select * from Employee e where salary < (select avg(salary)  from Employee where city=e.city  );
SELECT name, salary, city
FROM Employee e1
WHERE salary < (
    SELECT AVG(salary)
    FROM Employee e2
    WHERE e1.city = e2.city
);

-- Find employees earning less than the average salary of their department
select * from Employee e1 where salary<(select avg(salary) from Employee e2 where e1.department=e2.department);
select * from Employee e join(select department,round(avg(salary),2) as avgSal from Employee  group by department) d 
on e.department=d.department where e.salary<d.avgSal;

-- 5. List the departments that have more than 3 employees
select department,count(*) as c from Employee group by department having c>3;

-- 6. Find employees who belong to cities with more than 4 employees
select * from Employee;
select *  from Employee where city in (select city from Employee group by city having count(*)>4);

-- Find employees with a salary above the department average
select * from Employee e1 where salary >(select avg(salary) from Employee e2 where e1.department=e2.department);

-- Find cities where the total salary exceeds 200,000
select city,sum(salary) as s from Employee group by city having s>200000;

-- 10. Find the employee(s) with the second-highest salary
select * from Employee where salary = (select max(salary) from Employee where salary<(select max(salary) from Employee));

-- emps with third max salary
select * from Employee where salary = (select max(salary) from Employee where salary<(select max(salary) from Employee 
where salary<(select max(salary) from Employee) ));

--  List departments with total salaries greater than their city’s average total salary, (har city  ki total salary nikalke divide each total by no.of cities to get city's avg total salary)
select *from Employee;
with cityTotal as (select city,sum(salary) as cityTotalSal from Employee group by city),
avgCityTotal as (select avg(cityTotalSal) as avg_total_sal from cityTotal) 
select department,sum(salary) as s from Employee group by department having s>(select avg_total_sal from avgCityTotal);

-- Find the highest-paid employee in each city
select * from Employee e1 where salary =(select max(salary) from Employee e2 where e1.city=e2.city);

-- List cities where total salary is above the overall average salary
with cityTotalSal as(select city,sum(salary) as s from Employee group by city ),
avgCityTotal as(select avg(s) as a from cityTotalSal) 
select city,sum(salary) as s1 from Employee group by city having s1>(select a from avgCityTotal);

-- dept with max/highest total sal 
select department,sum(salary) as s from Employee group by department order by s desc limit 1;

-- List cities where more than 3 employees work
select city,count(*) as c from Employee group by city having c>3;

-- For each city, find the department that pays the highest total salary
WITH DeptCityTotals AS (
    SELECT city, department, SUM(salary) AS total_salary
    FROM Employee
    GROUP BY city, department
)
SELECT city, department, total_salary
FROM DeptCityTotals d1
WHERE total_salary = (
    SELECT MAX(total_salary)
    FROM DeptCityTotals d2
    WHERE d1.city = d2.city
);

-- Find the percentage contribution of each department to total salary (dept total X 100)/total sal
with totalTable as (select sum(salary) as grandTotal from Employee)
select department,round((sum(salary)*100)/(select grandTotal from totalTable),2) as contribution from Employee 
group by department;

-- 10. Find cities where the average salary of the Finance department is higher than overall Finance average

WITH FinanceAvg AS (
    SELECT AVG(salary) AS overall_finance_avg
    FROM Employee
    WHERE department = 'Finance'
),
CityFinanceAvg AS (
    SELECT city, AVG(salary) AS city_finance_avg
    FROM Employee
    WHERE department = 'Finance'
    GROUP BY city
)
SELECT city, city_finance_avg
FROM CityFinanceAvg
WHERE city_finance_avg > (SELECT overall_finance_avg FROM FinanceAvg);






