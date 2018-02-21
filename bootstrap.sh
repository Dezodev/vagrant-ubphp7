#!/usr/bin/env bash

updateServer () {
    echo "-- Update packages --"
    sudo apt-get update
    sudo apt-get upgrade
}
updateServer

echo "-- Install tools and helpers --"
sudo apt-get install -y --force-yes python-software-properties vim htop curl git npm

echo "-- Install PPA's --"
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:chris-lea/redis-server
updateServer

echo "-- Install NodeJS --"
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "-- Install apache --"
sudo apt-get install -y --force-yes apache2 apache2-utils libapache2-mod-xsendfile
a2enmod rewrite
a2enmod env
a2enmod headers
a2enmod alias

echo "-- Install Mariadb --"
sudo apt-get install -y --force-yes mariadb-server
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
mysql -u root -proot --execute="CREATE DATABASE \`development\` CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'"
mysql -u root -proot --execute="UPDATE \`mysql\`.\`user\` SET \`Host\`='%' WHERE \`Host\`='::1' AND \`User\`='root'"
/etc/init.d/mysql restart

echo "-- Install other web packages --"
sudo apt-get install -y --force-yes git-core nodejs rabbitmq-server redis-server

echo "-- Install php 7.0 packages --"
sudo apt-get install -y --force-yes php7.0 php7.0-common php7.0-dev php7.0-json php7.0-opcache php7.0-cli libapache2-mod-php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mbstring php7.0-bcmath php7.0-zip
Update

echo "-- Configure PHP & Apache --"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini
sudo a2enmod rewrite

echo "-- Install Composer --"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "-- Install phpMyAdmin --"
wget -k https://files.phpmyadmin.net/phpMyAdmin/4.7.8/phpMyAdmin-4.7.8-english.tar.gz
sudo tar -xzvf phpMyAdmin-4.7.8-english.tar.gz -C /var/www/
sudo rm phpMyAdmin-4.7.8-english.tar.gz
sudo mv /var/www/phpMyAdmin-4.7.8-english/ /var/www/html/phpmyadmin
