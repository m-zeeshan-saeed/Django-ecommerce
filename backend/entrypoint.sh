#!/bin/sh

echo "Waiting for database to be ready..."
python manage.py wait_for_db 2>/dev/null || sleep 2

echo "Creating migrations..."
python manage.py makemigrations --noinput

echo "Applying migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput --clear 2>/dev/null || echo "Static files collection skipped"

echo "Starting server..."
python manage.py runserver 0.0.0.0:8000
