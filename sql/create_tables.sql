USE olist_dw;

-- =========================================================
-- DIMENSION: CUSTOMER
-- =========================================================

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_sk BIGINT NOT NULL AUTO_INCREMENT,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10),
    customer_zip_code_prefix INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_sk),
    UNIQUE KEY uk_dim_customer_unique_id (customer_unique_id)
) ENGINE=InnoDB;


-- =========================================================
-- DIMENSION: PRODUCT
-- =========================================================

CREATE TABLE IF NOT EXISTS dim_product (
    product_sk BIGINT NOT NULL AUTO_INCREMENT,
    product_id VARCHAR(50) NOT NULL,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(15,2),
    product_length_cm DECIMAL(15,2),
    product_height_cm DECIMAL(15,2),
    product_width_cm DECIMAL(15,2),
    PRIMARY KEY (product_sk)
) ENGINE=InnoDB;


-- =========================================================
-- DIMENSION: SELLER
-- =========================================================

CREATE TABLE IF NOT EXISTS dim_seller (
    seller_sk BIGINT NOT NULL AUTO_INCREMENT,
    seller_id VARCHAR(50) NOT NULL,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10),
    seller_zip_code_prefix INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (seller_sk)
) ENGINE=InnoDB;


-- =========================================================
-- DIMENSION: DATE
-- =========================================================

CREATE TABLE IF NOT EXISTS dim_date (
    date_sk INT NOT NULL,
    full_date DATE NOT NULL,
    day INT,
    month INT,
    quarter INT,
    year INT,
    day_name VARCHAR(20),
    week INT,
    is_weekend TINYINT(1),
    PRIMARY KEY (date_sk),
    UNIQUE KEY uk_dim_date_full_date (full_date)
) ENGINE=InnoDB;


-- =========================================================
-- FACT: SALES
-- =========================================================

CREATE TABLE IF NOT EXISTS fact_sales (
    sales_sk BIGINT NOT NULL AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,

    customer_sk BIGINT,
    product_sk BIGINT,
    seller_sk BIGINT,

    order_date_sk INT,
    delivered_date_sk INT,
    estimated_delivery_date_sk INT,

    order_status VARCHAR(30),
    shipping_limit_date DATETIME,

    price DECIMAL(15,2),
    freight_value DECIMAL(15,2),
    total_item_value DECIMAL(15,2),

    delivery_days INT,
    is_late TINYINT(1),

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (sales_sk),

    CONSTRAINT fk_fact_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dim_customer(customer_sk),

    CONSTRAINT fk_fact_product
        FOREIGN KEY (product_sk)
        REFERENCES dim_product(product_sk),

    CONSTRAINT fk_fact_seller
        FOREIGN KEY (seller_sk)
        REFERENCES dim_seller(seller_sk),

    CONSTRAINT fk_fact_order_date
        FOREIGN KEY (order_date_sk)
        REFERENCES dim_date(date_sk),

    CONSTRAINT fk_fact_delivered_date
        FOREIGN KEY (delivered_date_sk)
        REFERENCES dim_date(date_sk),

    CONSTRAINT fk_fact_estimated_date
        FOREIGN KEY (estimated_delivery_date_sk)
        REFERENCES dim_date(date_sk)

) ENGINE=InnoDB;