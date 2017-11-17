# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false

  config.vm.define :elasticsearch do |es|
    es.vm.box = "CentOS_1706_v0.2.0"
    es.vm.hostname = "charlie"
    #es.vm.network "private_network", ip:"192.168.100.40"
    es.vm.network "public_network", bridge: "eno1", ip:"192.168.130.251", netmask: "255.255.255.0"
    es.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "elasticsearch_server" ]
    end
    es.vm.provision :chef_solo do |chef|
        chef.install = false
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "elasticsearch"
    end
  end

  config.vm.define :logstash do |log|
    log.vm.box = "CentOS_1706_v0.2.0"
    log.vm.hostname = "bravo"
    #log.vm.network "private_network", ip:"192.168.100.30"
    log.vm.network "public_network", bridge: "eno1", ip:"192.168.130.252", netmask: "255.255.255.0"
    log.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "logstash_server"]
    end
    log.vm.provision :chef_solo do |chef|
	    chef.install = false
	    chef.cookbooks_path = "cookbooks"
	    chef.add_recipe "logstash"
    end
  end

  config.vm.define :kibana do |kib|
    kib.vm.box = "CentOS_1706_v0.2.0"
    kib.vm.hostname = "delta"
    #kib.vm.network "private_network", ip:"192.168.100.50"
    kib.vm.network "public_network", bridge: "eno1", ip:"192.168.130.253", netmask: "255.255.255.0"
    kib.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "kibana_server" ]
    end
    kib.vm.provision :chef_solo do |chef|
        chef.install = false
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "kibana"
    end
  end

  config.vm.define :filebeat do |file|
    file.vm.box = "CentOS_1706_v0.2.0"
    file.vm.hostname = "alpha"
    #file.vm.network "private_network", ip:"192.168.100.20"
    file.vm.network "public_network", bridge: "eno1", ip:"192.168.130.254", netmask: "255.255.255.0"
    file.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "filebeat_server" ]
    end
    file.vm.provision :chef_solo do |chef|
      chef_install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "filebeat"
    end
  end
end
