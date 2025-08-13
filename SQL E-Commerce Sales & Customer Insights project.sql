CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    country VARCHAR(50),
    registration_date DATE
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order Details Table
CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Returns Table
CREATE TABLE Returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    return_date DATE,
    reason VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


USE ecommerce_db;

-- Customers
INSERT INTO Customers (customer_name, email, city, country, registration_date) VALUES
('John Doe', 'john@example.com', 'New York', 'USA', '2021-01-15'),
('Jane Smith', 'jane@example.com', 'London', 'UK', '2021-03-10'),
('Raj Kumar', 'raj@example.com', 'Mumbai', 'India', '2021-04-20'),
('Maria Lopez', 'maria@example.com', 'Madrid', 'Spain', '2021-06-12'),
('Ahmed Ali', 'ahmed@example.com', 'Dubai', 'UAE', '2021-08-05');

-- Products
INSERT INTO Products (product_name, category, price) VALUES
('Laptop Pro 15', 'Electronics', 1500.00),
('Wireless Mouse', 'Electronics', 25.00),
('Office Chair', 'Furniture', 200.00),
('Coffee Maker', 'Appliances', 80.00),
('Gaming Keyboard', 'Electronics', 120.00);

-- Orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2021-09-10', 1525.00),
(2, '2021-09-12', 200.00),
(3, '2021-09-15', 80.00),
(4, '2021-09-18', 1620.00),
(5, '2021-09-20', 145.00);

-- Order Details
INSERT INTO Order_Details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1500.00),
(1, 2, 1, 25.00),
(2, 3, 1, 200.00),
(3, 4, 1, 80.00),
(4, 1, 1, 1500.00),
(4, 5, 1, 120.00),
(5, 2, 1, 25.00),
(5, 5, 1, 120.00);

-- Payments
INSERT INTO Payments (order_id, payment_date, payment_method, amount) VALUES
(1, '2021-09-10', 'Credit Card', 1525.00),
(2, '2021-09-12', 'PayPal', 200.00),
(3, '2021-09-15', 'Cash', 80.00),
(4, '2021-09-18', 'Credit Card', 1620.00),
(5, '2021-09-20', 'Debit Card', 145.00);

-- Returns
INSERT INTO Returns (order_id, product_id, return_date, reason) VALUES
(5, 5, '2021-09-25', 'Defective product');

-- 1. Total Sales by Month
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS total_sales
FROM Orders
GROUP BY month
ORDER BY month;

-- 2. Top 5 Best-Selling Products
SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- 3. Top Customers by Spending
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 4. Repeat Customers
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING total_orders > 1;

-- 5. Return Rate by Product
SELECT p.product_name,
       COUNT(r.return_id) AS total_returns,
       COUNT(od.order_detail_id) AS total_sold,
       ROUND((COUNT(r.return_id) / COUNT(od.order_detail_id)) * 100, 2) AS return_rate_percentage
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
LEFT JOIN Returns r ON od.order_id = r.order_id AND od.product_id = r.product_id
GROUP BY p.product_name;

