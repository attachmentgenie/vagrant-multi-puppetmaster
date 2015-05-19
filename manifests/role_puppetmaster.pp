class role_puppetmaster () {
  class { '::epel': } ->
  class { '::profile_ntp': } ->
  class { '::profile_selinux': } ->
  class { '::profile_firewall': } ->
  class { '::profile_puppet': }
  class { '::profile_haproxy_balancermember': }
  class { '::profile_r10k': }
}