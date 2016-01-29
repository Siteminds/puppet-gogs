# PRIVATE CLASS: do not use directly
class gogs::repo::gogs_apt {

  include ::apt

  ensure_packages('apt-transport-https')

  apt::source { 'deb.packager.io-gogs':
    comment     => 'This is the Gogs package repository on packager.io',
    location    => 'https://deb.packager.io/gh/pkgr/gogs',
    release     => $::lsbdistcodename,
    repos       => 'pkgr',
    key         => {
        id     => '6257DF9972462F57A20FFB2AB6D583CCBD33EEB8',
        source => 'https://deb.packager.io/key',
    },
    include_src => false,
    require     => Package['apt-transport-https'],
    before      => Package['gogs']
  }
}
