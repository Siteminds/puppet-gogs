siteminds/gogs
==============

[![Travis build status](https://api.travis-ci.org/Siteminds/puppet-gogs.svg)](https://travis-ci.org/Siteminds/puppet-gogs)
[![Quantified Code Analysis](https://www.quantifiedcode.com/api/v1/project/a9ae964decbb4bf4804a61e42b7f0633/badge.svg)](https://www.quantifiedcode.com/app/project/gh:Siteminds:puppet-gogs)

Overview
--------

This is a Puppet module to install Gogs (Go Git Service, see: <http://gogs.io>).

Module Description
-------------------

Gogs(Go Git Service) is a painless self-hosted Git Service written in Go. The goal of the Gogs
project is to make the easiest, fastest and most painless way to set up a self-hosted Git service.
With Go, this can be done in independent binary distribution across ALL platforms that Go supports,
including Linux, Mac OS X, and Windows.

This Puppet module allows you to manage the Gogs service on linux operating systems. Currently
only Debian and RedHat family linux is tested/supported.

Usage
-----

In order to use this Gogs module you should be able to simply include it:

    include ::gogs
or:

    class { '::gogs':
        ensure => present,
    }

Configure it to your needs using the parameters below.

### Parameters

#### install_repo
  Boolean indicating wheter or not the gogs package repository should be added to the hosts
  package manager configuration. Default: false.

#### package_ensure
  Value to pass through to the `package` resource when installing Gogs. Defaults to 
  `present`.

#### run_mode
  The environment this Gogs instance is running for. Allowed values are: 'dev', 'test' or
  'prod'. Default: 'prod'

#### repository_root
  Root directory that will contain all Git repositories. If this directory does not exist,
  it will be created. Please note that the parent directory for the repository root must
  already exist! Default: '/home/gogs/gogs-repositories'

#### domain
  The domain name the Gogs service should serve/listen to. Default: 'localhost'.

#### port
  The port the Gogs service should listen on. Default: 6000.

#### enable_gzip
  Boolean indicating wheter or not (http) gzip compression should be used. Default: false.

#### db_type
  The type of database back-end to be used by Gogs. Allowed values are: 'postgres', 'mysql'
  or 'sqlite3'. Please note that the packages from packager.io, used by this module when you
  select install_repo = true don't support sqlite3.
  Also note that this module does not install a database for Gogs. Please use another module
  e.g. the Puppetlabs/Postgresql module from the forge to install one.
  Default: 'postgres'.

#### db_host
  The hostname of the machine where the Gogs database is running. Default: 'localhost'.

#### db_port
  The port of the Gogs database. Default: 5432.

#### db_name
  Name of the Gogs database. Default: 'gogs'.

#### db_user
  The username credential used for connecting to the Gogs database. Default: 'gogs'.

#### db_password
  The password credential used for connecting to the Gogs database. DefaulT: 'gogs'.

#### db_ssl_mode
  For postgres only. Valid values are: 'disable', 'require' or 'verify-full'.
  Default: 'disable'

#### db_data
  Path where sqlite3 should store its data. Only used when db_type = 'sqlite3'.

#### secret_key
  The secret key. You should provide one for each Gogs instance. When not passed a default
  secret key will be used.

Features to be added
--------------------

This module is far from done. I will add more parameters/customization options. This version
will just get you up and running with the bare essentials.

Special Notes
-------------

This module does *not* install a database required by Gogs. Please provide your own wrapper or
server role module to install either a Postgresql or MySql database. Sqlite3 is not supported
by the packages provided on packager.io. If you provide your own package (install_repo = false),
you can ofcourse set the db_type to sqlite3.

Another Gogs quirk is that it does not install an admin user by default. Normally this is done
by the first time installer, which configures an admin user in the database. Since this module
deliberately does not install a database, you should either add a Gogs admin user to the
database with another module or manually. An example SQL insert for this is:

    INSERT INTO "user" VALUES (1, 'admin', 'admin', '', 'my@admin.com', 'someverylongPDKDF2passwordhash', 0, 0, '', 0, '', '', 'randomsecret', 'randomsaltstring', '2015-01-07 13:58:37', '2015-01-07 13:58:37', true, true, false, '9075fd3adc2d47bc1ae87100e0686399', 'my@admin.com', false, 0, 0, 0, 0, '', 0, 0);

The password must be a PDKDF2 encrypted string, using 10000 iterations, keylength 50, the salt
value (in this case 'randomsaltstring') and SHA-256 HMAC. You could use the following Go program
to generate a password hash:

    package main

    import (
           "fmt"
           "os"
           "crypto/sha256"
           "golang.org/x/crypto/pbkdf2"
    )

    func main() {
       newPasswd := pbkdf2.Key([]byte(os.Args[1]), []byte(os.Args[2]), 10000, 50, sha256.New)
       fmt.Printf("%x\n", newPasswd)
    }

Save it as ```gogspaswd.go``` and run it with ```go run gogspasswd.go <password> <salt>```.

This simple program takes the password as the first argument and the salt value as the second
argument. This code is an actual copy of the Gogs code responsible for inserting/updating
passwords in the database.
