# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

###############################################################################
# Base box                                                                    #
###############################################################################
    config.vm.box = "puppetlabs/centos-6.6-64-puppet"

###############################################################################
# Global Plugin settings                                                #
###############################################################################
    plugins = ["vagrant-hostmanager"]
    plugins.each do |plugin|
      unless Vagrant.has_plugin?(plugin)
        raise plugin << " has not been installed."
      end
    end

    # Configure cached packages to be shared between instances of the same base box.
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine
    end

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

###############################################################################
# Global Provisioning settings                                                #
###############################################################################
    default_env = 'production'
    ext_env = ENV['VAGRANT_PUPPET_ENV']
    env = ext_env ? ext_env : default_env
    R10K = "r10k deploy environment -pv"

###############################################################################
# Global VirtualBox settings                                                  #
###############################################################################
    config.vm.provider 'virtualbox' do |v|
    v.customize [
      'modifyvm', :id,
      '--groups', '/Vagrant/multi-master'
    ]
    end

###############################################################################
# VM definitions                                                              #
###############################################################################
    config.vm.define :puppet do |puppet_config|
      puppet_config.vm.host_name = "puppet.multi-master.vagrant"
      puppet_config.vm.network :private_network, ip: "192.168.42.130"
      puppet_config.vm.synced_folder 'manifests/', "/etc/puppet/environments/#{env}/manifests"
      puppet_config.vm.synced_folder 'modules/', "/etc/puppet/environments/#{env}/modules"
      puppet_config.vm.synced_folder 'hiera/', '/var/lib/hiera'
      puppet_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/hiera.yaml /etc/puppet/hiera.yaml'
      puppet_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/autosign.conf /etc/puppet/autosign.conf'
      puppet_config.vm.provision :puppet do |puppet|
        puppet.options = "--environment #{env}"
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = ""
        puppet.module_path = "modules"
        puppet.hiera_config_path = "files/hiera.yaml"
      end
    end

    config.vm.define :puppetmaster do |puppetmaster_config|
      puppetmaster_config.vm.host_name = "puppetmaster.multi-master.vagrant"
      puppetmaster_config.vm.network :forwarded_port, guest: 22, host: 2140
      puppetmaster_config.vm.network :private_network, ip: "192.168.42.140"
      puppetmaster_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/hiera.yaml /etc/puppet/hiera.yaml'
      puppetmaster_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = 'puppet.multi-master.vagrant'
      end
      puppetmaster_config.vm.provision :shell, inline: R10K
    end

    config.vm.define :proxy do |proxy_config|
      proxy_config.vm.host_name = "proxy.multi-master.vagrant"
      proxy_config.vm.network :forwarded_port, guest: 22, host: 2150
      proxy_config.vm.network :private_network, ip: "192.168.42.150"
      proxy_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = 'puppet.multi-master.vagrant'
      end
    end

    config.vm.define :node do |node_config|
      node_config.vm.host_name = "node.multi-master.vagrant"
      node_config.vm.network :forwarded_port, guest: 22, host: 2160
      node_config.vm.network :private_network, ip: "192.168.42.160"
      node_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = 'proxy.multi-master.vagrant'
      end
    end
end
