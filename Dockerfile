FROM debian:buster

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y mariadb-server mariadb-client nginx wget php-fpm vim openssl
RUN apt-get install -y php php-fpm php-mysql
RUN apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

#НАСТРОЙКА PHPMYADMIN
WORKDIR ./var/www/mainsite
COPY ./srcs/index.html .
RUN	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN	tar -xf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN	mv phpMyAdmin-5.0.4-all-languages phpmyadmin
RUN mv phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php
RUN chmod 660 phpmyadmin/config.inc.php
RUN chown -R www-data:www-data /var/www/mainsite/phpmyadmin
WORKDIR ./phpmyadmin
COPY ./srcs/config.inc.php .

#НАСТРОЙКА WORDPRESS
WORKDIR ../
RUN wget https://ru.wordpress.org/latest-ru_RU.tar.gz
RUN tar -xf latest-ru_RU.tar.gz
RUN rm -rf latest-ru_RU.tar.gz
WORKDIR ./wordpress
COPY ./srcs/wp-config.php .

#НАСТРОЙКА NGINX
WORKDIR ../../../../etc/nginx/sites-available/
COPY ./srcs/default .

#НАСТРОЙКА SSL
WORKDIR ../snippets/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=RU/ST=Kazan/L=Kazan City/O=School21/OU=elaronda Inc/CN=mainserver"
RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 256
COPY ./srcs/self-signed.conf .
COPY ./srcs/ssl-params.conf .

EXPOSE 80 443

COPY ./srcs/init_container.sh ./

CMD bash init_container.sh