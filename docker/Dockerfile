# Use a imagem base do PHP 8.3 com PHP-FPM baseada no Debian Buster
FROM php:8.3-fpm AS watchlive_php

# Instale quaisquer extensões PHP necessárias
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Atualize o sistema e instale pacotes essenciais
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nano \
    vim \
    npm \
    default-mysql-client \
    zabbix-agent \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Modifique o php.ini diretamente
RUN echo "memory_limit=1024M" >> /usr/local/etc/php/conf.d/memory-limit.ini

# Instale o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instale o Node.js e o npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install -y nodejs

# Remove vendor and node_modules directories
RUN rm -rf vendor node_modules

# Ensure composer.json exists before running composer install
RUN if [ -f composer.json ]; then composer install; else echo "composer.json not found"; fi

# Ensure package.json exists before running npm install
RUN if [ -f package.json ]; then npm install; else echo "package.json not found"; fi

# Copy the rest of the application code
COPY . .

# Copie o arquivo de configuração do PHP-FPM
COPY php/php-fpm.conf /etc/php8.3/php-fpm.d/www.conf

# Defina o diretório de trabalho
WORKDIR /var/www/html

# Configure o Zabbix Agent para Auto Registration
RUN echo "Server=zabbix_server" >> /etc/zabbix/zabbix_agentd.conf && \
    echo "Hostname=watchlive_php" >> /etc/zabbix/zabbix_agentd.conf

# Exponha o volume onde o código será montado
VOLUME /var/www/html

# Comando para iniciar o Zabbix Agent e o PHP-FPM
CMD service zabbix-agent start && php-fpm

# Use a imagem base Nginx
FROM alfg/nginx-rtmp AS watchlive_nginx

# Instale o PHP 8 e outras dependências necessárias
RUN apk add --no-cache \
    bash \
    ffmpeg \
    curl \
    composer \
    nano \
    make \
    vim

# Installing bash
RUN apk add --no-cache bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Crie o usuário 'nginx' com UID 101
RUN adduser -D -u 101 nginx

# Crie o diretório de log do NGINX e defina as permissões adequadas
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/error.log && \
    chown -R nginx:nginx /var/log/nginx && \
    chmod -R 755 /var/log/nginx

# Crie o diretório de trabalho do aplicativo
WORKDIR /var/www/html

# Copie o arquivo de configuração do Nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copie o aplicativo para o diretório de trabalho
COPY app /var/www/html

# Cópia o diretório stream para /hls/live do NGINX e defina as permissões adequadas
RUN mkdir -p /var/hls/live && \
    chown -R nginx:nginx /var/hls/live && \
    chmod -R 777 /var/hls/live    

RUN apk add --no-cache zabbix-agent

# Configure o Zabbix Agent para Auto Registration
RUN echo "Server=zabbix_server" >> /etc/zabbix/zabbix_agentd.conf && \
    echo "Hostname=watchlive_nginx" >> /etc/zabbix/zabbix_agentd.conf

# Exponha a porta 80 para o Nginx e a porta 1935 para o RTMP
EXPOSE 80 1935 10050

# Inicia o Nginx
CMD zabbix_agentd && nginx -g 'daemon off;'

FROM mariadb:latest AS watchlive_database

RUN apt-get update \
    && apt-get install -y  mariadb-client nano vim \
    && rm -rf /var/lib/apt/lists/*

FROM phpmyadmin:latest AS watchlive_pma

FROM dbeaver/cloudbeaver:latest AS watchlive_dbeaver

FROM postgres:latest AS zabbix_database

FROM zabbix/zabbix-server-pgsql:latest AS zabbix_server

RUN cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server_old.conf && \
    echo "StartConnectors=5" >> /etc/zabbix/zabbix_server.conf

FROM zabbix/zabbix-web-nginx-pgsql:latest AS zabbix_frontend

FROM zabbix/zabbix-agent:latest AS zabbix_agent

RUN cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd_old.conf && \
    echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> /etc/zabbix/zabbix_agentd.conf