CREATE DATABASE Task5DB;
USE Task5DB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (customer_name, city) VALUES
('Raghav', 'Pune'),
('Atharva', 'Mumbai'),
('Nilesh', 'Delhi'),
('Omkar', 'Chennai');

INSERT INTO Orders (order_date, amount, customer_id) VALUES
('2025-09-01', 5000, 1),
('2025-09-03', 2500, 2),
('2025-09-05', 3000, 1),
('2025-09-07', 1500, NULL); 

select * from Customers;
select * from Orders;

-- INNER JOIN
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- LEFT JOIN
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;

-- FULL JOIN 
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;

-- Task 6:

-- 1. Scalar Subquery
-- Find orders along with the name of the customer who spent the most in a single order.

SELECT order_id, amount,
       (SELECT customer_name 
        FROM Customers c 
        WHERE c.customer_id = o.customer_id) AS customer_name,
       (SELECT MAX(amount) FROM Orders) AS max_order_amount
FROM Orders o;

-- 2. Correlated Subquery
-- Find customers whose orders are above the average order amount for that customer.
SELECT customer_name, order_id, amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE amount > (
    SELECT AVG(amount)
    FROM Orders o2
    WHERE o2.customer_id = c.customer_id
);

-- 3. Subquery inside IN
-- Get customers who have placed orders with amounts greater than 3000.
SELECT customer_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE amount > 3000
);

-- 4. Subquery inside EXISTS
-- Find customers who have placed at least one order.
SELECT customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);

-- 5. Subquery inside =
-- Find customer name for a specific order (order_id = 3).
SELECT customer_name
FROM Customers
WHERE customer_id = (
    SELECT customer_id
    FROM Orders
    WHERE order_id = 3
);

select * from Customers;

-- task 7:

-- complex select:
CREATE VIEW CustomerOrderSummary AS
SELECT c.customer_name, COUNT(o.order_id) AS total_orders, SUM(o.amount) AS total_amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

SELECT * FROM CustomerOrderSummary;

-- abstraction and security

CREATE VIEW CustomerOrders AS
SELECT c.customer_name, o.amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

SELECT * FROM CustomerOrders;