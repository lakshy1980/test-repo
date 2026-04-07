-- ============================================================
--  Aurora Shop — MySQL Schema
--  Complete e-commerce database with all features
--  Run once:  mysql -u root -p < schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS aurora_ecommerce;
USE aurora_ecommerce;

-- Products
CREATE TABLE IF NOT EXISTS products (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(255)  NOT NULL,
    price      DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2) DEFAULT NULL,
    image      LONGTEXT,
    images     JSON,  -- Additional product images for gallery
    category   VARCHAR(100)  NOT NULL,
    subcategory VARCHAR(100) DEFAULT NULL,
    description TEXT,
    badge      VARCHAR(50)   DEFAULT NULL,
    sizes      JSON,
    stock      INT DEFAULT 100,
    sizes_stock JSON,  -- Stock per size: {"S": 10, "M": 5, "L": 0}
    created_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- Product Reviews
CREATE TABLE IF NOT EXISTS reviews (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    product_id    INT          NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    email         VARCHAR(255),
    rating        INT          NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title         VARCHAR(255),
    comment       TEXT,
    verified      BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Coupons/Discount Codes
CREATE TABLE IF NOT EXISTS coupons (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    code          VARCHAR(50)  NOT NULL UNIQUE,
    description   VARCHAR(255),
    discount_type ENUM('percentage', 'fixed') DEFAULT 'percentage',
    discount_value DECIMAL(10,2) NOT NULL,
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    max_discount  DECIMAL(10,2) DEFAULT NULL,
    usage_limit   INT DEFAULT NULL,
    used_count    INT DEFAULT 0,
    valid_from    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until   TIMESTAMP,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- QR settings (single row, id always = 1)
CREATE TABLE IF NOT EXISTS qr_settings (
    id    INT          PRIMARY KEY DEFAULT 1,
    image LONGTEXT     NOT NULL,
    label VARCHAR(255) DEFAULT ''
);

-- Newsletter Subscribers
CREATE TABLE IF NOT EXISTS subscribers (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    email      VARCHAR(255) NOT NULL UNIQUE,
    is_active  BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders
CREATE TABLE IF NOT EXISTS orders (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    order_id      VARCHAR(50)   NOT NULL UNIQUE,
    customer_name VARCHAR(255)  NOT NULL,
    email         VARCHAR(255)  NOT NULL,
    phone         VARCHAR(20),
    address       TEXT,
    city          VARCHAR(100),
    state         VARCHAR(100),
    pincode       VARCHAR(10),
    cart          JSON          NOT NULL,
    total_amount  DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    coupon_code   VARCHAR(50) DEFAULT NULL,
    txn_id        VARCHAR(255),
    status        ENUM('pending','verified','shipped','delivered','cancelled') DEFAULT 'pending',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contact Form Submissions
CREATE TABLE IF NOT EXISTS contacts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    phone      VARCHAR(20),
    subject    VARCHAR(255),
    message    TEXT,
    is_read    BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Sample Products
INSERT INTO products (name, price, original_price, category, description, badge, sizes, sizes_stock, stock) VALUES
('Aurora Borealis Hoodie', 2499, 3299, 'hoodies', 'Embrace the northern lights with our premium Aurora Borealis Hoodie. Features a stunning gradient design inspired by the aurora, soft fleece lining, and kangaroo pocket.', 'trending', '["S","M","L","XL"]', '{"S": 15, "M": 20, "L": 12, "XL": 8}', 55),
('Midnight Sky T-Shirt', 999, NULL, 'tshirts', 'A classic tee with celestial elegance. The deep midnight blue with subtle star patterns makes it perfect for any occasion.', 'new', '["S","M","L","XL","XXL"]', '{"S": 25, "M": 30, "L": 28, "XL": 15, "XXL": 10}', 108),
('Northern Lights Beanie', 599, 799, 'hats', 'Keep warm while dreaming of the aurora. Our Northern Lights Beanie features a beautiful gradient knit and soft acrylic material.', 'sale', '["ONE SIZE"]', '{"ONE SIZE": 45}', 45),
('Starlight Denim Jacket', 3999, 4999, 'jackets', 'A statement piece featuring embroidered star patterns. Premium denim with a comfortable fit that works for any season.', 'bestseller', '["S","M","L","XL"]', '{"S": 8, "M": 12, "L": 10, "XL": 6}', 36),
('Cosmic Print Leggings', 1299, NULL, 'bottoms', 'High-waisted leggings with a mesmerizing cosmic print. Made with 4-way stretch fabric for ultimate comfort.', NULL, '["S","M","L"]', '{"S": 20, "M": 25, "L": 18}', 63),
('Aurora Snapback Cap', 799, NULL, 'hats', 'A sleek snapback cap with aurora-inspired embroidery. Adjustable fit with premium cotton twill construction.', NULL, '["ONE SIZE"]', '{"ONE SIZE": 60}', 60),
('Galaxy Wanderer Backpack', 2499, 2999, 'backpack', 'A spacious backpack with celestial-themed design. Features padded laptop sleeve, multiple compartments, and ergonomic straps.', 'trending', '["ONE SIZE"]', '{"ONE SIZE": 25}', 25),
('Nebula Crossbody Bag', 1799, NULL, 'accessories', 'Compact and stylish crossbody bag with nebula-print canvas. Perfect for everyday use with adjustable strap.', 'new', '["ONE SIZE"]', '{"ONE SIZE": 35}', 35),
('Solar Flare Sunglasses', 1499, 1999, 'eyewear', 'Oversized sunglasses with gradient lenses inspired by solar flares. UV400 protection with lightweight metal frame.', 'sale', '["ONE SIZE"]', '{"ONE SIZE": 40}', 40),
('Meteor Wallet', 699, NULL, 'wallets', 'Slim RFID-blocking wallet with meteor-inspired texture. Features multiple card slots and coin pocket.', NULL, '["ONE SIZE"]', '{"ONE SIZE": 50}', 50);

-- Sample Reviews
INSERT INTO reviews (product_id, customer_name, email, rating, title, comment, verified) VALUES
(1, 'Priya Sharma', 'priya@example.com', 5, 'Absolutely Love It!', 'The hoodie is so soft and the colors are even more beautiful in person. Perfect for cold nights!', TRUE),
(1, 'Rahul Verma', 'rahul@example.com', 4, 'Great Quality', 'Good quality fabric, but the sizing runs a bit small. Order one size up.', TRUE),
(2, 'Ananya Patel', 'ananya@example.com', 5, 'Perfect Everyday Tee', 'I wear this almost every day. The fabric is breathable and the design is subtle yet stylish.', TRUE),
(3, 'Vikram Singh', 'vikram@example.com', 4, 'Warm and Cozy', 'Keeps my head warm and looks great. The colors are vibrant.', TRUE),
(4, 'Meera Joshi', 'meera@example.com', 5, 'Statement Piece!', 'I get compliments every time I wear this jacket. The quality is outstanding.', TRUE),
(5, 'Arjun Kumar', 'arjun@example.com', 5, 'Super Comfortable', 'These leggings are amazing! They fit perfectly and the print is stunning.', TRUE),
(7, 'Sneha Reddy', 'sneha@example.com', 4, 'Love the Design', 'Roomy enough for all my essentials. Wish it had more color options though.', TRUE),
(9, 'Aditya Gupta', 'aditya@example.com', 5, 'Stylish & Functional', 'These sunglasses look great and the UV protection gives me peace of mind.', TRUE);

-- Sample Coupons
INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, max_discount, usage_limit, valid_until) VALUES
('AURORA20', '20% off on your first order', 'percentage', 20, 500, 500, 1000, DATE_ADD(NOW(), INTERVAL 30 DAY)),
('WELCOME10', '₹100 off for new customers', 'fixed', 100, 999, NULL, NULL, DATE_ADD(NOW(), INTERVAL 60 DAY)),
('SUMMER25', 'Summer sale - 25% off', 'percentage', 25, 1000, 1000, 500, DATE_ADD(NOW(), INTERVAL 14 DAY)),
('FLAT200', '₹200 off on orders above ₹2000', 'fixed', 200, 2000, NULL, NULL, DATE_ADD(NOW(), INTERVAL 90 DAY));

-- Default QR Settings
INSERT INTO qr_settings (id, image, label) VALUES (1, '', 'Scan to Pay via UPI');
