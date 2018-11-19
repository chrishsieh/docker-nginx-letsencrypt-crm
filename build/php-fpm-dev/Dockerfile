FROM php:fpm

ENV DEBCONF_NOWARNINGS yes

RUN apt-get update && \
    apt-get install -y gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get install -y \
        gettext jq figlet \
        zip git ruby-full nodejs \
        libpng-dev \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libicu-dev locales locales-all && \
    apt-get install -y curl cmake && \
    mkdir /tmp/libzip && cd /tmp/libzip && curl -sSLO https://libzip.org/download/libzip-1.5.1.tar.gz && \
    tar zxf libzip-1.5.1.tar.gz && cd libzip-1.5.1/ && mkdir build && cd build && cmake ../ && \
    make > /dev/null && make install && \
    docker-php-ext-configure zip \
        --with-libzip=/usr/local/lib/libzip.so && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} \
        intl gettext mysqli pdo_mysql exif gd zip && \
    pecl channel-update pecl.php.net && pecl install mcrypt-1.0.1 && \
        docker-php-ext-enable mcrypt && \
    apt-get purge -y \
        libpng-dev \
        libzip-dev \
        libfreetype6-dev \
        libicu-dev cmake && \
    apt-get autoremove -y && \
    npm i npm@latest -g && \
    composer self-update && \
    gem install sass -v 3.4.25

COPY ./presetup /usr/local/bin
COPY ./php.ini /usr/local/etc/php/
RUN chmod +x /usr/local/bin/presetup

# Set work directory to the web host path
WORKDIR /var/www

# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD ["php-fpm"]
