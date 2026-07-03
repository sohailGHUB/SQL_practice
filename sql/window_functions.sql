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

select * from Employee;

select name, department,salary,row_number() over(order by salary) as rn from Employee;

select name,salary,rank() over(order by salary desc) as rnk from Employee;

select name,department,salary,lag(salary) over(order by salary desc) as prv from Employee;
select name,department,salary,lag(salary) over(partition by department order by salary desc) as prv from Employee;


select name,salary,sum(salary) over(order by name ) as s from Employee;

select name,department,salary,avg(salary) over (partition by department order by name) as avgg from Employee;

select department,salary from 
	(select * ,dense_rank() over(partition by department order by salary desc) as rnk From Employee)x 
 where rnk<=2;
 