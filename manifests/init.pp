# == Class: kibana3
#
# Deploys Kibana 3 on a give node. It can optionally configure the node as a proxy
# for Elastic Search or use an external.
#
# === Parameters
#
# Required:
#
# [webserver]
#
# Specify web server class to use for serving kibana.
# Values: [node, nginx, apache] (Exclusive support for Apaache, atm)
#
# Optional:
#
# [es_vip]
#
# Specify the hostname of the external Elastic Search proxy.
# Values: ['kibana.myproxy.com']
#
#
# Specify the
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
# External proxy:
#
#  class { 'kibana3':
#          es_vip    => 'kibana.myproxy.com',
#          webserver => 'apache',
#  }
#
# As proxy:
#
#  class { 'kibana3':
#           is_proxy    => true,
#           webserver   => 'apache',
#  }
#
#
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
    $approot           = $kibana3::params::approot,
    $ensure            = $kibana3::params::ensure,
    $es_vip,
    $es_port           = $kibana3::params::es_port,
    $is_proxy          = $kibana3::params::is_proxy,
    $package           = $kibana3::params::package,
    $proxy_port        = $kibana3::params::server_port,
    $webserver         = $kibana3::params::webserver,
    $restart_on_change = $kibana3::params::restart_on_change,
    $status            = $kibana3::params::status,
    $vhost_path        = $kibana3::params::vhost_path,
    $version           = false,) inherits kibana3::params {

    package { $package: ensure => $ensure }

    if ($es_vip == undef) {
        $es_vip = $hostname
    }
 
    if ! ($webserver in [ 'apache', 'nginx', 'node' ]) {
        fail("\"${proxyserv}\" is not supported")
    }
    elsif ($webserver == undef) {
        fail("param: webserver must be defined")
    }
    else {
       class { 'kibana3::webserver': vhost_path => $vhost_path }
    }

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("\"${ensure}\" is not a valid ensure parameter")
    }
}

