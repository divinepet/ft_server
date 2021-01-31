service mysql start

# setting access
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# setting SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=RU/ST=Kazan/L=Kazan City/O=School21/OU=elaronda Inc/CN=mainserver/E=user@example.com"
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# setting MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password


service php7.3-fpm start
service nginx start
bash
