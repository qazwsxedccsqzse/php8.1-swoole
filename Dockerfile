FROM phusion/baseimage:focal-1.0.0alpha1-amd64
CMD ["/sbin/my_init"]
RUN apt-get update && apt-get install -y software-properties-common wget tar make libpcre3 libpcre3-dev openssl libssl-dev supervisor
WORKDIR /root
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
apt-get update && \
apt-get install -y nodejs \
php8.1-cli \
php8.1-common \
php8.1 \
php8.1-mysql \
php8.1-fpm \
php8.1-curl \
php8.1-bz2 \
php8.1-cgi \
php8.1-mbstring \
php8.1-gd \
php-imagick \
php-memcache \
php-pear \
php8.1-xml \
php8.1-dev \
php8.1-bcmath \
php8.1-zip \
php8.1-dom && \
printf "\n" | pecl install swoole && \
pecl install redis && \
echo "extension=swoole.so" >> /etc/php/8.1/cli/php.ini && \
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer
