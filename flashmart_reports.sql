-- HỆ THỐNG FLASHMART - BÁO CÁO ĐÃ SỬA
-- Chạy toàn bộ file một lần từ đầu đến cuối.

DROP DATABASE IF EXISTS flashmart_db;
CREATE DATABASE flashmart_db;
USE flashmart_db;

-- 1. Tạo bảng và chèn dữ liệu mẫu
CREATE TABLE Customers (customer_id INT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(50));
CREATE TABLE Orders (order_id INT PRIMARY KEY, customer_id INT, product_id INT);

INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie');
-- Charlie chưa từng mua hàng

INSERT INTO Products VALUES (101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard');
-- Keyboard chưa từng được ai mua

INSERT INTO Orders VALUES (1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- ========================================================
-- BÁO CÁO 1: Marketing - tất cả khách hàng kèm số đơn hàng
-- Sửa: JOIN (INNER) -> LEFT JOIN để giữ khách chưa mua.
-- COUNT(o.order_id) bỏ qua NULL nên Charlie ra 0.
-- Kết quả mong đợi: Alice 2, Bob 1, Charlie 0.
-- ========================================================
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- BÁO CÁO 2: Kho vận - sản phẩm chưa từng được bán (Anti-Join)
-- Sửa: JOIN (INNER) -> LEFT JOIN, giữ điều kiện IS NULL.
-- Kết quả mong đợi: (103, 'Keyboard').
-- ========================================================
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
