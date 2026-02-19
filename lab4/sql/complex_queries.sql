-- ==========================================
-- ЛАБОРАТОРНА РОБОТА №4: АНАЛІТИЧНІ ЗАПИТИ (OLAP)
-- Студент: Михайло Савчук (ІО-45, Варіант 14)
-- ==========================================

-- 1. АГРЕГАЦІЯ ТА ГРУПУВАННЯ (Мінімум 4 функції: COUNT, SUM, AVG, MIN/MAX)
-- Мета: Загальна статистика по категоріях товарів
SELECT 
    c.title AS category_name, 
    COUNT(p.product_id) AS items_count, -- COUNT
    SUM(p.price) AS total_category_value, -- SUM
    AVG(p.price) AS average_price, -- AVG
    MAX(p.price) AS most_expensive_item -- MAX
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.title;

-- 2. ФІЛЬТРУВАННЯ ГРУП (HAVING)
-- Мета: Знайти тільки ті категорії, де середня ціна товару вища за 100 грн
SELECT c.title, AVG(p.price) AS avg_price
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.title
HAVING AVG(p.price) > 100;

-- 3. РІЗНІ ТИПИ JOIN (INNER, LEFT, FULL)
-- INNER JOIN: Тільки ті користувачі, які мають замовлення
SELECT u.username, o.order_id, o.total_amount
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id;

-- LEFT JOIN: Всі користувачі, навіть ті, хто нічого не купував (буде NULL)
SELECT u.username, o.order_id
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id;

-- FULL JOIN: Повне об'єднання всіх записів з обох таблиць
SELECT u.username, o.order_id
FROM Users u
FULL OUTER JOIN Orders o ON u.user_id = o.user_id;

-- 4. ПІДЗАПИТИ (SUBQUERIES: у SELECT, WHERE та HAVING)
-- Підзапит у WHERE: Користувачі з балансом вищим за середній
SELECT username, wallet_balance
FROM Users
WHERE wallet_balance > (SELECT AVG(wallet_balance) FROM Users);

-- Підзапит у SELECT: Список товарів та їхня доля вартості від загального банку маркетплейсу
SELECT name, price,
       ROUND((price / (SELECT SUM(price) FROM Products) * 100), 2) AS price_percentage
FROM Products;

-- Підзапит у HAVING: Категорії, де максимальна ціна вища за середню ціну по всьому магазину
SELECT category_id, MAX(price)
FROM Products
GROUP BY category_id
HAVING MAX(price) > (SELECT AVG(price) FROM Products);