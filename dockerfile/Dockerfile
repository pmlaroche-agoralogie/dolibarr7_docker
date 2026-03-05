FROM php:7.2-apache

# Utiliser les archives Debian pour Buster (plus maintenu)
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && sed -i 's|archive.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list \
    && sed -i '/buster-updates/d' /etc/apt/sources.list \
    && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Installation des extensions PHP nécessaires pour Dolibarr
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libldap2-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configuration et installation des extensions PHP
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        ldap \
        soap \
        calendar \
        mbstring \
        curl

# Installation de l'extension imap
RUN apt-get update && apt-get install -y \
    libc-client-dev \
    libkrb5-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

# Activation du module Apache rewrite
RUN a2enmod rewrite

# Configuration PHP pour Dolibarr
RUN echo "upload_max_filesize = 50M" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "date.timezone = Europe/Paris" >> /usr/local/etc/php/conf.d/dolibarr.ini

# Configuration Apache
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/dolibarr.conf \
    && a2enconf dolibarr

# Définir le répertoire de travail
WORKDIR /var/www/html

# Droits sur le répertoire documents
RUN mkdir -p /var/www/html/documents \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
