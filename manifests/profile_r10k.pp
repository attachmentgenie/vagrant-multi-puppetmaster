class profile_r10k (
  $puppet_repo_url = undef,
) {
  class { 'r10k':
    sources           => {
      'puppet' => {
        'remote'  => $puppet_repo_url,
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      }
    },
    purgedirs         => ["${::settings::confdir}/environments"],
    manage_modulepath => false,
  }
}