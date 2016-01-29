# == Class gogs::install
#
class gogs::install(

  $package_name   = $gogs::params::package_name,
  $package_ensure = $gogs::package_ensure

) {

  package { 'gogs':
    ensure => $package_ensure,
    name   => $package_name,
  }
}
