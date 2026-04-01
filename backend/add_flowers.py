from decimal import Decimal

from sqlalchemy import create_engine, text


DATABASE_URL = "postgresql+psycopg2://flowers_user:flowers_pass@127.0.0.1:5433/flowers_db"

engine = create_engine(DATABASE_URL, pool_pre_ping=True)

flowers = [
    {
        "name": "Нежный рассвет",
        "description": "Светлый букет из розовых и белых цветов для спокойного подарка.",
        "category": "Нежные",
        "price": Decimal("1000.00"),
        "image_url": "https://images.unsplash.com/photo-1525310072745-f49212b5ac6d",
    },
    {
        "name": "Весенний акцент",
        "description": "Яркий букет с живыми оттенками для хорошего настроения.",
        "category": "Яркие",
        "price": Decimal("2200.00"),
        "image_url": "https://images.unsplash.com/photo-1526045478516-99145907023c",
    },
    {
        "name": "Розовый вечер",
        "description": "Романтичная композиция в мягких розовых тонах.",
        "category": "Романтические",
        "price": Decimal("3500.00"),
        "image_url": "https://images.unsplash.com/photo-1490750967868-88aa4486c946",
    },
    {
        "name": "Летний сад",
        "description": "Объёмный букет с ощущением свежего летнего утра.",
        "category": "Сезонные",
        "price": Decimal("4800.00"),
        "image_url": "https://images.unsplash.com/photo-1468327768560-75b778cbb551",
    },
    {
        "name": "Праздничный шарм",
        "description": "Нарядный букет для особого случая и торжественного подарка.",
        "category": "Праздничные",
        "price": Decimal("6200.00"),
        "image_url": "https://images.unsplash.com/photo-1519378058457-4c29a0a2efac",
    },
    {
        "name": "Королевский пион",
        "description": "Премиальный букет с выразительной композицией и богатой подачей.",
        "category": "Премиум",
        "price": Decimal("8000.00"),
        "image_url": "https://images.unsplash.com/photo-1563241527-3004b7be0ffd",
    },
]

select_sql = text("SELECT id FROM bouquets WHERE name = :name")
insert_sql = text(
    """
    INSERT INTO bouquets (name, description, category, price, image_url)
    VALUES (:name, :description, :category, :price, :image_url)
    """
)

added = 0
skipped = 0

with engine.begin() as conn:
    for flower in flowers:
        existing = conn.execute(select_sql, {"name": flower["name"]}).fetchone()
        if existing:
            skipped += 1
            print(f"Skipped: {flower['name']} already exists")
            continue

        conn.execute(insert_sql, flower)
        added += 1
        print(f"Added: {flower['name']}")

print(f"\nDone. Added: {added}, skipped: {skipped}")
