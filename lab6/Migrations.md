# Лабораторна робота №6: Міграції схем за допомогою Prisma ORM

**Студент:** Михайло Савчук  
**Група:** ІО-45  
(Ігровий маркетплейс)

## Мета роботи
- Використати Prisma ORM для керування схемами та дослідити, як Prisma може аналізувати та змінювати схему вашої бази даних.
- Застосування міграцій - генерування та застосування змін схеми (таблиць, стовпців, зв'язків) за допомогою prisma migrate.
- Моделювання за допомогою файлів схеми Prisma - визначення таблиць та зв'язків у schema.prisma та перегляд їхнього відображення в PostgreSQL.
- Виконати базові запити Prisma - вставити та запитати дані за допомогою клієнта Prisma (через Prisma Studio або простий скрипт) для перевірки змін.

### Хід роботи:
Спочатку я встановлюю Prisma та створюю Prisma-проєкт(папку prisma/, файл schema.prisma та файл .env):

<img width="1090" height="628" alt="Снимок экрана 2026-05-21 100035" src="https://github.com/user-attachments/assets/15a9aa46-9d48-4bd4-85f7-aa219cfcf8f3" />
<img width="1244" height="413" alt="image" src="https://github.com/user-attachments/assets/53c4bf15-bddc-469b-a089-03f29737a5ca" />
<img width="1193" height="399" alt="image" src="https://github.com/user-attachments/assets/21de2656-50c5-4eca-815d-c9e645d3d8e1" />
<img width="1559" height="780" alt="image" src="https://github.com/user-attachments/assets/aad558f3-afb0-414d-9403-4438b18921cc" />

Далі я відкриваю файл `.env` та переписую посилання:

<img width="1076" height="248" alt="image" src="https://github.com/user-attachments/assets/95a66909-f9ed-42b7-8074-76ad61edb1c5" />

Відкриваю prisma/schema.prisma і дописую рядом для зміни:

<img width="1007" height="400" alt="image" src="https://github.com/user-attachments/assets/85276407-82ef-46e1-8bdb-c5b7b0ce58b9" />

За допомогою команди `npx prisma migrate dev --name add-reviews-table` відбувається перша міграція:

<img width="1633" height="548" alt="image" src="https://github.com/user-attachments/assets/f2cbff2d-d8b1-4f0f-a5ed-115e12587ef6" />

Ще додаю одну зміну для міграції:
<img width="1198" height="428" alt="image" src="https://github.com/user-attachments/assets/45a3434e-c25c-4256-b9a1-836e0478ca48" />

За допомогою команди `npx prisma migrate dev --name add-product-availability` утворюється друга міграція: 

<img width="1660" height="567" alt="image" src="https://github.com/user-attachments/assets/a012ed65-5121-41a2-b4de-ede34e1ab84d" />

Пісял цього створюю файл з таким кодом:

```sql
require('dotenv/config');

const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');

const adapter = new PrismaPg({
    connectionString: process.env.DATABASE_URL
});

const prisma = new PrismaClient({ adapter });

async function main() {
    const category = await prisma.categories.upsert({
        where: { title: 'Skins' },
        update: {},
        create: { title: 'Skins' }
    });

    const product = await prisma.products.create({
        data: {
            name: 'AK-47 | Neon Rider',
            price: 120.00,
            category_id: category.category_id,
            is_available: true
        }
    });

    await prisma.reviews.create({
        data: {
            rating: 5,
            comment: 'Excellent product',
            product_id: product.product_id
        }
    });

    const products = await prisma.products.findMany({
        include: {
            reviews: true,
            categories: true
        }
    });

    console.log(products);
}

main()
    .catch(console.error)
    .finally(async () => {
        await prisma.$disconnect();
    });
```
Запускаю `node test.js`:

<img width="1231" height="717" alt="image" src="https://github.com/user-attachments/assets/01533415-ec12-4e61-8ead-99f91ad7bcc2" />

Отже, все працює. Міграції виконались.

# Висновок:

У ході лабораторної роботи було виконано підключення Prisma ORM до бази даних PostgreSQL та створено міграції для зміни структури бази даних. Було додано таблицю `reviews` і нове поле `is_available`
для товарів. Також перевірено роботу Prisma Client шляхом вставлення та отримання даних із бази даних. У результаті підтверджено коректну роботу міграцій, зв’язків між таблицями та Prisma ORM.
