Package {
  allow_virtual => true,
}

class { 'r10k':
  sources           => {
    'puppet' => {
      'remote'  => 'https://github.com/attachmentgenie/r10k-multi-puppetmaster.git',
      'basedir' => "${::settings::confdir}/environments",
      'prefix'  => false,
    }
  },
  purgedirs         => ["${::settings::confdir}/environments"],
  manage_modulepath => false,
}