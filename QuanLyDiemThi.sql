-- AUTORIDE - CƠ SỞ DỮ LIỆU ĐÃ NÂNG CẤP
-- Chạy toàn bộ file một lần từ đầu đến cuối.

DROP DATABASE IF EXISTS autoride_db;
CREATE DATABASE autoride_db;
USE autoride_db;

-- =========================================================
-- PHẦN 1: CẤU TRÚC CŨ (LEGACY)
-- =========================================================
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    status VARCHAR(50) DEFAULT 'BOOKED',
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

-- =========================================================
-- PHẦN 2: DDL NÂNG CẤP
-- =========================================================

-- 2.1. Khóa chặt vòng đời hợp đồng bằng ENUM
ALTER TABLE Rentals
    MODIFY COLUMN status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED')
    NOT NULL DEFAULT 'BOOKED';

-- 2.2. Thêm các cột tài chính (DECIMAL để không sai số, mặc định 0 để tránh NULL khi tính)
ALTER TABLE Rentals
    ADD COLUMN security_deposit DECIMAL(10, 2) NOT NULL DEFAULT 0,
    ADD COLUMN late_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
    ADD COLUMN damage_fee DECIMAL(10, 2) NOT NULL DEFAULT 0;

-- 2.3. Bảng biên bản kiểm tra xe (quan hệ 1-N: một hợp đồng có thể có nhiều biên bản)
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- =========================================================
-- PHẦN 3: DML MÔ PHỎNG KỊCH BẢN
-- =========================================================

-- 3.1. Thêm một xe
INSERT INTO Cars (model_name, license_plate)
VALUES ('Toyota Vios', '20A-123.45');

-- 3.2. Nguyen Van A thuê xe, đóng cọc 10.000.000 VNĐ, trạng thái ACTIVE
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', '2026-10-01 09:00:00', 'ACTIVE', 10000000);

-- 3.3. Khách trả xe, nhân viên kiểm tra phát hiện vỡ đèn pha
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, '2026-10-03 09:00:00', 'Vỡ đèn pha trái', 'Tran Thi B');

-- 3.4. Chốt hợp đồng: COMPLETED, không trễ, phí sửa chữa 2.000.000 VNĐ
UPDATE Rentals
SET status = 'COMPLETED',
    return_date = '2026-10-03 09:00:00',
    late_fee = 0,
    damage_fee = 2000000
WHERE rental_id = 1;

-- 3.5. Tính số tiền thực tế hoàn trả cho khách (kết quả mong đợi: 8000000.00)
SELECT r.rental_id,
       r.customer_name,
       r.status,
       r.security_deposit,
       r.late_fee,
       r.damage_fee,
       r.security_deposit - r.late_fee - r.damage_fee AS refund_amount
FROM Rentals r
WHERE r.rental_id = 1;
