use fa2;
-- Location Table
CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(50)
);

-- Manager Table
CREATE TABLE Manager (
    manager_id INT PRIMARY KEY,
    manager_name VARCHAR(50)
);

-- Vehicle Table
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    vehicle_type VARCHAR(30),
    vehicle_no VARCHAR(20)
);

-- Dept Table
CREATE TABLE Dept (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- Emp Table (with salary and doj)
CREATE TABLE Emp (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    manager_id INT,
    vehicle_id INT,
    salary DECIMAL(10,2),
    doj DATE,
    FOREIGN KEY (dept_id) REFERENCES Dept(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Manager(manager_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

INSERT INTO Location VALUES
(1, 'New York'), (2, 'San Francisco'), (3, 'Los Angeles'),
(4, 'Chicago'), (5, 'Boston'), (6, 'Seattle'),
(7, 'Austin'), (8, 'Denver'), (9, 'Miami'), (10, 'Dallas');

INSERT INTO Manager VALUES
(1, 'Alice Johnson'), (2, 'Bob Smith'), (3, 'Charlie Davis'),
(4, 'Diana Prince'), (5, 'Ethan Hunt'), (6, 'Fiona Clark'),
(7, 'George Wilson'), (8, 'Hannah Brown'), (9, 'Ian Scott'), (10, 'Julia Roberts');

INSERT INTO Vehicle VALUES
(1, 'Car', 'NYC123'), (2, 'Bike', 'SF987'), (3, 'Car', 'LA555'),
(4, 'Bike', 'CHI321'), (5, 'Car', 'BOS789'), (6, 'Car', 'SEA654'),
(7, 'Bike', 'AUS432'), (8, 'Car', 'DEN876'), (9, 'Car', 'MIA555'), (10, 'Bike', 'DAL987'),
(11, 'Car', 'NYC777'), (12, 'Bike', 'SF654'), (13, 'Car', 'LA777'), (14, 'Car', 'CHI999'), (15, 'Bike', 'AUS111');

INSERT INTO Dept VALUES
(1, 'HR', 1), (2, 'Finance', 2), (3, 'IT', 3), (4, 'Marketing', 4), (5, 'Operations', 5),
(6, 'Sales', 6), (7, 'Legal', 7), (8, 'Engineering', 8), (9, 'Support', 9), (10, 'R&D', 10);

INSERT INTO Emp VALUES
(101, 'John Doe', 1, 1, 1, 55000.00, '2020-01-15'),
(102, 'Jane Smith', 2, 2, 2, 62000.00, '2019-03-10'),
(103, 'Michael Brown', 3, 3, 3, 75000.00, '2018-07-22'),
(104, 'Emily Davis', 4, 4, 4, 58000.00, '2021-11-05'),
(105, 'Daniel Wilson', 5, 5, 5, 67000.00, '2020-06-18'),
(106, 'Olivia Harris', 6, 6, 6, 71000.00, '2019-09-30'),
(107, 'James Martinez', 7, 7, 7, 54000.00, '2021-02-14'),
(108, 'Sophia Anderson', 8, 8, 8, 80000.00, '2017-05-25'),
(109, 'David Taylor', 9, 9, 9, 60000.00, '2022-03-12'),
(110, 'Emma Thomas', 10, 10, 10, 83000.00, '2018-12-01'),
(111, 'Chris Johnson', 3, 1, 11, 76000.00, '2019-08-09'),
(112, 'Laura Lee', 2, 2, 12, 59000.00, '2020-10-21'),
(113, 'Kevin White', 4, 3, 13, 62000.00, '2021-07-17'),
(114, 'Rachel Green', 1, 4, 14, 57000.00, '2019-04-05'),
(115, 'Peter Parker', 5, 5, 15, 69000.00, '2022-01-30');

select *from Emp;
select *from Dept;
select *from Vehicle;
select *from Manager;
select *from Location;
