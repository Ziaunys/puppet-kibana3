# == Class: kibana3
#
# Full description of class kibana3 here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { kibana3:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <eric.zounes@sysblogd.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class kibana3(
    $autoupgrade       = $kibana3::params::autoupgrade,
    $ensure            = $kibana3::params::ensure,
    $package           = $kibana3::params::package,
    $proxyserv         = $kibana3::params::proxyserv,
    $restart_on_change = $kibana3::params::restart_on_change,
    $status            = $kibana3::params::status,
    $version           = false,) inherits kibana3::params {

    if ! ($proxyserv in [ 'apache', 'nginx', 'node' ]) {
        fail("\"${proxyserv}\" is not supported")
    }
    elseif ($proxyserv == undef) {
        fail("param: proxyserv must be defined")
    }
    else {
        include $proxyserv
        Class["${proxyserv}"] -> Class['kibana3']
    }

    package { $package: ensure => $ensure }


    }


    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("\"${ensure}\" is not a valid ensure parameter")
    }

    validate_bool($autoupgrade)
    }

