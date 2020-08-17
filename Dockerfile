ARG PHP_VERSION=7.4
ARG COMPOSER_VERSION=1.10.10

FROM composer:${COMPOSER_VERSION} AS composer
FROM php:${PHP_VERSION}

ARG THRIFT_VERSION=0.13.0

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y --no-install-recommends ssh git curl gnupg libzip-dev zip unzip

RUN docker-php-ext-install zip

# thrift build dependencies
RUN buildDeps=" \
        automake \
        bison \
        flex \
        g++ \
        libboost-dev \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libboost-test-dev \
        libevent-dev \
        libssl-dev \
        libtool \
        make \
        pkg-config \
    "; \
    apt-get install -y --no-install-recommends $buildDeps

# thrift
RUN curl -k -sSL "https://github.com/apache/thrift/archive/${THRIFT_VERSION}.tar.gz" -o thrift.tar.gz \
    && mkdir -p /usr/src/thrift \
	&& tar zxf thrift.tar.gz -C /usr/src/thrift --strip-components=1 \
	&& rm thrift.tar.gz \
	&& cd /usr/src/thrift \
	&& ./bootstrap.sh \
	&& ./configure --disable-libs \
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf /usr/src/thrift \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/cache/apt/* \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* \
	&& rm -rf /var/tmp/*
