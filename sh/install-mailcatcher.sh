#!/bin/bash

# Install dependencies
apt-get install libsqlite3-dev ruby1.9.1-dev
# Install the gem
gem install mailcatcher

# Make it start on boot
echo "@reboot $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab
update-rc.d cron defaults

# Make php use it to send mail
sudo echo "sendmail_path = /usr/bin/env $(which catchmail)" >> /etc/php/7.0/mods-available/mailcatcher.ini
# Notify php mod manager
sudo phpenmod mailcatcher

# Start it now
/usr/bin/env $(which mailcatcher) --ip=0.0.0.0
