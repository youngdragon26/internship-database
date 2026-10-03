# Nhật ký trao đổi với AI

Công cụ: Claude. Ngày: 03/10/2026.

| STT | Nội dung trao đổi | Tóm tắt câu trả lời của AI | Cách áp dụng |
|---|---|---|---|
| 1 | Gửi đề bài cho AI | AI tạo 3 file nộp bài theo các bước đề đã hướng dẫn, kèm script sinh dữ liệu giả lập, và lưu ý script chưa được chạy thử | Chạy lại trên MySQL, điền số `rows` thực tế vào bản phân tích |
| 2 | Vì sao `WHERE YEAR(col) = 2026` không dùng được index | Index lưu giá trị gốc của cột theo thứ tự. Khi bọc hàm, MySQL phải tính hàm cho từng dòng nên không tìm kiếm trên cây B-Tree được (Non-SARGable) | Thay bằng điều kiện khoảng `>=` và `<` |
| 3 | Thứ tự cột trong composite index có quan trọng không | Có. Cột so sánh bằng (`=`) đặt trước, cột so sánh khoảng đặt sau, vì index chỉ dùng được liên tục từ trái sang tới cột khoảng đầu tiên | Tạo index `(transaction_type, created_at)` |
| 4 | Ý nghĩa các giá trị cột `type` của EXPLAIN | `ALL` quét cả bảng; `index` quét cả index; `range` đọc một khoảng của index; `ref` tra theo giá trị bằng trên index không duy nhất; `const` tra một dòng theo khóa chính | Đọc kết quả EXPLAIN |
| 5 | "Using index condition" khác "Using index" thế nào | "Using index condition" là lọc bằng index rồi vẫn đọc dòng trong bảng; "Using index" là covering index, đủ dữ liệu ngay trong index nên không cần đọc bảng | Hiểu cột Extra |
| 6 | Cách xem thời gian thực thi | `SET profiling = 1` rồi `SHOW PROFILES`, hoặc `EXPLAIN ANALYZE` từ MySQL 8.0.18 | Đo thời gian trước và sau |
