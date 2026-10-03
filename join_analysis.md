# Vì sao dùng `COUNT(o.order_id)` thay vì `COUNT(*)`

Báo cáo Marketing dùng `LEFT JOIN` từ `Customers` sang `Orders` để giữ cả khách chưa mua hàng. Với khách không có đơn nào (Charlie), `LEFT JOIN` vẫn trả về một dòng, trong đó các cột của `Orders` là `NULL`.

- `COUNT(*)` đếm số dòng, không quan tâm giá trị. Charlie có một dòng nên kết quả là 1, tức là báo sai rằng Charlie đã mua một đơn.
- `COUNT(o.order_id)` chỉ đếm giá trị khác `NULL`. Dòng của Charlie có `order_id` là `NULL` nên kết quả là 0, đúng thực tế.

`order_id` là khóa chính của `Orders` nên nó chỉ `NULL` khi không có đơn hàng khớp. Vì vậy đếm cột này cho đúng số đơn của từng khách, và Marketing xác định đúng nhóm nhận voucher.
