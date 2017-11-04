env_setup_path = File.expand_path("env_setup.sh", File.dirname(__FILE__))

Vagrant.require_version '>= 1.9.0'

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true

  config.vm.network "forwarded_port", guest: 8000, host: 8000
  
  config.vm.synced_folder "./", "/home/vagrant/omnibuilds.com", create: true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "omnibuilds"
    vb.memory = "2048"
  end

  config.vm.provision "shell", path: env_setup_path, privileged: false
  
end
