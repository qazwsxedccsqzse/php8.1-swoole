FROM phusion/baseimage:focal-1.2.0
CMD ["/sbin/my_init"]
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && apt-get install -y software-properties-common wget tar make libpcre3 libpcre3-dev openssl libssl-dev supervisor
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18 && apt-get install -y unixodbc-dev
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
printf "\n" | wget https://github.com/swoole/swoole-src/archive/v4.8.11.tar.gz && \
tar zxfv v4.8.11.tar.gz && rm -rf v4.8.11.tar.gz && \
cd /root/swoole-src-4.8.11 && \
phpize && ./configure && make clean && make install && \
pecl install redis && \
pecl install sqlsrv && \
pecl install pdo_sqlsrv && \
echo "extension=swoole.so\n" >> /etc/php/8.1/cli/php.ini && \
printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.1/mods-available/sqlsrv.ini && \
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.1/mods-available/pdo_sqlsrv.ini && \
phpenmod -v 8.1 sqlsrv pdo_sqlsrv && \
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer && \
cd /root && rm -rf swoole-src-4.8.11