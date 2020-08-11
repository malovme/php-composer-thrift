ARG PHP_VERSION=7.4
ARG COMPOSER_VERSION=latest
ARG THRIFT_VERSION=0.12.0

FROM composer:${COMPOSER_VERSION} AS composer
FROM thrift:${THRIFT_VERSION} AS thrift
FROM php:${PHP_VERSION}

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=thrift /usr/local/bin/thrift /usr/local/bin/thrift
