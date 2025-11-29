USE SHOP1;
GO


-- ============================================================
-- BƯỚC 1: MASTER DATA (DỮ LIỆU NỀN)
-- ============================================================

-- 1. BRAND (6 Hãng)
INSERT INTO BRAND (brand_id, name, origin) VALUES
(1, N'Việt Tiến', N'Việt Nam'),
(2, N'Owen', N'Việt Nam'),
(3, N'Coolmate', N'Việt Nam'),
(4, N'Uniqlo', N'Japan'),
(5, N'Zara', N'Spain'),
(6, N'Adidas', N'Germany');

-- 2. CATEGORY (8 Danh mục)
INSERT INTO CATEGORY (category_id, category_name, parent_id) VALUES
(1, N'Áo Nam', NULL),
(2, N'Quần Nam', NULL),
(3, N'Phụ Kiện', NULL),
(4, N'Áo Sơ Mi', 1),
(5, N'Áo Polo', 1),
(6, N'Áo Thun', 1),
(7, N'Quần Tây', 2),
(8, N'Quần Jean', 2);

-- 3. STOCK_LOCATION (3 Kho)
INSERT INTO STOCK_LOCATION (location_id, name, city, district, street) VALUES
(1, N'Kho Tổng Long Biên', N'Hà Nội', N'Long Biên', N'KCN Sài Đồng'),
(2, N'Cửa Hàng Cầu Giấy', N'Hà Nội', N'Cầu Giấy', N'234 Xuân Thủy'),
(3, N'Cửa Hàng Quận 1', N'HCM', N'Quận 1', N'68 Nguyễn Huệ');

-- 4. EMPLOYEE (6 Nhân viên)
INSERT INTO EMPLOYEE (employee_id, fname, mname, lname, phone, salary, location_id) VALUES
(1, N'Hùng', N'Văn', N'Nguyễn', '0901111111', 15000000, 1), -- Quản lý kho tổng
(2, N'Lan', N'Thị', N'Trần', '0902222222', 9000000, 1),  -- Thủ kho
(3, N'Tùng', N'Sơn', N'Lê', '0903333333', 8500000, 2),    -- Trưởng CH Cầu Giấy
(4, N'Mai', N'Thanh', N'Phạm', '0904444444', 7000000, 2), -- NV Cầu Giấy
(5, N'Nam', N'Hoàng', N'Võ', '0905555555', 8500000, 3),   -- Trưởng CH Q1
(6, N'Hương', N'Thu', N'Đặng', '0906666666', 7000000, 3); -- NV Q1

-- 5. SUPPLIER (4 Nhà cung cấp)
INSERT INTO SUPPLIER (supplier_id, name, phone) VALUES
(1, N'Xưởng May 10', '0243888999'),
(2, N'NPP Thời Trang Việt', '0283999888'),
(3, N'Kho Sỉ Quảng Châu', '0988777666'),
(4, N'Adidas Vietnam Distribution', '0285555444');

-- 6. CUSTOMER (5 Khách hàng)
INSERT INTO CUSTOMER (customer_id, fname, mname, lname, phone) VALUES
(1, N'Vãng', N'', N'Lai', '0000000000'),
(2, N'Sơn', N'Tùng', N'Nguyễn', '0912345678'),
(3, N'Linh', N'Khánh', N'Hoàng', '0987654321'),
(4, N'Đạt', N'Thành', N'Trần', '0999888777'),
(5, N'Trang', N'Thu', N'Lê', '0911222333');

-- ============================================================
-- BƯỚC 2: PRODUCT & VARIANT (20 BIẾN THỂ)
-- ============================================================

-- PRODUCT (5 Dòng sản phẩm)
INSERT INTO PRODUCT (product_id, product_name, status, brand_id, category_id) VALUES
(1, N'Áo Sơ Mi Trắng Công Sở', 'Active', 1, 4),  -- Việt Tiến, Sơ mi
(2, N'Quần Tây Âu Cao Cấp', 'Active', 2, 7),    -- Owen, Quần Tây
(3, N'Áo Polo Coolmate Basic', 'Active', 3, 5), -- Coolmate, Polo
(4, N'Áo Thun Uniqlo Airism', 'Active', 4, 6),  -- Uniqlo, Thun
(5, N'Quần Jean Slimfit Zara', 'Active', 5, 8); -- Zara, Jean

-- PRODUCT_VARIANT (20 Biến thể - Dữ liệu cốt lõi)
INSERT INTO PRODUCT_VARIANT (variant_id, product_id, sku, color, size, material, import_price, retail_price) VALUES
-- 1. Sơ mi Việt Tiến (4 biến thể)
(1, 1, 'SOMI-WH-39', N'Trắng', '39', 'Bamboo', 200000, 450000),
(2, 1, 'SOMI-WH-40', N'Trắng', '40', 'Bamboo', 200000, 450000),
(3, 1, 'SOMI-WH-41', N'Trắng', '41', 'Bamboo', 200000, 450000),
(4, 1, 'SOMI-BL-40', N'Xanh', '40', 'Bamboo', 210000, 480000),

