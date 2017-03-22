# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version">= 1.5.0"
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # mint-17.3 rosa LTS
  # config.vm.box = "artem-sidorenko/mint-17.3-cinnamon"
  # mint-18.0 sarah LTS
  # config.vm.box = "boxcycler/waymeet"
  # debian 8
  # config.vm.box = "debian/jessie64"
  # datascienceatthecommandline
  config.vm.box = "data-science-toolbox/data-science-at-the-command-line"
  # local boxes
  # config.vm.box = "box/dst-dsatcl-1.0.0.box"
  # config.vm.box = "box/mint-17.3-0.0.2.box"
  
  # proxy setting
  # config.proxy.http     = "http://proxy-internet.localnet:3128"
  # config.proxy.https    = "http://proxy-internet.localnet:3128"
  # config.proxy.no_proxy = "localhost,127.0.0.1"
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8888, host: 8888	# jupyter
  config.vm.network "forwarded_port", guest: 6006, host: 6006	# tensorboard
  config.vm.network "forwarded_port", guest: 8787, host: 8787	# rstudio-server
  

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
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
	# vb.gui = true
	# Customize the amount of memory on the VM:
	vb.memory = 4096
	vb.cpus = 3
	
	# Add a new disk:
	# file_to_disk = File.realpath( "." ).to_s + "/disk.vdi"
    # if ARGV[0] == "up" && ! File.exist?(file_to_disk) 
      # puts "Creating 5GB disk #{file_to_disk}."
      # vb.customize [
        # 'createhd', 
        # '--filename', file_to_disk, 
        # '--format', 'VDI', 
        # '--size', 5000 * 1024 # 5 GB
      # ] 
      # vb.customize [
        # 'storageattach', :id, 
		# '--storagectl', 'SATA Controller',
        # '--port', 1, '--device', 0, 
        # '--type', 'hdd', '--medium', 
        # file_to_disk
      # ]
	# end
			
  end
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  # SHELL
  config.vm.provision "shell", path: "scripts/bootstrap.sh", privileged: false
  # config.vm.provision "shell", path: "scripts/add_new_disk.sh"
end
