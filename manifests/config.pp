# == Class gogs::config
#
# This class is called from gogs
#
class gogs::config(

  $lock_install = $gogs::lock_install,
  $run_mode = $gogs::run_mode,
  $repository_root = $gogs::repository_root,
  $enable_gzip = $gogs::enable_gzip,
  $protocol = $gogs::protocol,
  $domain = $gogs::domain,
  $addr = $gogs::addr,
  $port = $gogs::port,
  $cert_file = $gogs::cert_file,
  $key_file = $gogs::key_file,
  $root_url = $gogs::root_url,
  $enable_gzip = $gogs::enable_gzip,
  $db_type = $gogs::db_type,
  $db_host = $gogs::db_host,
  $db_port = $gogs::db_port,
  $db_user = $gogs::db_user,
  $db_name = $gogs::db_name,
  $db_password = $gogs::db_password,
  $db_ssl_mode = $gogs::db_ssl_mode,
  $db_data = $gogs::db_data,
  $owner = $gogs::params::owner,
  $group = $gogs::params::group,
  $initrd_script = $gogs::params::initrd_script,
  $secret_key = $gogs::secret_key,
  $app_name = $gogs::app_name,
  $disable_registration = $gogs::disable_registration,
  $require_signin_view = $gogs::require_signin_view

) inherits gogs::params {

  user { $owner:
    ensure     => present,
    managehome => true,
    require    => Group[$group],
  }

  group { $group:
    ensure  => present,
  }

  file { $repository_root:
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    require => User[$owner]
  }

  file { '/etc/gogs/conf/app.ini':
    ensure  => 'file',
    content => template('gogs/app.ini.erb'),
    owner   => $owner,
    group   => $group,
    require => Package['gogs']
  }

  file { '/etc/init.d/gogs':
    ensure => 'file',
    mode   => '0755',
    source => "puppet:///modules/gogs/${initrd_script}",
    owner  => 'root',
    group  => 'root',
  }

}
