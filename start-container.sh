#!/bin/sh
set -e
php /app/artisan optimize
php /app/artisan storage:link
exec "$@"
