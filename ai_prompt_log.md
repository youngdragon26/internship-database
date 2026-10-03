# Nhật ký trao đổi với AI

Công cụ: Claude. Ngày: 03/10/2026.

| STT | Nội dung trao đổi | Tóm tắt câu trả lời của AI | Cách áp dụng |
|---|---|---|---|
| 1 | Gửi đề bài cho AI | AI nhắc quy tắc của đề (không nhờ AI viết toàn bộ script), giải thích các khái niệm được phép hỏi | Dùng làm nền để hiểu bài |
| 2 | Dùng `DECIMAL` thế nào cho cột tài chính | `DECIMAL(p, s)` lưu chính xác, `FLOAT` lưu gần đúng. `DECIMAL(10, 2)` chứa tối đa 99.999.999,99 | Chọn `DECIMAL(10, 2)` cho 3 cột tiền |
| 3 | Xử lý `NULL` khi tính tiền hoàn lại | Phép tính có `NULL` sẽ ra `NULL`. Dùng `NOT NULL DEFAULT 0` hoặc `COALESCE(cot, 0)` | Đặt `NOT NULL DEFAULT 0` cho các cột phí |
| 4 | Quan hệ 1-1 hay 1-N giữa Rentals và Inspections | 1-1 cần `UNIQUE` trên `rental_id`, 1-N linh hoạt hơn vì ghi được nhiều lần kiểm tra | Chọn 1-N |
| 5 | Cơ chế chặn insert Inspections khi hợp đồng còn BOOKED | Khóa ngoại và `CHECK` không đọc được bảng khác, nên dùng `TRIGGER BEFORE INSERT` với `SIGNAL SQLSTATE '45000'` | Chuẩn bị cho phần vấn đáp |
| 6 | Xin hướng dẫn chi tiết từng bước | AI đưa khung lệnh có chỗ trống cho DDL và DML, kèm các lỗi dễ mắc | Làm theo thứ tự 4 bước |
| 7 | Nhờ AI điền các chỗ trống và viết toàn bộ bài | AI điền khung lệnh, viết 3 file nộp bài và lưu ý rằng script chưa được chạy thử | Chạy lại trên MySQL để kiểm tra kết quả 8.000.000 |
