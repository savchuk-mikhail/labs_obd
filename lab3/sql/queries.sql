-- ==========================================
-- ЛАБОРАТОРНА РОБОТА №3: OLTP ЗАПИТИ
-- Студент: Михайло Савчук (ІО-45, Варіант 14)
-- ==========================================

-- 1. SELECT - Отримання даних
-- Мета: Вивести список товарів, які коштують більше 50 грн (фільтрація цін)
SELECT name, price 
FROM Products 
WHERE price > 50.00;

-- Мета: Знайти користувача за його електронною поштою (пошук профілю)
SELECT username, wallet_balance 
FROM Users 
WHERE email = 'savchuk@kpi.ua';

-- 2. INSERT - Додавання даних
-- Мета: Реєстрація нового гравця в системі
INSERT INTO Users (username, email, wallet_balance, is_trusted_device)
VALUES ('New_Pro_Player', 'pro_gamer@ukr.net', 150.00, TRUE);

-- Мета: Додавання нового товару в категорію "Tools" (id=3)
INSERT INTO Products (name, price, category_id)
VALUES ('Золота кірка', 250.00, 3);

-- 3. UPDATE - Зміна даних
-- Мета: Оновлення балансу користувача після поповнення рахунку
UPDATE Users 
SET wallet_balance = wallet_balance + 100.00 
WHERE username = 'Mikhail_Dev';

-- Мета: Зміна ціни на товар (наприклад, розпродаж скіна)
UPDATE Products 
SET price = 99.99 
WHERE name = 'AK-47 | Neon Rider';

-- 4. DELETE - Видалення даних
-- Мета: Видалення тестового або помилкового замовлення
DELETE FROM Orders 
WHERE order_id = 1;

-- Мета: Видалення неактивного або заблокованого сеансу входу
DELETE FROM LoginSessions 
WHERE ip_address = '176.12.3.4';

-- 5. ПЕРЕВІРКА РЕЗУЛЬТАТІВ
SELECT * FROM Users;
SELECT * FROM Products;
SELECT * FROM Orders;