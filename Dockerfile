FROM serversideup/php:8.5-frankenphp-trixie

ARG VITE_STRIPE_PRICE_PRO_MONTH
ARG VITE_STRIPE_PRICE_PRO_YEAR
ARG VITE_STRIPE_PRICE_PREMIUM_MONTH
ARG VITE_STRIPE_PRICE_PREMIUM_YEAR
ARG VITE_APP_NAME
ARG VITE_APP_URL

USER root

RUN install-php-extensions bcmath intl gd exif ftp \
    && curl -fsSL https://deb.nodesource.com/setup_25.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && rm nodesource_setup.sh

USER www-data

COPY --chown=www-data:www-data . .

RUN composer install -v \
    # --no-dev \
    --optimize-autoloader \
    --no-scripts \
    --prefer-dist \
    --classmap-authoritative \
    && npm ci && npm run build:ssr

