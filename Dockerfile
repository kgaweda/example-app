FROM php:8.2.4-apache-bullseye as base

WORKDIR /var/www/example-app

RUN apt-get update && apt-get install -y zip libzip-dev 
RUN docker-php-ext-install zip pdo_mysql mysqli 

COPY ./.docker/conf/example-app.conf /etc/apache2/sites-available/000-default.conf

FROM base as vendor

COPY --from=composer:2.5.5 /usr/bin/composer /usr/bin/composer

COPY composer.* /var/www/example-app

RUN composer install --optimize-autoloader  --no-scripts

FROM base as prod

COPY --chown=www-data:www-data . /var/www/example-app

COPY --chown=www-data:www-data --from=vendor /var/www/example-app/vendor /var/www/example-app/vendor

RUN cp .env.example .env

RUN chmod -R 775 storage

RUN a2enmod rewrite