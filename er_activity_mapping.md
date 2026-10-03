# Vì sao cột `damage_fee` là bắt buộc

Trong Activity Diagram của quy trình trả xe có nhánh rẽ "xe bị trầy xước/hư hỏng". Nhánh này sinh ra một khoản tiền là phí sửa chữa, và khoản đó nằm trong công thức:

**Tiền hoàn lại = Tiền cọc − Phí phạt trễ − Phí sửa chữa**

Nếu bảng `Rentals` không có cột `damage_fee`, công thức thiếu một số hạng. Hệ thống chỉ có thể hoàn đủ tiền cọc, hoặc nhân viên phải ghi tay ra sổ. Đây chính là nguyên nhân khiến AutoRide thất thoát lợi nhuận.

Cột này còn cần cho tính toàn vẹn dữ liệu:

- Kiểu `DECIMAL(10, 2)` giữ chính xác số tiền, không sai số như `FLOAT`.
- `NOT NULL DEFAULT 0` bảo đảm phép trừ không trả về `NULL` khi xe không hư hỏng.
- Số tiền trong `damage_fee` đi cùng mô tả lỗi trong bảng `Inspections`, nên mỗi khoản khấu trừ đều có bằng chứng đối chiếu.

Tóm lại, mỗi nhánh rẽ của quy trình nghiệp vụ phải có chỗ lưu dữ liệu tương ứng trong ERD. `damage_fee` là chỗ lưu của nhánh "xe hư hỏng".
