#!/bin/sh
set -e
cp /run/secrets/${APP_NAME}_ENV .env
php /app/artisan optimize
php /app/artisan storage:link
exec "$@"
