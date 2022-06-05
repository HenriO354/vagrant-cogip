# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "generic/ubuntu1804"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for   updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = true  
  # config.vm.provision "shell", inline: "echo hello BeCoders!: VM has updates have been checked"
  # config.vm.provider "virtualbox" do |vb|
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.synced_folder "./cogip", "/var/www/html"
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
     vb.gui = false
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "1024"

   end
  #
  if Vagrant.has_plugin?("vagrant-vbguest") then
   config.vbguest.auto_update = false
  end
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-END
   # Update Packages
   apt-get update
   # Upgrade Packages
   apt-get upgrade -y

   # Apache
   apt-get install -y apache2

   # Enable Apache Mods
   a2enmod rewrite

   # Install PHP
   apt-get install -y php

   # PHP Apache Mod
   apt-get install -y libapache2-mod-php

   # Restart Apache
   systemctl restart apache2

   # Set MySQL Pass
   debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
   debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

   # Install MySQL
   apt-get install -y mysql-server

   # Create cogip database
   mysql -uroot -proot -e "CREATE DATABASE $DBNAME;"
   # Create non-root user and grant priviledge on cogip database
   mysql -uroot -proot -e "CREATE USER '$DBUSER'@'$DBHOST' IDENTIFIED BY '$DBPASSWD';"
   mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'$DBHOST';"
   mysql -uroot -proot -e "FLUSH PRIVILEGES;"

   # Create tables into cogip database
   mysql -uroot -proot $DBNAME < /var/www/html/database/cogip.sql
   # Insert a user into user table
   mysql -uroot -proot $DBNAME -e "INSERT INTO user(username,password,mode) VALUES('Michel','michelpassword','winner');"

   # PHP-MYSQL lib
   apt-get install -y php-mysql

   # Edit apache default config
     cp -r ./vagrant-cogip/cogip/* > /var/www/html
   # cp -r ./vagrant-cogip/cogip/ > /etc/apache2/sites-available/cogip.conf

   echo "Machine provisioned at $(date)! Welcome!"

   # Restart Apache
   systemctl restart apache2
   END
   
end
