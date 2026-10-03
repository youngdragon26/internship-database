# Nhật ký trao đổi với AI

Công cụ: Claude. Ngày: 03/10/2026.

| STT | Nội dung trao đổi | Tóm tắt câu trả lời của AI | Cách áp dụng |
|---|---|---|---|
| 1 | Gửi đề bài cho AI | AI nhắc quy tắc của đề (không nhờ AI viết sẵn đáp án), rồi giải thích theo các câu hỏi gợi ý trong đề | Dùng để hiểu nguyên nhân lỗi |
| 2 | `JOIN` mặc định trong MySQL hoạt động thế nào | Là `INNER JOIN`, chỉ giữ dòng khớp ở cả hai bảng, nên Charlie bị loại và điều kiện `IS NULL` luôn sai | Xác định nguyên nhân của lỗi 1 và lỗi 2 |
| 3 | `COUNT(*)` hay `COUNT(cột)` khi dùng `LEFT JOIN` | `COUNT(*)` đếm dòng nên khách chưa mua ra 1; `COUNT(o.order_id)` bỏ qua `NULL` nên ra 0 | Dùng `COUNT(o.order_id)` trong báo cáo 1 |
| 4 | `LEFT JOIN ... IS NULL` so với `NOT IN` | Từ MySQL 8.0 cả hai thường được tối ưu thành anti-join; `NOT IN` trả về rỗng nếu subquery có `NULL` | Chọn `LEFT JOIN ... IS NULL` cho báo cáo 2 |
| 5 | Giả lập `FULL OUTER JOIN` trong MySQL | Dùng `LEFT JOIN ... UNION ... RIGHT JOIN` | Kiến thức mở rộng |
| 6 | MySQL thực hiện JOIN bằng thuật toán gì | Nested-Loop Join: duyệt từng dòng bảng ngoài, tìm dòng khớp ở bảng trong, nhanh khi có index; từ 8.0.18 có hash join khi không có index | Kiến thức mở rộng |
| 7 | `RIGHT JOIN` giữ nguyên thứ tự bảng, và Cross Join là gì | `RIGHT JOIN` giữ toàn vẹn bảng Orders nên Charlie lại mất; Cross Join xảy ra khi thiếu điều kiện `ON`, số dòng bằng tích hai bảng | Chuẩn bị vấn đáp |
| 8 | Nhờ AI tạo 3 file nộp bài | AI viết 3 file và lưu ý script chưa được chạy thử | Chạy lại trên MySQL, chụp Result Grid |
