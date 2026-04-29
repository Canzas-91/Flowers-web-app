# 🌸 Flowers App — интернет-магазин букетов

**Flowers App** — это учебный командный pet-проект веб-приложения для продажи букетов и управления заказами.  
Проект реализован как полноценное приложение с клиентской частью, backend API, базой данных, административной панелью, корзиной, заказами, AI-ассистентом и модулем прогнозирования спроса.

Проект можно использовать как пример fullstack-приложения для портфолио frontend-разработчика.

---

## 📌 О проекте

Flowers App имитирует работу интернет-магазина цветов. Пользователь может просматривать каталог букетов, открывать карточки товаров, добавлять товары в корзину, оформлять заказы и работать с личным кабинетом.

Для администратора реализована отдельная панель управления, где можно управлять товарами, заказами, пользователями и просматривать служебную информацию.

Также в проект добавлен AI-ассистент, который помогает пользователю подобрать букет по описанию, бюджету или ситуации.

---

## 👨‍💻 Мой вклад в проект

В этом проекте я занимался **frontend-разработкой**.

С моей стороны было реализовано:

- 🎨 верстка пользовательского интерфейса;
- 🧩 создание React-компонентов;
- 🛒 разработка страниц каталога, корзины и оформления заказа;
- 👤 реализация страниц авторизации и личного кабинета;
- 🛠️ участие в создании интерфейса административной панели;
- 🔗 подключение frontend к backend через API-запросы;
- 📦 отображение данных о товарах, заказах и пользователях;
- ✅ обработка пользовательских действий и состояний интерфейса;
- 🧭 настройка маршрутизации между страницами;
- 🤝 работа в команде с использованием Git и GitHub.

Проект помог мне получить практический опыт командной разработки, работы с React, REST API, Docker и интеграции frontend-части с backend.

---

## 🚀 Основной функционал

### Для пользователя

- 🌷 просмотр каталога букетов;
- 🔍 просмотр информации о товаре;
- 🛒 добавление товаров в корзину;
- ➕ изменение количества товаров в корзине;
- 🧾 оформление заказа;
- 👤 регистрация и авторизация;
- 📦 просмотр своих заказов;
- 🤖 подбор букета через AI-ассистента.

### Для администратора

- 🔐 вход в административную панель;
- 🌸 добавление, редактирование и удаление товаров;
- 📦 просмотр и управление заказами;
- 👥 просмотр пользователей;
- 📊 просмотр статистики и служебных данных;
- 🧠 работа с прогнозом спроса;
- 📝 просмотр audit-логов.

### Дополнительные возможности

- 🐳 запуск через Docker Compose;
- 🗄️ подключение PostgreSQL;
- 🤖 интеграция с Ollama для AI-ассистента;
- 📈 прогнозирование спроса с помощью XGBoost;
- 🛠️ документация API через Swagger.

---

## 🛠️ Технологии

### Frontend

- React
- Vite
- JavaScript
- React Router
- HTML
- CSS

### Backend

- Python
- FastAPI
- SQLAlchemy
- Uvicorn
- JWT-авторизация

### Database

- PostgreSQL
- pgAdmin

### AI / ML

- Ollama
- Llama
- XGBoost
- Pandas
- NumPy
- Scikit-learn

### DevOps / Tools

- Docker
- Docker Compose
- Git
- GitHub

---

## 📁 Структура проекта

```text
flowers-app/
│
├── backend/                 # Backend-часть проекта на FastAPI
│   ├── main.py              # Основной файл API
│   ├── database.py          # Подключение к базе данных
│   ├── models.py            # Модели базы данных
│   ├── requirements.txt     # Python-зависимости
│   ├── Dockerfile           # Dockerfile для backend
│   ├── forecast_service.py  # Логика прогноза спроса
│   ├── train_xgboost.py     # Обучение ML-модели
│   └── ollama_assistant.py  # Работа с AI-ассистентом
│
├── front/                   # Frontend-часть проекта
│   ├── src/                 # Исходный код React-приложения
│   ├── public/              # Статические файлы
│   ├── package.json         # Frontend-зависимости
│   ├── vite.config.js       # Настройки Vite
│   └── Dockerfile           # Dockerfile для frontend
│
├── docker-compose.yml       # Запуск всех сервисов
├── .env.example             # Пример переменных окружения
├── init.sql                 # SQL-инициализация базы данных
├── dump.sql                 # Дамп базы данных
├── synthetic_orders.csv     # Данные для прогноза спроса
└── README.md                # Описание проекта
```

