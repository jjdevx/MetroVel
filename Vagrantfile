# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = "metrolaravel.io"

#Url de provisioning
url = "https://raw.githubusercontent.com/aasanchez/WEbBOot/master"

# Variables de red
server_ip = "192.168.1.251"
server_cpus = "1" # Cores
server_memory = "64" # MB
server_swap = "64" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

#Configuraciones del Sistema
server_timezone  = "UTC"

# Languages and Packages
php_timezone = "UTC" # http://php.net/manual/en/timezones.php
php_version = "5.6" # Options: 5.5 | 5.6
# To install HHVM instead of PHP, set this to "true"
hhvm = "false"

public_folder         = "/vagrant"

nodejs_version = "latest" # By default "latest" will equal the latest stable version

# Database Configuration
ddbb_root_password = "root"

composer_packages = [ # List any global Composer packages that you want to install
  # "phpspec/phpspec:2.0.*@dev",
  # "squizlabs/php_codesniffer:1.5.*",
]

Vagrant.configure(2) do |config|
  # Set server to Ubuntu 14.04
  config.vm.box = "ubuntu/trusty32"
  config.vm.box_check_update = false

  config.vm.define "MetroLaravel" do |jel|
  end

  config.vm.hostname = hostname

  # Create a static IP
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.name = "MetroLaravel"
    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", server_cpus]
    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  # Entonamiento Basico del Sistema Operativo
  config.vm.provision "shell", path: "#{url}/scripts/base.sh", args: [url, server_swap, server_timezone]
  config.vm.provision "shell", path: "#{url}/scripts/php.sh", args: [php_timezone, hhvm, php_version]
  config.vm.provision "shell", path: "#{url}/scripts/nodejs.sh"

  ####
  # Web Servers
  ##########
  # Provision Nginx Base
  config.vm.provision "shell", path: "#{url}/scripts/nginx.sh", args: [server_ip, public_folder, hostname, url]

  ##########
  # Databases
  ##########
  # Provision PostgreSQL
  config.vm.provision "shell", path: "#{url}/scripts/pgsql.sh", args: ddbb_root_password

  ##########
  # Utiles
  ##########
  # Provision Composer
  config.vm.provision "shell", path: "#{url}/scripts/composer.sh", privileged: false, args: composer_packages.join(" ")

  config.vm.provision "shell",
      inline: "npm install -g bower",
      inline: "cd /vagrant && bower install",
      inline: "cd /vagrant && composer install"
#
end
