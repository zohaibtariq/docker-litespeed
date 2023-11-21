# Use an official LiteSpeed image with PHP 8.1
#FROM litespeedtech/litespeed-php:8.1
FROM litespeedtech/litespeed:6.0.12-lsphp81

#FROM muncherelli/openlitespeed
#FROM eurobertics/openlitespeed

# Set environment variables for Laravel
ENV APP_NAME="laravel" \
    APP_ENV=production \
    APP_KEY=base64:your_app_key_here \
    APP_DEBUG=false \
    APP_URL=http://localhost \
    DB_CONNECTION=mongodb \
    DB_HOST=mongodb \
    DB_PORT=27017 \
    DB_DATABASE=laravel \
    DB_USERNAME=laravel \
    DB_PASSWORD=secret \
    CACHE_DRIVER=redis \
    QUEUE_CONNECTION=redis

# Install required extensions and development tools
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        libssl-dev \
        zlib1g-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libmcrypt-dev \
        libicu-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        unzip \
        git

#ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
#RUN install-php-extensions \
#pdo_mysql \
#zip \
#mongodb
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install pecl
#RUN curl -O https://pear.php.net/go-pear.phar \
#    && /usr/local/lsws/lsphp81/bin/php go-pear.phar \
#    && rm go-pear.phar

#RUN  docker-php-ext-install pdo_mysql \
#    && pecl install mongodb \
#    && docker-php-ext-enable mongodb \
#    && pecl install redis \
#    && docker-php-ext-enable redis

# Install MongoDB extension
#RUN /usr/local/lsws/lsphp81/bin/pecl install mongodb \
#    && echo "extension=mongodb.so" > /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/mongodb.ini \
#    && ln -s /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/mongodb.ini /usr/local/lsws/lsphp81/etc/php/8.1/conf.d/20-mongodb.ini

# Install Redis extension
#RUN /usr/local/lsws/lsphp81/bin/pecl install redis \
#    && echo "extension=redis.so" > /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/redis.ini \
#    && ln -s /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/redis.ini /usr/local/lsws/lsphp81/etc/php/8.1/conf.d/20-redis.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up Apache LiteSpeed configuration
COPY litespeed-config/httpd.conf /usr/local/lsws/conf/
COPY litespeed-config/vhosts/laravel.conf /usr/local/lsws/conf/vhosts/laravel.conf
COPY litespeed-config/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf

# Install Laravel
#RUN composer create-project --prefer-dist laravel/laravel /var/www/html

# Set up Laravel project
# COPY laravel/ /var/www/html/

# Set working directory to the web root
#WORKDIR /var/www/html

# Clone the latest Laravel repository
#RUN git clone --depth=1 https://github.com/laravel/laravel .

# Install Laravel dependencies
#RUN composer install --no-dev --optimize-autoloader

# Set up volumes
#VOLUME ["/var/www/html/storage", "/var/www/html/bootstrap/cache"]
#VOLUME ["/var/www/html"]

# Expose LiteSpeed and PHPMyAdmin ports
EXPOSE 80 443

# Start LiteSpeed
CMD ["/usr/local/lsws/bin/lswsctrl", "start"]
