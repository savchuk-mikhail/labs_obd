-- ЛАБОРАТОРНА РОБОТА №5
-- НОРМАЛІЗОВАНА БАЗА ДАНИХ (3НФ)
-- Винонав Михайло Савчук (ІО-45, Варіант 14)

-- ВИДАЛЕННЯ ТАБЛИЦЬ

DROP TABLE IF EXISTS OrderItems CASCADE;
DROP TABLE IF EXISTS LoginSessions CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS UserDeviceSecurity CASCADE;
DROP TABLE IF EXISTS UserWallets CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Categories CASCADE;

-- СТВОРЕННЯ ТАБЛИЦЬ


-- Категорії товарів
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL UNIQUE
);

-- Основна таблиця користувачів
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Баланс користувача
CREATE TABLE UserWallets (
    wallet_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    wallet_balance NUMERIC(10,2) DEFAULT 0.00 CHECK (wallet_balance >= 0),

    CONSTRAINT fk_wallet_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- Безпека пристрою
CREATE TABLE UserDeviceSecurity (
    security_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    is_trusted_device BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_security_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- Товари
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    category_id INTEGER,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
        ON DELETE SET NULL
);

-- Замовлення
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- Склад замовлення
CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    price_at_purchase NUMERIC(10,2) NOT NULL CHECK (price_at_purchase > 0),

    CONSTRAINT fk_orderitems_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_orderitems_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON DELETE RESTRICT
);

-- Сесії входу
CREATE TABLE LoginSessions (
    session_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_session_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);


-- НАПОВНЕННЯ ДАНИМИ


-- Категорії
INSERT INTO Categories (title)
VALUES
('Skins'),
('Resources'),
('Tools');

-- Користувачі
INSERT INTO Users (username, email)
VALUES
('Mikhail_Dev', 'mikhail@example.com'),
('Skins_Trader', 'trader@test.com'),
('Newbie_Player', 'newbie@mail.com');

-- Баланси
INSERT INTO UserWallets (user_id, wallet_balance)
VALUES
(1, 500.00),
(2, 1250.50),
(3, 10.00);

-- Безпечні пристрої
INSERT INTO UserDeviceSecurity (user_id, is_trusted_device)
VALUES
(1, TRUE),
(2, FALSE),
(3, FALSE);

-- Товари
INSERT INTO Products (name, price, category_id)
VALUES
('AK-47 | Neon Rider', 120.00, 1),
('Metal Ingots (100x)', 20.00, 2),
('Diamond Pickaxe', 55.50, 3);

-- Замовлення
INSERT INTO Orders (user_id)
VALUES
(1),
(2),
(1);

-- Склад замовлень
INSERT INTO OrderItems (
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
VALUES
(1, 1, 1, 120.00),
(2, 2, 1, 20.00),
(3, 3, 1, 55.50);

-- Сесії входу
INSERT INTO LoginSessions (
    user_id,
    ip_address
)
VALUES
(1, '192.168.0.10'),
(2, '176.12.3.4'),
(3, '10.0.0.5');


-- ПЕРЕВІРКА ДАНИХ

SELECT * FROM Categories;
SELECT * FROM Users;
SELECT * FROM UserWallets;
SELECT * FROM UserDeviceSecurity;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM LoginSessions;


-- ПІДРАХУНОК СУМИ ЗАМОВЛЕННЯ


SELECT
    o.order_id,
    u.username,
    SUM(oi.quantity * oi.price_at_purchase) AS total_amount
FROM Orders o
JOIN Users u
    ON o.user_id = u.user_id
JOIN OrderItems oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, u.username
ORDER BY o.order_id;
