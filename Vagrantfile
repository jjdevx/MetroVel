# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = "metrolaravel.dev"
#Url de provisioning
url = "https://raw.githubusercontent.com/aasanchez/WEbBOot/master"

# Variables de red
server_ip = "10.10.10.21"
server_cpus = "1" # Cores
server_memory = "256" # MB
server_swap = "256" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

public_folder         = "/vagrant"

Vagrant.configure(2) do |config|
  # Set server to Ubuntu 14.04
  config.vm.box = "ubuntu/trusty32"
  config.vm.box_check_update = false

  config.vm.define "MetroLaravel" do |mtL|
  end

  config.vm.hostname = hostname

  # Create a static IP
  config.vm.network "private_network", ip: server_ip
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = false
  end

  config.vm.provider :virtualbox do |vb|
    vb.name = "MetroLaravel"
    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", server_cpus]
    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  config.vm.provision "shell", path: "bootstrap.sh"
#
end
