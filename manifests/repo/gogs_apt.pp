# PRIVATE CLASS: do not use directly
class gogs::repo::gogs_apt(
) inherits gogs::repo {

  include ::apt

  package { 'apt-transport-https': }

  apt::source { 'deb.packager.io-gogs':
    comment     => 'This is the Gogs package repository on packager.io',
    location    => 'https://deb.packager.io/gh/pkgr/gogs',
    release     => $::lsbdistcodename,
    repos       => 'pkgr',
    key         => 'BD33EEB8',
    key_source  => 'https://deb.packager.io/key',
    include_src => false,
    require     => [
      Package['apt-transport-https']
    ]
  }

  # Make sure repo is configured before package is installed
  Apt::Source['deb.packager.io-gogs'] -> Package<|
    tag == 'gogs' 
    and title != 'apt-transport-https'
  |>
}
