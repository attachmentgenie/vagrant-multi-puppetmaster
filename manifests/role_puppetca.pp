class role_puppetca () {
  class { '::epel': } ->
  class { '::profile_ntp': } ->
  class { '::profile_selinux': } ->
  class { '::profile_firewall': }
  class { '::profile_puppetdb': }
  class { '::profile_puppet': }
  class { '::profile_r10k': }

  Class['::puppet::server::service'] ->
  Class['::puppetdb::server']
}