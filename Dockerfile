# syntax=docker/dockerfile:1
FROM ubuntu:22.04 AS base

# ----------------------------
# Step 1: Prepare Environment
# ----------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    php8.1-fpm \
    php-mysql \
    php-cli \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip \
    supervisor \
    curl \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Step 2: Configure Files
# ----------------------------

# Supervisor
COPY support/docker/supervisord.conf /etc/supervisord.conf

# Nginx
COPY support/services/nginx/default.conf /etc/nginx/sites-available/default
COPY support/services/nginx/index.php /var/www/html
# Optional: ensure PHP and NGINX run as www-data
RUN chown -R www-data:www-data /var/www/html

# ----------------------------
# Step 3: Expose and Run
# ----------------------------
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]