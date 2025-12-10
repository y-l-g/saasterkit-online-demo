#!/bin/sh
set -e
php artisan migrate --force
php /app/artisan optimize
php /app/artisan storage:link
exec "$@"
