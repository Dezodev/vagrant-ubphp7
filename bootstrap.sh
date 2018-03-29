#!/usr/bin/env bash
WHI='\033[1;37m'
NC='\033[0m' # No Color

PASSWORD='rootv66'
mysql_config_file="/etc/mysql/my.cnf"

updateServer () {
    echo -e "${WHI}-- Update packages --${NC}"
    sudo apt-get -q update
    sudo apt-get -qy upgrade
}
updateServer

echo -e "${WHI}-- Install tools and helpers --${NC}"
sudo apt-get install -y --force-yes python-software-properties vim htop curl git

echo -e "${WHI}-- Install PPA's --${NC}"
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:chris-lea/redis-server
updateServer

echo -e "${WHI}-- Install NodeJS --${NC}"
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

echo -e "${WHI}-- Install apache --${NC}"
sudo apt-get install -y --force-yes apache2 apache2-utils libapache2-mod-xsendfile
a2enmod rewrite
a2enmod env
a2enmod headers
a2enmod alias

echo -e "${WHI}-- Install Mysql --${NC}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASSWORD}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASSWORD}"
sudo apt-get -y install mysql-server-5.6

sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}

# Allow root access from any host
sudo echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=${PASSWORD}
sudo echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=${PASSWORD}

service mysql restart

echo -e "${WHI}-- Install other web packages --${NC}"
sudo apt-get install -y --force-yes git-core rabbitmq-server redis-server

echo -e "${WHI}-- Install php 7.0 packages --${NC}"
sudo apt-get install -y --force-yes php7.0 php7.0-common php7.0-dev php7.0-json php7.0-opcache php7.0-cli libapache2-mod-php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mbstring php7.0-bcmath php7.0-zip
Update

echo -e "${WHI}-- Configure PHP & Apache --${NC}"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini
sudo a2enmod rewrite

echo -e "${WHI}-- Creating virtual hosts --${NC}"
# setup hosts file
VHOST=$(cat <<EOF
<Directory "/var/www/">
    AllowOverride All
</Directory>
<VirtualHost *:80>
    DocumentRoot /var/www/vagrant/local
    ServerName local.test
</VirtualHost>
<VirtualHost *:80>
    DocumentRoot /var/www/phpmyadmin
    ServerName phpmyadmin.local.test
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart

echo -e "${WHI}-- Install Composer --${NC}"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo -e "${WHI}-- Install phpMyAdmin --${NC}"
wget -k https://files.phpmyadmin.net/phpMyAdmin/4.7.8/phpMyAdmin-4.7.8-english.tar.gz
sudo tar -xzvf phpMyAdmin-4.7.8-english.tar.gz -C /var/www/
sudo rm phpMyAdmin-4.7.8-english.tar.gz
sudo mv /var/www/phpMyAdmin-4.7.8-english/ /var/www/phpmyadmin
sudo rm -rf /var/www/phpMyAdmin-4.7.8-english/

echo -e "${WHI}-- Final steps --${NC}"
sudo mkdir /var/www/vagrant/local
cp -uf /vagrant/etc/index.php /var/www/vagrant/local/index.php
sudo usermod -a -G vagrant www-data
