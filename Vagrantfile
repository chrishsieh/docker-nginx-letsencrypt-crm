# -*- mode: ruby -*-
# vi: set ft=ruby :

# Prerequisites validation

## Vagrant version
Vagrant.require_version ">= 1.7.4"

# Make sure the vagrant-ignition plugin is installed
required_plugins = %w(vagrant-docker-compose)

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
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision :docker
  config.vm.provision :docker_compose,
    compose_version: "1.23.1",
    yml: "/vagrant/docker-compose.yml",
    run: "always"
end
