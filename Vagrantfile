# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"

$num_instances = 4
$instance_name_prefix = "elasticsearch"
$domain = "lab"
$enable_serial_logging = false
$share_home = false
$vb_cpuexecutioncap = 100
$shared_folders = {}


Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?('vagrant-registration')
    config.registration.manager = 'subscription_manager'
    config.registration.username = 'usuario'
    config.registration.password = 'senha'
  end
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.ssh.insert_key = true
  config.ssh.forward_agent = true

  config.vm.box = "rhel/7.2"

  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |config|
      config.vm.hostname = vm_name
      config.hostmanager.aliases = "%s.%s" % [vm_name, $domain]
      ip = "172.17.8.#{i+200}"
      config.vm.network :private_network, ip: ip 
      config.vm.provision "shell", path: "base.sh"     
      config.vm.provision "shell", path: "jdk.sh"
      config.vm.provision "shell", path: "elasticsearch.sh"
      config.vm.provision "shell", path: "http.sh"
      config.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = 512
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--name", vm_name]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{$vb_cpuexecutioncap}"]
      end

    end
  end
end