-- 2. Quần Tây Owen (4 biến thể)
(5, 2, 'QUAN-BK-29', N'Đen', '29', 'Kaki', 250000, 550000),
(6, 2, 'QUAN-BK-30', N'Đen', '30', 'Kaki', 250000, 550000),
(7, 2, 'QUAN-BK-31', N'Đen', '31', 'Kaki', 250000, 550000),
(8, 2, 'QUAN-GY-30', N'Xám', '30', 'Kaki', 260000, 580000),

-- 3. Polo Coolmate (4 biến thể)
(9, 3, 'POLO-WH-M', N'Trắng', 'M', 'Cotton', 100000, 220000),
(10, 3, 'POLO-WH-L', N'Trắng', 'L', 'Cotton', 100000, 220000),
(11, 3, 'POLO-BK-M', N'Đen', 'M', 'Cotton', 100000, 220000),
(12, 3, 'POLO-BK-L', N'Đen', 'L', 'Cotton', 100000, 220000),

-- 4. Thun Uniqlo (4 biến thể)
(13, 4, 'UNI-WH-S', N'Trắng', 'S', 'Polyester', 150000, 300000),
(14, 4, 'UNI-WH-M', N'Trắng', 'M', 'Polyester', 150000, 300000),
(15, 4, 'UNI-GR-M', N'Xám', 'M', 'Polyester', 150000, 300000),
(16, 4, 'UNI-GR-L', N'Xám', 'L', 'Polyester', 150000, 300000),

-- 5. Jean Zara (4 biến thể)
(17, 5, 'JEAN-BL-30', N'Xanh', '30', 'Denim', 350000, 800000),
(18, 5, 'JEAN-BL-31', N'Xanh', '31', 'Denim', 350000, 800000),
(19, 5, 'JEAN-BK-30', N'Đen', '30', 'Denim', 360000, 850000),
(20, 5, 'JEAN-BK-31', N'Đen', '31', 'Denim', 360000, 850000);

-- SUPPLIER_PRODUCT (Liên kết giá nhập)
INSERT INTO SUPPLIER_PRODUCT (supplier_id, variant_id, supplier_price) VALUES
(1, 1, 190000), (1, 2, 190000), (1, 3, 190000), (1, 4, 200000), -- May 10 bán Sơ mi
(2, 5, 240000), (2, 6, 240000), (2, 7, 240000), (2, 8, 250000), -- NPP Việt bán Quần Tây
(1, 9, 95000), (1, 10, 95000), (1, 11, 95000), (1, 12, 95000),  -- May 10 bán Polo giá tốt
(3, 13, 140000), (3, 14, 140000), (3, 17, 340000);              -- Kho sỉ bán Uniqlo, Zara

-- ============================================================
-- BƯỚC 3: GIAO DỊCH NHẬP KHO (3 Phiếu lớn)
-- ============================================================

-- Phiếu 1: Nhập Sơ Mi & Quần Tây về Kho Tổng (Ngày 01/01)
INSERT INTO IMPORT_ORDER (import_id, import_date, total_amount, status, employee_id, supplier_id, location_id) 
VALUES (1, '2024-01-01', 19800000, 'Completed', 1, 1, 1);

INSERT INTO IMPORT_DETAIL (import_id, variant_id, quantity, unit_price) VALUES
(1, 1, 50, 190000), -- 50 Sơ mi 39
(1, 2, 50, 190000), -- 50 Sơ mi 40
(1, 5, 20, 240000); -- 20 Quần Tây 29

-- Phiếu 2: Nhập Polo & Thun về Kho Tổng (Ngày 05/01)
INSERT INTO IMPORT_ORDER (import_id, import_date, total_amount, status, employee_id, supplier_id, location_id) 
VALUES (2, '2024-01-05', 18500000, 'Completed', 1, 1, 1);

INSERT INTO IMPORT_DETAIL (import_id, variant_id, quantity, unit_price) VALUES
(2, 9, 100, 95000),  -- 100 Polo Trắng M
(2, 10, 100, 95000); -- 100 Polo Trắng L

-- Phiếu 3: Nhập Jean Zara trực tiếp về Cầu Giấy để khai trương (Ngày 10/01)
INSERT INTO IMPORT_ORDER (import_id, import_date, total_amount, status, employee_id, supplier_id, location_id) 
VALUES (3, '2024-01-10', 17000000, 'Completed', 3, 3, 2);

INSERT INTO IMPORT_DETAIL (import_id, variant_id, quantity, unit_price) VALUES
(3, 17, 50, 340000); -- 50 Quần Jean Xanh 30

-- ============================================================
-- BƯỚC 4: GIAO DỊCH CHUYỂN KHO (2 Phiếu)
-- ============================================================

-- Phiếu 1: Chuyển Sơ mi từ Kho Tổng (1) -> Cầu Giấy (2)
INSERT INTO STOCK_TRANSFER (transfer_id, from_location, to_location, transfer_date, received_date, status, employee_id) 
VALUES (1, 1, 2, '2024-02-01', '2024-02-02', 'Completed', 1);

