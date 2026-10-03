# So sánh EXPLAIN trước và sau khi tối ưu

| Chỉ số | Truy vấn cũ | Truy vấn mới |
|---|---|---|
| `type` | `ALL` | `range` |
| `possible_keys` | `NULL` | `idx_type_date` |
| `key` | `NULL` | `idx_type_date` |
| `rows` | [ĐIỀN SỐ TỪ KẾT QUẢ CHẠY] | [ĐIỀN SỐ TỪ KẾT QUẢ CHẠY] |

**Truy vấn cũ** bọc cột `created_at` trong hàm `YEAR()` và `MONTH()`. MySQL phải tính hàm cho từng dòng rồi mới so sánh, nên không dùng được index (Non-SARGable). Kết quả là `type = ALL`: quét toàn bộ bảng.

**Truy vấn mới** so sánh trực tiếp cột `created_at` với một khoảng thời gian (`>=` ngày đầu tháng và `<` ngày đầu tháng sau). Kết hợp với composite index `(transaction_type, created_at)`, MySQL nhảy thẳng tới nhóm `DEPOSIT` trong cây B-Tree rồi chỉ đọc các dòng thuộc tháng 6/2026. Kết quả là `type = range` và số dòng ở cột `rows` giảm mạnh.

Hai truy vấn trả về cùng một tổng tiền, nên việc tối ưu không làm sai lệch kết quả tài chính.
