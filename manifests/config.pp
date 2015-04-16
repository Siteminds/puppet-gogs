# == Class gogs::config
#
# This class is called from gogs
#
class gogs::config(

  $lock_install = $gogs::lock_install,
  $run_mode = $gogs::run_mode,
  $repository_root = $gogs::repository_root,
  $enable_gzip = $gogs::enable_gzip,
  $domain = $gogs::domain,
  $port = $gogs::port,
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
  $secret_key = $gogs::secret_key

) inherits gogs::params {

  user { $owner:
    ensure  => present,
  }

  group { $group:
    ensure  => present,
  }

  file { $repository_root:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  }

  file { '/etc/gogs/conf/app.ini':
    ensure  => 'file',
    content => template('gogs/app.ini.erb'),
    owner   => $owner,
    group   => $group,
  }

  file { '/etc/init.d/gogs':
    ensure => 'file',
    mode   => '0755',
    source => "puppet:///modules/gogs/${initrd_script}",
    owner  => 'root',
    group  => 'root',
  }

}
