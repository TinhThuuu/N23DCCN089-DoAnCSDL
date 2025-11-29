-- Tạo Database
CREATE DATABASE SHOP1;
GO
USE SHOP1;
GO

-- 1. MASTER DATA
-- =============================================

CREATE TABLE BRAND (
    brand_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    origin NVARCHAR(100)
);

CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE PRODUCT (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(200) NOT NULL,
    status NVARCHAR(50) DEFAULT 'Active',
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES BRAND(brand_id),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE PRODUCT_VARIANT (
    variant_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    sku NVARCHAR(50) UNIQUE NOT NULL,
    color NVARCHAR(50),
    size NVARCHAR(50),
    material NVARCHAR(100),
    import_price DECIMAL(18,2) DEFAULT 0 CHECK (import_price >= 0),
    retail_price DECIMAL(18,2) DEFAULT 0 CHECK (retail_price >= 0),
    
    -- CASCADE: Xóa Product thì Variant tự bay màu
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);

CREATE TABLE SUPPLIER (
    supplier_id INT PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    phone VARCHAR(20)
);

CREATE TABLE SUPPLIER_PRODUCT (
    supplier_id INT NOT NULL,
    variant_id INT NOT NULL,
    supplier_price DECIMAL(18,2) CHECK (supplier_price >= 0),
    
    PRIMARY KEY (supplier_id, variant_id),
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES PRODUCT_VARIANT(variant_id) ON DELETE CASCADE
);

CREATE TABLE STOCK_LOCATION (
    location_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    city NVARCHAR(100),
    district NVARCHAR(100),
    street NVARCHAR(100) 
);

CREATE TABLE EMPLOYEE (
    employee_id INT PRIMARY KEY,
    lname NVARCHAR(100) NOT NULL,
    mname NVARCHAR(100),
	fname NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    salary DECIMAL(18,2) CHECK (salary >= 0),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES STOCK_LOCATION(location_id) ON DELETE SET NULL 
);

CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY,
    lname NVARCHAR(100) NOT NULL,
    mname NVARCHAR(100),
	fname NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL UNIQUE
);

-- 2. GIAO DỊCH (TRANSACTIONS)
-- =============================================

CREATE TABLE IMPORT_ORDER (
    import_id INT PRIMARY KEY,
    import_date DATE,
    total_amount DECIMAL(18,2) DEFAULT 0,
    status NVARCHAR(50) DEFAULT 'Completed',
    employee_id INT NOT NULL,
    supplier_id INT NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id),
    FOREIGN KEY (location_id) REFERENCES STOCK_LOCATION(location_id),
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
);

CREATE TABLE IMPORT_DETAIL (
    import_id INT,
    variant_id INT,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(18,2) CHECK (unit_price >= 0),
    
    PRIMARY KEY (import_id, variant_id),
    -- CASCADE: Xóa phiếu nhập thì chi tiết tự mất
    FOREIGN KEY (import_id) REFERENCES IMPORT_ORDER(import_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES PRODUCT_VARIANT(variant_id)
);

CREATE TABLE STOCK_TRANSFER (
    transfer_id INT PRIMARY KEY,
    from_location INT NOT NULL,
    to_location INT NOT NULL,
    transfer_date DATE,
    received_date DATE,
    status NVARCHAR(50) DEFAULT 'Completed',
    employee_id INT NOT NULL,
    
    FOREIGN KEY (from_location) REFERENCES STOCK_LOCATION(location_id),
    FOREIGN KEY (to_location) REFERENCES STOCK_LOCATION(location_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id),
    
    -- Không được chuyển cho chính mình
    CONSTRAINT chk_diff_location CHECK (from_location <> to_location)
);

CREATE TABLE STOCK_TRANSFER_DETAIL (
    transfer_id INT,
    variant_id INT,
    quantity INT CHECK (quantity > 0),
    
    PRIMARY KEY (transfer_id, variant_id),
    FOREIGN KEY (transfer_id) REFERENCES STOCK_TRANSFER(transfer_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES PRODUCT_VARIANT(variant_id)
);

CREATE TABLE SALES_ORDER (
    order_id INT PRIMARY KEY,
    order_date DATE,
    status NVARCHAR(50) DEFAULT 'Completed',
    total_amount DECIMAL(18,2) DEFAULT 0,
    customer_id INT, 
    employee_id INT NOT NULL,
    location_id INT NOT NULL,
    
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (location_id) REFERENCES STOCK_LOCATION(location_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
);

CREATE TABLE SALES_DETAIL (
    order_id INT,
    variant_id INT,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(18,2) CHECK (unit_price >= 0),
    discount DECIMAL(18,2) DEFAULT 0,
    
    PRIMARY KEY (order_id, variant_id),
    -- CASCADE: Xóa đơn hàng thì chi tiết tự mất
    FOREIGN KEY (order_id) REFERENCES SALES_ORDER(order_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES PRODUCT_VARIANT(variant_id)
);

CREATE TABLE INVENTORY (
    location_id INT,
    variant_id INT,
    quantity INT, 
    
    PRIMARY KEY (location_id, variant_id),
    -- CASCADE: Xóa Kho hoặc xóa Sản phẩm thì dòng tồn kho này mất theo
    FOREIGN KEY (location_id) REFERENCES STOCK_LOCATION(location_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES PRODUCT_VARIANT(variant_id) ON DELETE CASCADE
);