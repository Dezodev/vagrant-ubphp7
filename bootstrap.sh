#!/usr/bin/env bash

PASSWORD='rootv66'
mysql_config_file="/etc/mysql/my.cnf"

updateServer () {
    echo "-- Update packages --"
    sudo apt-get -q update
    sudo apt-get -qy upgrade
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
echo "mysql-server mysql-server/root_password password ${PASSWORD}" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${PASSWORD}" | debconf-set-selections
sudo apt-get -y install mysql-client mysql-server

sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}

# Allow root access from any host
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=${PASSWORD}
echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=${PASSWORD}

service mysql restart

echo "-- Install other web packages --"
sudo apt-get install -y --force-yes git-core rabbitmq-server redis-server

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

echo "-- Final steps --"
rm -f /var/www/index.html
cp -uf /vagrant/etc/index.php /var/www/index.php
