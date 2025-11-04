#!/bin/sh
set -e
cp /run/secrets/${APP_NAME}_ENV .env
npm run build:ssr
sed -i 's/payload: { serverRendered: false }/payload: { serverRendered: typeof window === "undefined"}/g' node_modules/@nuxt/ui/dist/runtime/inertia/stubs.js
php /app/artisan optimize
php /app/artisan storage:link
exec "$@"
