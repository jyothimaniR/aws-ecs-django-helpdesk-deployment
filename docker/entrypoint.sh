#!/bin/bash
set -e

echo "Starting Django Helpdesk..."

# Wait for database to be ready
echo "Waiting for database..."
while ! pg_isready -h ${POSTGRES_HOST:-db} -p ${POSTGRES_PORT:-5432} -U ${POSTGRES_USER:-helpdesk}; do
    echo "Database not ready, waiting..."
    sleep 2
done
echo "Database is ready!"

# Run migrations
echo "Running database migrations..."
cd /opt/django-helpdesk/standalone/
python3 manage.py migrate --noinput

# Create superuser if it doesn't exist (for initial setup)
echo "Checking for superuser..."
python3 manage.py shell << PYTHON_CODE
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', '${ADMIN_PASSWORD:-changeme}')
    print("Superuser created!")
else:
    print("Superuser already exists")
PYTHON_CODE

# Start Gunicorn
echo "Starting Gunicorn web server..."
exec gunicorn standalone.config.wsgi:application \
    --name django-helpdesk \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers ${GUNICORN_WORKERS:-3} \
    --timeout ${GUNICORN_TIMEOUT:-60} \
    --log-level=${LOG_LEVEL:-info} \
    --access-logfile=- \
    --error-logfile=- \
    "$@"
