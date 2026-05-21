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