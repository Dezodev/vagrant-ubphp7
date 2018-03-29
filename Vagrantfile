# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
configs     = YAML.load_file("#{current_dir}/etc/config.yaml")

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    # Mount shared folder
    config.vm.synced_folder ".", "/vagrant", id: "core"
    config.vm.synced_folder "./sites", "/var/www/vagrant",
        owner: "vagrant",
        group: "www-data",
        mount_options: ["dmode=775,fmode=664"]


    # Network configuration
    config.vm.network "private_network", ip: configs['configs']['general']['public_ip']
    config.vm.hostname = "ubphpbox"
    config.hostsupdater.aliases = ["local.test", "phpmyadmin.local.test"]

    # SSH configuration
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"

    # Forwarded port
    config.vm.network "forwarded_port", guest: 22, host: 2222

    # Performance configuaration
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 2048]
        vb.customize ["modifyvm", :id, "--cpus", 2]
    end

    # Provision
    config.vm.provision :shell, inline: "debconf-set-selections <<< 'mariadb-server mysql-server/root_password password ${configs[configs][general][mysql_root_pwd]}'; debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password ${configs[configs][general][mysql_root_pwd]}'"
    config.vm.provision :shell, :path => "bootstrap.sh"
end