---

## ⚙️ Как запустить проект

Есть два варианта запуска:

1. через Docker — самый удобный вариант;
2. вручную — отдельно backend и frontend.

---

# 🐳 Запуск через Docker

## 1. Клонировать репозиторий

```bash
git clone https://github.com/VikaD2345/Flowers1.git
cd Flowers1
```

Если проект уже находится у вас на компьютере, просто перейдите в папку проекта:

```bash
cd flowers-app
```

---

## 2. Создать `.env` файл

Скопируйте пример файла окружения:

### macOS / Linux

```bash
cp .env.example .env
```

### Windows PowerShell

```powershell
copy .env.example .env
```

Пример содержимого `.env`:

```env
POSTGRES_DB=flowers_db
POSTGRES_USER=flowers_user
POSTGRES_PASSWORD=flowers_pass

ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123

OLLAMA_MODEL=llama3.2:1b
OLLAMA_TIMEOUT_SECONDS=45
```

---

## 3. Запустить контейнеры

```bash
docker compose up -d --build
```

Эта команда запустит:

- frontend;
- backend;
- PostgreSQL;
- pgAdmin;
- Ollama.

---

## 4. Загрузить модель для AI-ассистента

```bash
docker compose --profile init run --rm ollama-pull
```

Если модель уже загружена, повторно выполнять команду не обязательно.

---

## 5. Открыть приложение

После запуска проект будет доступен по адресам:

| Сервис | Адрес |
|---|---|
| 🌐 Сайт | `http://localhost:5173` |
| 🛠️ Админ-панель | `http://localhost:5173/admin` |
| ⚙️ Backend API | `http://127.0.0.1:8100` |
| 📘 Swagger Docs | `http://127.0.0.1:8100/docs` |
| 🗄️ pgAdmin | `http://localhost:5050` |
| 🤖 Ollama API | `http://127.0.0.1:11434` |

---

## 🔐 Данные для входа в админ-панель

Админ-панель находится по адресу:

```text
http://localhost:5173/admin
```

Данные администратора задаются в `.env` файле:

```env
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
```

По умолчанию:

```text
Логин: admin
Пароль: admin123
```

---

# 💻 Запуск без Docker

Этот способ подходит, если нужно запустить frontend и backend отдельно.

---

## 1. Запуск backend

Перейдите в папку backend:

```bash
cd backend
```

Создайте виртуальное окружение:

### macOS / Linux

```bash
python3 -m venv venv
source venv/bin/activate
```

### Windows PowerShell

```powershell
python -m venv venv
.\venv\Scripts\activate
```

Установите зависимости:

```bash
pip install -r requirements.txt
```

Запустите backend:

```bash
uvicorn main:app --reload --host 127.0.0.1 --port 8100
```

Backend будет доступен по адресу:

```text
http://127.0.0.1:8100
```

Swagger-документация:

```text
http://127.0.0.1:8100/docs
```

---

## 2. Запуск frontend

Откройте новый терминал и перейдите в папку frontend:

```bash
cd front
```

Установите зависимости:

```bash
npm install
```

Запустите frontend:

```bash
npm run dev
```

Frontend будет доступен по адресу:

```text
http://localhost:5173
```

---

## 🗄️ База данных

В проекте используется PostgreSQL.

При запуске через Docker база данных поднимается автоматически.

Параметры подключения по умолчанию:

```text
Host: localhost
Port: 5433
Database: flowers_db
User: flowers_user
Password: flowers_pass
```

Для работы с базой можно использовать pgAdmin:

```text
http://localhost:5050
```

Данные для входа в pgAdmin задаются в `docker-compose.yml` или `.env`.

---

## 🤖 AI-ассистент

В проекте реализован AI-ассистент для помощи пользователю при выборе букета.

Ассистент может:

- подобрать букет под событие;
- учитывать бюджет пользователя;
- ориентироваться на стиль букета;
- предлагать товары из базы данных;
- задавать уточняющие вопросы.

