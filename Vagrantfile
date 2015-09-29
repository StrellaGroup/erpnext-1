# -*- mode: ruby -*-
# vi: set ft=ruby :

#require "yaml"
#require "json"

# Install CHEF and Ruby on the box
overrides = "#{__FILE__}.local"
if File.exist?(overrides)
    eval File.read(overrides)
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
Vagrant.require_version ">= 1.6.0"

unless Vagrant.has_plugin?("vagrant-docker-compose")
  raise "This project requires vagrant-docker-compose as a plugin installed. You can install it by 'vagrant plugin install vagrant-docker-compose'"
end

VAGRANTFILE_API_VERSION = "2"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = defined?(BOX) ? BOX : "ubuntu/trusty64"
  config.vm.hostname = defined?(HOSTNAME) ? HOSTNAME : "demo.localhost.com"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: defined?(IP) ? IP : "192.168.33.10"  

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  
  # accelerate file system calls using NFS -> for windows you need vagrant-winnfsd vagrant plugin
  NFS = ( defined?(USE_NFS) ? USE_NFS : true ) && ( RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/ || Vagrant.has_plugin?("vagrant-winnfsd") )
  
  # config.vm.synced_folder "./data", "/vagrant_data", :nfs => NFS
  # config.vm.synced_folder "./src", "/opt/project/src", :nfs => NFS  
  # config.vm.synced_folder ".", "vagrant", :nfs => NFS  

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  config.vm.provider "virtualbox" do |vb|
	# Don't boot with headless mode
    vb.gui = defined?(GUI) ? GUI : false
  
    # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", defined?(MEMORY) ? MEMORY : "2048"]
	  vb.customize ["modifyvm", :id, "--cpus", defined?(CPU) ? CPU : "2"] 
  end   
  
  config.vm.provision :docker
  config.vm.provision :docker_compose, yml: "/vagrant/docker-compose.yml", rebuild: false, run: "always"
  
end
