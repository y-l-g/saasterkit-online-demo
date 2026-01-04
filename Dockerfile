FROM dunglas/frankenphp:1.11.1-builder-php8.5-trixie AS builder

COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

RUN CGO_ENABLED=1 \
    XCADDY_SETCAP=1 \
    XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx" \
    CGO_CFLAGS="-D_GNU_SOURCE $(php-config --includes)" \
    CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
    xcaddy build \
        --output /usr/local/bin/frankenphp \
        --with github.com/dunglas/frankenphp=./ \
        --with github.com/dunglas/frankenphp/caddy=./caddy/ \
        --with github.com/dunglas/caddy-cbrotli \
        --with github.com/y-l-g/scheduler/module \
        --with github.com/y-l-g/queue/module

FROM serversideup/php:8.5-frankenphp-trixie

ARG VITE_STRIPE_PRICE_PRO_MONTH
ARG VITE_STRIPE_PRICE_PRO_YEAR
ARG VITE_STRIPE_PRICE_PREMIUM_MONTH
ARG VITE_STRIPE_PRICE_PREMIUM_YEAR
ARG VITE_APP_NAME
ARG VITE_APP_URL

USER root

COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp

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