AI-ассистент работает через Ollama и локальную LLM-модель.

Проверить работу ассистента можно через endpoint:

```text
GET http://127.0.0.1:8100/assistant/health
```

Пример запроса к ассистенту:

```http
POST /assistant/chat
Content-Type: application/json
```

Пример тела запроса:

```json
{
  "messages": [
    {
      "role": "user",
      "content": "Хочу недорогой и нежный букет для девушки"
    }
  ],
  "limit": 3
}
```

---

## 📈 Прогнозирование спроса

В backend добавлен модуль прогнозирования спроса на букеты.

Для прогноза используется модель **XGBoost**.  
Она анализирует историю заказов и строит прогноз будущего спроса.

Данные для обучения находятся в файле:

```text
synthetic_orders.csv
```

Проверить состояние модели:

```text
GET http://127.0.0.1:8100/forecast/health
```

Получить прогноз:

```text
GET http://127.0.0.1:8100/forecast?days=5&safety_stock=0.15
```

Переобучить модель:

```text
POST http://127.0.0.1:8100/forecast/retrain
```

---

## 📘 Основные API endpoints

### Авторизация

```text
POST /auth/register
POST /auth/login
GET  /me
```

### Товары

```text
GET    /flowers
GET    /flowers/{flower_id}
POST   /admin/flowers
PATCH  /admin/flowers/{flower_id}
DELETE /admin/flowers/{flower_id}
```

### Корзина

```text
GET    /cart
POST   /cart/items
PATCH  /cart/items/{item_id}
DELETE /cart/items/{item_id}
```

### Заказы

```text
POST  /orders/from-cart
GET   /me/orders
GET   /orders/{order_id}
GET   /admin/orders
PATCH /admin/orders/{order_id}/status
```

### Админ-панель

```text
GET    /admin/users
GET    /admin/audit
DELETE /admin/users/{user_id}
DELETE /admin/orders/{order_id}
DELETE /admin/flowers/{flower_id}
```

### AI-ассистент

```text
GET  /assistant/health
POST /assistant/chat
POST /assistant/chat/stream
```

### Прогнозирование

```text
GET  /forecast/health
GET  /forecast
POST /forecast/retrain
```

---

## 🧪 Проверка работы проекта

После запуска можно проверить:

1. Открывается ли сайт:

```text
http://localhost:5173
```

2. Открывается ли админ-панель:

```text
http://localhost:5173/admin
```

3. Работает ли backend:

```text
http://127.0.0.1:8100/health
```

4. Открывается ли Swagger:

```text
http://127.0.0.1:8100/docs
```

5. Работает ли pgAdmin:

```text
http://localhost:5050
```

---

## 🧹 Что не нужно загружать в GitHub

В репозиторий не рекомендуется загружать:

```text
node_modules/
dist/
.env
.DS_Store
__pycache__/
.vite/
*.pyc
```

Эти файлы лучше добавить в `.gitignore`.

Пример `.gitignore`:

```gitignore
node_modules/
dist/
.env
.DS_Store
__pycache__/
*.pyc
.vite/
venv/
```

---

## 📚 Чему я научился в проекте

Во время работы над проектом я получил практический опыт:

- разработки frontend-части на React;
- создания компонентов и страниц приложения;
- работы с маршрутизацией;
- подключения frontend к backend;
- отправки и обработки API-запросов;
- работы с авторизацией;
- командной разработки через Git;
- запуска проекта через Docker;
- взаимодействия с базой данных;
- оформления проекта для портфолио.

---

## 🏁 Статус проекта

Проект выполнен в учебных целях и используется как pet-проект для портфолио.

Возможные направления для доработки:

- улучшить адаптивность интерфейса;
- добавить онлайн-оплату;
- улучшить фильтрацию и поиск товаров;
- добавить избранные товары;
- расширить аналитику для администратора;
- улучшить UI/UX административной панели;
- доработать AI-ассистента для более точного подбора букетов.

---

## 👥 Командная разработка

Проект разрабатывался в команде.  
Моя зона ответственности — **frontend-разработка и интеграция интерфейса с backend**.

---

## 📄 License

Проект создан в учебных целях.
