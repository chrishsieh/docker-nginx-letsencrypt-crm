# -*- mode: ruby -*-
# vi: set ft=ruby :

# Prerequisites validation

## Vagrant version
Vagrant.require_version ">= 1.7.4"

$forwarded_ports = { 80 => 80, 443 => 443}

$set_environment_variables = <<SCRIPT
tee "/etc/profile.d/myvars.sh" > "/dev/null" <<EOF
# environment variables.
# change default docker-compose load file name
export COMPOSE_FILE=docker-compose.yml
alias dc='docker-compose'
EOF
SCRIPT

# Make sure the vagrant-ignition plugin is installed
required_plugins = %w(vagrant-docker-compose vagrant-winnfsd)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  $forwarded_ports.each do |guest, host|
    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.provision "shell", inline: $set_environment_variables, run: "always"

  config.vm.provision :docker
  config.vm.provision :docker_compose,
    compose_version: "1.23.2",
    yml: "/vagrant/docker-compose.yml",
    rebuild: true,
    run: "always"
end
