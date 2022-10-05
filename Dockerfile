FROM serversideup/php:beta-8.1-fpm-nginx as base

# Copy the application
FROM base as deploy
COPY --chown=9999:9999 . /var/www/html