INSERT INTO STOCK_TRANSFER_DETAIL (transfer_id, variant_id, quantity) VALUES
(1, 1, 20), -- Chuyển 20 Sơ mi 39
(1, 2, 20); -- Chuyển 20 Sơ mi 40

-- Phiếu 2: Chuyển Polo từ Kho Tổng (1) -> Quận 1 (3)
INSERT INTO STOCK_TRANSFER (transfer_id, from_location, to_location, transfer_date, received_date, status, employee_id) 
VALUES (2, 1, 3, '2024-02-01', '2024-02-03', 'Completed', 1);

INSERT INTO STOCK_TRANSFER_DETAIL (transfer_id, variant_id, quantity) VALUES
(2, 9, 30),  -- Chuyển 30 Polo M
(2, 10, 30); -- Chuyển 30 Polo L

-- ============================================================
-- BƯỚC 5: GIAO DỊCH BÁN HÀNG (7 Đơn - 1 Hủy)
-- ============================================================

-- Đơn 1: Cầu Giấy bán 1 bộ (Sơ mi + Jean)
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (1, '2024-02-10', 'Completed', 1250000, 2, 4, 2);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(1, 1, 1, 450000, 0), -- 1 Sơ mi 39 (Giá 450k)
(1, 17, 1, 800000, 0); -- 1 Jean Zara 30 (Giá 800k)

-- Đơn 2: Cầu Giấy bán 2 Sơ mi (Khách vãng lai)
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (2, '2024-02-11', 'Completed', 900000, 1, 4, 2);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(2, 2, 2, 450000, 0); -- 2 Sơ mi 40

-- Đơn 3: Quận 1 bán 1 Polo (Khách quen)
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (3, '2024-02-12', 'Completed', 220000, 3, 6, 3);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(3, 9, 1, 220000, 0); -- 1 Polo M

-- Đơn 4: Quận 1 bán 10 Polo (Khách sỉ, giảm giá)
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (4, '2024-02-13', 'Completed', 2000000, 4, 6, 3);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(4, 10, 10, 220000, 200000); -- 10 Polo L (Giảm tổng 200k)

-- Đơn 5: Đơn HỦY tại Cầu Giấy
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (5, '2024-02-14', 'Cancelled', 450000, 5, 4, 2);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(5, 1, 1, 450000, 0); -- Khách định mua Sơ mi 39 nhưng trả lại

-- Đơn 6: Quận 1 bán thêm 1 Polo
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (6, '2024-02-15', 'Completed', 220000, 1, 6, 3);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(6, 9, 1, 220000, 0); 

-- Đơn 7: Cầu Giấy bán 1 Jean
INSERT INTO SALES_ORDER (order_id, order_date, status, total_amount, customer_id, employee_id, location_id)
VALUES (7, '2024-02-15', 'Completed', 800000, 1, 4, 2);

INSERT INTO SALES_DETAIL (order_id, variant_id, quantity, unit_price, discount) VALUES
(7, 17, 1, 800000, 0); 

-- ============================================================
-- BƯỚC 6: CẬP NHẬT TỒN KHO CUỐI CÙNG (INVENTORY)
-- ============================================================
-- Logic tính toán:
-- Kho = Nhập - Chuyển đi + Nhận về - Bán (Completed)

-- KHO TỔNG (ID 1)
-- Sơ mi 39 (ID 1): Nhập 50 - Chuyển 20 = 30
-- Sơ mi 40 (ID 2): Nhập 50 - Chuyển 20 = 30
-- Quần Tây 29 (ID 5): Nhập 20 = 20
-- Polo M (ID 9): Nhập 100 - Chuyển 30 = 70
-- Polo L (ID 10): Nhập 100 - Chuyển 30 = 70
INSERT INTO INVENTORY (location_id, variant_id, quantity) VALUES
(1, 1, 30), (1, 2, 30), (1, 5, 20), (1, 9, 70), (1, 10, 70);

-- CỬA HÀNG CẦU GIẤY (ID 2)
-- Sơ mi 39 (ID 1): Nhận 20 - Bán Đơn 1(1) = 19 (Đơn 5 hủy ko trừ)
-- Sơ mi 40 (ID 2): Nhận 20 - Bán Đơn 2(2) = 18
-- Jean 30 (ID 17): Nhập thẳng 50 - Bán Đơn 1(1) - Bán Đơn 7(1) = 48
INSERT INTO INVENTORY (location_id, variant_id, quantity) VALUES
(2, 1, 19), (2, 2, 18), (2, 17, 48);

-- CỬA HÀNG QUẬN 1 (ID 3)
-- Polo M (ID 9): Nhận 30 - Bán Đơn 3(1) - Bán Đơn 6(1) = 28
-- Polo L (ID 10): Nhận 30 - Bán Đơn 4(10) = 20
INSERT INTO INVENTORY (location_id, variant_id, quantity) VALUES
(3, 9, 28), (3, 10, 20);