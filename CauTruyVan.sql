USE SHOP1;
GO


/*-----------------------------------------------------------
1. Tổng số lượng tồn kho của từng kho
-----------------------------------------------------------*/
SELECT 
    sl.location_id,
    sl.name AS location_name,
    SUM(i.quantity) AS total_quantity
FROM INVENTORY i
JOIN STOCK_LOCATION sl ON sl.location_id = i.location_id
GROUP BY sl.location_id, sl.name;


/*-----------------------------------------------------------
2. Top 5 sản phẩm bán chạy nhất
-----------------------------------------------------------*/
SELECT TOP 5 
    p.product_name,
    SUM(sd.quantity) AS total_sold
FROM SALES_DETAIL sd
JOIN SALES_ORDER so 
    ON sd.order_id = so.order_id 
    AND so.status = 'Completed'
JOIN PRODUCT_VARIANT pv ON sd.variant_id = pv.variant_id
JOIN PRODUCT p ON pv.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;


/*-----------------------------------------------------------
3. Doanh thu theo từng cửa hàng
-----------------------------------------------------------*/
SELECT 
    sl.location_id,
    sl.name,
    SUM(so.total_amount) AS revenue
FROM SALES_ORDER so
JOIN STOCK_LOCATION sl ON so.location_id = sl.location_id
WHERE so.status = 'Completed'
GROUP BY sl.location_id, sl.name;


/*-----------------------------------------------------------
4. Doanh thu mỗi ngày
-----------------------------------------------------------*/
SELECT 
    order_date,
    SUM(total_amount) AS daily_revenue
FROM SALES_ORDER
WHERE status = 'Completed'
GROUP BY order_date
ORDER BY order_date;


/*-----------------------------------------------------------
5. Tồn kho chi tiết từng sản phẩm ở mỗi kho
-----------------------------------------------------------*/
SELECT 
    sl.name AS location_name,
    pv.sku,
    pv.color,
    pv.size,
    i.quantity
FROM INVENTORY i
JOIN PRODUCT_VARIANT pv ON i.variant_id = pv.variant_id
JOIN STOCK_LOCATION sl ON i.location_id = sl.location_id
ORDER BY sl.location_id, pv.variant_id;


/*-----------------------------------------------------------
6. Tổng nhập của mỗi sản phẩm (variant)
-----------------------------------------------------------*/
SELECT 
    pv.variant_id,
    pv.sku,
    SUM(id.quantity) AS total_imported
FROM IMPORT_DETAIL id
JOIN PRODUCT_VARIANT pv ON id.variant_id = pv.variant_id
GROUP BY pv.variant_id, pv.sku;


/*-----------------------------------------------------------
7. Tổng xuất kho (transfer đi) theo từng kho
-----------------------------------------------------------*/
SELECT 
    st.from_location,
    sl.name,
    SUM(std.quantity) AS total_transfer_out
FROM STOCK_TRANSFER_DETAIL std
JOIN STOCK_TRANSFER st ON std.transfer_id = st.transfer_id
JOIN STOCK_LOCATION sl ON st.from_location = sl.location_id
GROUP BY st.from_location, sl.name;


/*-----------------------------------------------------------
8. Khách hàng mua nhiều nhất
-----------------------------------------------------------*/
SELECT 
    c.customer_id,
    CONCAT(c.fname, ' ', c.lname) AS fullname,
    SUM(so.total_amount) AS total_spent
FROM SALES_ORDER so
JOIN CUSTOMER c ON so.customer_id = c.customer_id
WHERE so.status = 'Completed'
GROUP BY c.customer_id, c.fname, c.lname
ORDER BY total_spent DESC;


/*-----------------------------------------------------------
9. Lợi nhuận theo từng sản phẩm
   (Retail_price – Import_price) × quantity
-----------------------------------------------------------*/
SELECT 
    p.product_name,
    SUM((sd.unit_price - pv.import_price) * sd.quantity) AS profit
FROM SALES_DETAIL sd
JOIN SALES_ORDER so 
    ON sd.order_id = so.order_id 
    AND so.status = 'Completed'
JOIN PRODUCT_VARIANT pv ON sd.variant_id = pv.variant_id
JOIN PRODUCT p ON pv.product_id = p.product_id
GROUP BY p.product_name;


/*-----------------------------------------------------------
10. Nhân viên tạo nhiều đơn bán nhất
-----------------------------------------------------------*/
SELECT 
    e.employee_id,
    CONCAT(e.fname, ' ', e.lname) AS employee_name,
    COUNT(*) AS total_orders
FROM SALES_ORDER so
JOIN EMPLOYEE e ON so.employee_id = e.employee_id
WHERE so.status = 'Completed'
GROUP BY e.employee_id, e.fname, e.lname
ORDER BY total_orders DESC;
