# PRIVATE CLASS: do not use directly
class gogs::repo::gogs_yum {

  yumrepo { 'rpm.packager.io-gogs':
    descr    => 'Gogs yum repo on Packager.io',
    baseurl  => "https://rpm.packager.io/gh/pkgr/gogs/centos${::operatingsystemmajrelease}/pkgr",
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => 'https://rpm.packager.io/key',
    before   => Package['gogs'],
  }
}
