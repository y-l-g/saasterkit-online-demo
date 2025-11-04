FROM dunglas/frankenphp:1-php8.4

ENV COMPOSER_ALLOW_SUPERUSER=1

ENV PHP_INI_SCAN_DIR=":$PHP_INI_DIR/app.conf.d"

WORKDIR /app

RUN set -eux; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
    acl \
    file \
    gettext \
    procps \
    cron \
    nano \
    mariadb-client \
    && curl -fsSL https://deb.nodesource.com/setup_25.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && rm nodesource_setup.sh \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean

RUN set -eux; \
	install-php-extensions \
		@composer \
		pcntl \
        pdo_mysql \
        redis \
        opcache \
        intl \
        zip \
        ftp \
        bcmath

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY <<EOT $PHP_INI_DIR/app.conf.d/php.ini
    expose_php = 0
    date.timezone = UTC
    apc.enable_cli = 1
    session.use_strict_mode = 1
    zend.detect_unicode = 0
    realpath_cache_size = 4096K
    realpath_cache_ttl = 600
    opcache.interned_strings_buffer = 16
    opcache.max_accelerated_files = 20000
    opcache.memory_consumption = 256
    opcache.enable_file_override = 1
    opcache.validate_timestamps = 0
EOT

COPY --link --chmod=755 start-container.sh /usr/local/bin/start-container

COPY --link composer.json composer.lock ./

COPY --link package.json package-lock.json ./

RUN composer install -v \
    # --no-dev \
    --no-interaction \
    --no-autoloader \
    --no-ansi \
    --no-scripts

RUN npm ci

COPY --link . ./

RUN composer dump-autoload \
    # --no-dev \
    --classmap-authoritative \
    --optimize \
    --no-ansi \
    && composer clear-cache

RUN npm run build:ssr

RUN echo "* * * * * /usr/local/bin/php /app/artisan schedule:run >> /var/log/cron.log 2>&1" > /etc/cron.d/schedule
RUN chmod 0644 /etc/cron.d/schedule


