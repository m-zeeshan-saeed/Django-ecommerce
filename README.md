# Django E-commerce Project

## Table of Contents

1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Local Setup](#local-setup)
4. [Docker Setup](#docker-setup)
5. [PostgreSQL Setup](#postgresql-setup)
6. [Redis & Celery Setup](#redis--celery-setup)
7. [Running Tests with Pytest](#running-tests-with-pytest)
8. [GitHub Actions CI/CD](#github-actions-cicd)
9. [Project Structure](#project-structure)

---

## Project Overview

This is a Django e-commerce project using:

- Django 5.x
- PostgreSQL as database
- Redis for caching and Celery task queue
- Gunicorn for production server
- Docker for containerization
- GitHub Actions for CI/CD
- Pytest for testing

---

## Prerequisites

- Python 3.12+
- Docker & Docker Compose
- Git
- PostgreSQL
- Redis

---

## Local Setup

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/django-ecommerce.git
cd django-ecommerce/backend
```

2. Create virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows
```

3. Install dependencies:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

4. Configure environment variables:

Create a `.env` file:

```env
SECRET_KEY=your_secret_key
DEBUG=True
DB_NAME=django_db
DB_USER=django_user
DB_PASSWORD=django_pass
DB_HOST=localhost
DB_PORT=5432
REDIS_URL=redis://localhost:6379/0
```

5. Apply migrations:

```bash
python manage.py migrate
```

6. Create superuser:

```bash
python manage.py createsuperuser
```

7. Run development server:

```bash
python manage.py runserver
```

Access at: `http://127.0.0.1:8000`

---

## Docker Setup

### 1. Build Docker image

```bash
docker build -t django-backend-prod .
```

### 2. Run Docker container (Development mode with hot reload)

```bash
docker run -it -p 8000:8000 -v $(pwd):/app django-backend-prod
```

### 3. Run Docker container (Production mode with Gunicorn + collectstatic)

```bash
docker run -d -p 8000:8000 django-backend-prod
```

- Make sure `STATIC_ROOT` is set in `settings.py`:

```python
STATIC_ROOT = BASE_DIR / "staticfiles"
```

- ALLOWED_HOSTS should include your domain or `*` for testing.

---

## PostgreSQL Setup

- Create database:

```sql
CREATE DATABASE django_db;
CREATE USER django_user WITH PASSWORD 'django_pass';
ALTER ROLE django_user SET client_encoding TO 'utf8';
ALTER ROLE django_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE django_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE django_db TO django_user;
```

- Update `.env` file with DB credentials.

---

## Redis & Celery Setup

1. Install Redis:

```bash
sudo apt install redis-server
```

2. Start Redis server:

```bash
redis-server
```

3. Start Celery worker:

```bash
celery -A greatkart worker -l info
```

4. Optional: Start Celery beat for periodic tasks:

```bash
celery -A greatkart beat -l info
```

- Make sure `CELERY_BROKER_URL` is set in `.env`:

```env
CELERY_BROKER_URL=redis://localhost:6379/0
```

---

## Running Tests with Pytest

1. Install pytest:

```bash
pip install pytest pytest-django
```

2. Run tests:

```bash
pytest
```

- Output shows all passing/failing tests.
- For coverage:

```bash
pytest --cov=.
```

---

## GitHub Actions CI/CD

### Example workflow: `.github/workflows/docker-ci.yml`

```yaml
name: Django Docker CI/CD

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: 3.12
      - name: Build Docker Image
        working-directory: ./backend
        run: docker build -t django-backend-prod .
      - name: Run Tests
        working-directory: ./backend
        run: docker run --rm django-backend-prod python manage.py test
```

- Workflow automatically runs tests on push/PR.
- Can be extended to push Docker image to registry or deploy to server.

---

## Project Structure

```
django-ecommerce/
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── manage.py
│   └── greatkart/
│       ├── settings.py
│       ├── wsgi.py
│       ├── urls.py
│       └── ...
├── docker-compose.yml
├── .env
└── .github/
    └── workflows/docker-ci.yml
```

---

✅ This README gives **complete step-by-step guide** from local setup → Docker → PostgreSQL → Redis → Celery → Pytest → GitHub Actions.
