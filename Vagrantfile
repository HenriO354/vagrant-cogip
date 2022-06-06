# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # Box settings
  config.vm.box = "ubuntu/focal64"
  
  # Provider settings
  config.vm.provider "virtualbox" do |vb|
    # customize VM name
    vb.name = "cogipapp"
    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  end

  # Network settings
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "192.168.56.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  #Synced Folder settings
  config.vm.synced_folder "./cogip", "/var/www/html"
  # config.vm.synced_folder "./config", "/etc/apache2/sites-available"

  # Provision settings
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", path: "bootstrap.sh"
end