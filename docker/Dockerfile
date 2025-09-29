# Production Dockerfile for Django Helpdesk
FROM python:3.11-slim-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    postgresql-client \
    libpq-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy UV package manager
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /opt

# Clone django-helpdesk from your forked repo
ARG HELPDESK_REPO=https://github.com/jyothimaniR/django-helpdesk.git
RUN git clone ${HELPDESK_REPO} django-helpdesk

# Install Python dependencies
WORKDIR /opt/django-helpdesk
ENV UV_SYSTEM_PYTHON=1
RUN pip3 install --upgrade pip && \
    pip3 install packaging && \
    uv sync && \
    uv pip install -r standalone/requirements.txt

# Set working directory to standalone
WORKDIR /opt/django-helpdesk/standalone

# Set environment variables
ENV DJANGO_SETTINGS_MODULE=standalone.config.settings
ENV PYTHONPATH=/opt/django-helpdesk/src:/opt/django-helpdesk
ENV PYTHONUNBUFFERED=1

# Collect static files
RUN DJANGO_HELPDESK_SECRET_KEY=build-time-dummy python3 manage.py collectstatic --noinput

# Create non-root user for security
RUN useradd -m -u 1000 helpdesk && \
    mkdir -p /data/media /data/static && \
    chown -R helpdesk:helpdesk /opt/django-helpdesk /data

# Copy entrypoint script
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh && \
    chown helpdesk:helpdesk /opt/entrypoint.sh

# Switch to non-root user
USER helpdesk

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:8000', timeout=5)" || exit 1

ENTRYPOINT ["/opt/entrypoint.sh"]
