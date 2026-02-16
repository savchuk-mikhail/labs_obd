-- ==========================================
-- 1. СТВОРЕННЯ ТАБЛИЦЬ (DDL)
-- ==========================================

-- Категорії (Скіни, Ресурси і т.д.)
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL UNIQUE
);

-- Користувачі (з балансом та перевіркою пристрою)
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    wallet_balance NUMERIC(10, 2) DEFAULT 0.00 CHECK (wallet_balance >= 0),
    is_trusted_device BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Товари (з прив'язкою до категорій)
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    category_id INTEGER REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- Замовлення
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0)
);

-- ==========================================
-- 2. НАПОВНЕННЯ ДАНИМИ (DML)
-- ==========================================

INSERT INTO Categories (title) VALUES ('Skins'), ('Resources'), ('Tools');

INSERT INTO Users (username, email, wallet_balance, is_trusted_device) VALUES
('Mikhail_Dev', 'mikhail@example.com', 500.00, TRUE),
('Skins_Trader', 'trader@test.com', 1250.50, FALSE),
('Newbie_Player', 'newbie@mail.com', 10.00, FALSE);

INSERT INTO Products (name, price, category_id) VALUES
('AK-47 | Neon Rider', 120.00, 1),
('Metal Ingots (100x)', 20.00, 2),
('Diamond Pickaxe', 55.50, 3);

INSERT INTO Orders (user_id, total_amount) VALUES
(1, 120.00),
(2, 20.00),
(1, 55.50);