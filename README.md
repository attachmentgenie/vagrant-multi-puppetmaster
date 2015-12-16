# Creating a disposable test environment

## Requirements
    Virtualbox                  => https://www.virtualbox.org
    Vagrant                     => http://www.vagrantup.com
    vagrant-hostmanager         => vagrant plugin install vagrant-hostmanager
    vagrant-cachier  (optional) => vagrant plugin install vagrant-cachier
    vagrant-triggers (optional) => vagrant plugin install vagrant-triggers

## Preparation
    git submodule update --init
    
## Setup
    vagrant up puppetca
    login to foreman and change the following settings
    administer, settings, puppetdb, puppetdb_address, puppetdb_dashboard_address, puppetdb_enabled => true
    infrastructure, smart proxies, certificates, autosign entries, new =. *.multimaster.vagrant
    vagrant up  compile proxy
    vagrant ssh puppetca
    sudo puppet cert clean compile.multimaster.vagrant
    exit
    vagrant ssh compile
    sudo rm -rf /var/lib/puppet/ssl
    exit
    vagrant provision compile
    vagrant ssh puppetca
    sudo puppet cert --allow-dns-alt-names sign compile.multimaster.vagrant
    exit
    vagrant provision compile
    vagrant ssh compile
    sudo /etc/init.d/httpd restart
    exit
    vagrant up node
    
    foreman  => https://puppetca.multimaster.vagrant
    username: admin
    passwd  : secret
    puppetdb => http://puppetca.multimaster.vagrant:8080
