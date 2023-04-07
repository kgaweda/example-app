FROM php:8.2.4-apache-bullseye

WORKDIR /var/www/example-app

COPY ./.docker/conf/example-app.conf /etc/apache2/sites-available/000-default.conf

RUN apt-get update && apt-get install git -y zip libzip-dev

RUN docker-php-ext-install zip

COPY --from=composer:2.5.5 /usr/bin/composer /usr/bin/composer

RUN a2enmod rewrite