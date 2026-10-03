-- HỆ THỐNG PAYFLOW - TRUY VẤN ĐÃ TỐI ƯU
-- Chạy toàn bộ file một lần từ đầu đến cuối (mất khoảng vài chục giây vì sinh 200.000 dòng).

DROP DATABASE IF EXISTS payflow_db;
CREATE DATABASE payflow_db;
USE payflow_db;

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- ========================================================
-- PHẦN 1: SINH DỮ LIỆU GIẢ LẬP (200.000 dòng, năm 2025-2026)
-- Bảng thật có 5 triệu dòng; 200.000 dòng đủ để EXPLAIN cho thấy khác biệt.
-- ========================================================
INSERT INTO Transactions (user_id, amount, transaction_type, created_at)
SELECT FLOOR(1 + RAND() * 10000),
       ROUND(10000 + RAND() * 5000000, 2),
       ELT(1 + FLOOR(RAND() * 3), 'DEPOSIT', 'WITHDRAW', 'TRANSFER'),
       '2025-01-01 00:00:00' + INTERVAL FLOOR(RAND() * 730 * 86400) SECOND
FROM (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) e
CROSS JOIN (SELECT 0 n UNION ALL SELECT 1) f;

ANALYZE TABLE Transactions;

-- ========================================================
-- PHẦN 2: TRUY VẤN CŨ (Non-SARGable) - EXPLAIN TRƯỚC KHI CÓ INDEX
-- Mong đợi: type = ALL, key = NULL, rows xấp xỉ toàn bộ bảng.
-- ========================================================
EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;

-- ========================================================
-- PHẦN 3: TẠO COMPOSITE INDEX
-- transaction_type đứng trước vì được so sánh bằng (=),
-- created_at đứng sau vì được so sánh theo khoảng (>=, <).
-- ========================================================
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- ========================================================
-- PHẦN 4: TRUY VẤN MỚI (SARGable) - EXPLAIN SAU KHI CÓ INDEX
-- Bỏ YEAR() và MONTH(), thay bằng khoảng thời gian.
-- Mong đợi: type = range, key = idx_type_date, rows giảm mạnh.
-- ========================================================
EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- ========================================================
-- PHẦN 5: ĐỐI CHIẾU KẾT QUẢ TÀI CHÍNH
-- Hai câu phải trả về cùng một tổng tiền.
-- ========================================================
SELECT SUM(amount) AS total_deposit_old
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;

SELECT SUM(amount) AS total_deposit_new
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';
