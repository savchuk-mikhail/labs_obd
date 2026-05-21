# Лабораторна робота №5: Нормалізація бази даних
**Студент:** Михайло Савчук  
**Група:** ІО-45  
(Ігровий маркетплейс)

## 1. Мета роботи
У цій лабораторній роботі проаналізувати та вдосконалити схему бази даних, яку створили в попередніх лабораторних роботах. Нормалізація має бути частиною процесу
проектування бази даних. Вивчаючи існуючу схему (ER-діаграму та таблиці) і зразки даних, визначити надлишковість або аномалії та реорганізувати таблиці, щоб 
зменшити дублювання. Мета полягає в покращенні цілісності даних шляхом структурування таблиць таким чином, щоб кожен факт зберігався лише один раз.
## Хід роботи:
### 1. Початкова схема
Початкова база даних містила таблиці:
- Categories
- Users
- Products
- Orders
- LoginSessions
### 2. Аналіз таблиць
**Таблиця `Users`**
```sql
Users(
    user_id,
    username,
    email,
    wallet_balance,
    is_trusted_device,
    created_at
)
```
Функціональні залежності

`user_id -> username, email, wallet_balance, is_trusted_device, created_at
username -> user_idemail -> user_id`

**Проблема**

Таблиця містить зайві дані:

- баланс користувача,
- інформацію про безпечний пристрій.

Це порушує логічну структуру 3НФ!!

**Нормалізація**

Створено окремі таблиці:

`UserWallets(wallet_id, user_id, wallet_balance)`

`UserDeviceSecurity(security_id, user_id, is_trusted_device)`

**Таблиця `Orders`**
```sql
Orders(
    order_id,
    user_id,
    order_date,
    total_amount
)
```

Функціональні залежності `order_id -> user_id, order_date, total_amount`

**Проблема**

Таблиця не містить інформації про товари у замовленні.
Поле `total_amount` є розрахунковим.

**Нормалізація**

Створено таблицю:

```sql
OrderItems(
    order_item_id,
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
```

Поле `price_at_purchase` зберігає ціну товару на момент покупки.

**Таблиця `Products`**
```sql
Products(
    product_id,
    name,
    price,
    category_id
)
```

Функціональні залежності `product_id -> name, price, category_id`

Таблиця вже перебуває у 3НФ.

**Таблиця `Categories`**
```sql
Categories(
    category_id,
    title
)
```

Функціональні залежності `category_id -> title`

Таблиця перебуває у 3НФ.

**Таблиця `LoginSessions`**
```sql
LoginSessions(
    session_id,
    user_id,
    ip_address,
    login_time
)
```

Функціональні залежності `session_id -> user_id, ip_address, login_time`

Таблиця перебуває у 3НФ.

### 3. Нормальні форми

**1НФ**

Усі атрибути прості. Повторюваних груп немає.

**2НФ**

Усі таблиці мають прості первинні ключі, тому часткових залежностей немає.

**3НФ**

*Для досягнення 3НФ я зробив:*

- баланс винесено в `UserWallets`,
- безпеку пристроїв винесено в `UserDeviceSecurity`,
- створено `OrderItem`s,
- `total_amount` видалено з `Orders`.
- 
**Стара ER-діаграма:**
  
  <img width="795" height="700" alt="image" src="https://github.com/user-attachments/assets/c921d329-ed11-492f-852b-c91931f96ad9" />

**Нова ER-діаграма:**

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/e0ae6bd0-2886-4369-a6ca-4a5898720c48" />

# Висновок:
У лабораторній роботі було виконано нормалізацію бази даних до 3НФ. Було усунуто надлишковість даних та покращено структуру таблиць. Для цього створено нові таблиці 
`UserWallets`, `UserDeviceSecurity` та `OrderItems`. Після нормалізації кожна таблиця зберігає лише один тип даних, а всі не ключові атрибути залежать тільки від 
первинного ключа.
