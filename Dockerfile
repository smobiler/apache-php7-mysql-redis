FROM ubuntu:16.04
MAINTAINER Colin South <colinvsouth@gmail.com>

# Initialise

WORKDIR /root/development-environment
ENV DEBIAN_FRONTEND noninteractive
RUN echo "LANG=\"en_GB.UTF-8\"" > /etc/default/locale && echo "Europe/London" > /etc/timezone && locale-gen en_GB.UTF-8 && dpkg-reconfigure locales && dpkg-reconfigure -f noninteractive tzdata

# Upgrade

RUN apt-get update && apt-get install -y apt-utils && apt-get dist-upgrade -y && apt-get install -y curl sudo git software-properties-common zsh htop

# Fetch payload

RUN git clone "https://github.com/cvsouth/apache-php7-mysql-redis.git" "/root/development-environment" && chmod 775 /root/development-environment/payload/*.sh && chmod +x /root/development-environment/payload/*.sh

# MySQL

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf
RUN echo "mysqld_safe &" > /tmp/config && \
    echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
    bash /tmp/config && \
    rm -f /tmp/config
VOLUME ["/etc/mysql", "/var/lib/mysql"]
CMD ["mysqld_safe"]
EXPOSE 3306

# Apache PHP

RUN apt-get install -y \
    apache2 \
    apache2-utils \
    php7.0 \
    libapache2-mod-php7.0 \
    php7.0-mysql \
    php7.0-curl \
    php7.0-gd \
    php7.0-dev \
    php7.0-cli \
    php7.0-json \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-xsl \
    php7.0-zip \
    php7.0-xml \
    memcached \
    php-memcache \
    imagemagick

ENV APACHE_RUN_USER    www-data
ENV APACHE_RUN_GROUP   www-data
ENV APACHE_PID_FILE    /var/run/apache2.pid
ENV APACHE_RUN_DIR     /var/run/apache2
ENV APACHE_LOCK_DIR    /var/lock/apache2
ENV APACHE_LOG_DIR     /var/log/apache2
ENV LANG               C
RUN a2enmod php7.0 && a2enmod rewrite
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN cp /root/development-environment/payload/000-default.conf /etc/apache2/sites-available/000-default.conf
VOLUME ["/var/www"]
EXPOSE 80

# Composer

RUN curl -sS https://getcomposer.org/installer | php
RUN sudo mv composer.phar /usr/local/bin/composer

# NodeJS / NPM

RUN apt-get install -y nodejs npm && npm install gulp -g

# Redis

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv C7917B12 && \
    apt-key update && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN cp /root/development-environment/payload/redis.conf /etc/redis/redis.conf

# Run scripts

RUN sed -i -e 's/\r$//' "/root/development-environment/payload/init.sh"
CMD [ "/root/development-environment/payload/init.sh" ]







