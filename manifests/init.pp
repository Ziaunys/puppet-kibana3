# == Class: kibana3
#
# Deploys Kibana 3 on a give node. It can optionally configure the node as a proxy
# for Elastic Search or use an external. The module makes some assumptions about deployment.
# For instance, if the node is configured as a proxy, it assumes that an ES api is running on
# localhost. This is stupid and will change eventually.
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
# Eric Zounes <eric.zounes@sysblogd.com>

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
    $status            = $kibana3::params::status,
    $vhost_path        = $kibana3::params::vhost_path,
    $version           = false,) inherits kibana3::params {

    package { $package: ensure => $ensure }

    if ($es_vip == undef) {
        $es_vip = $hostname
    }

    if ! ($webserver in [ 'apache', 'nginx', 'node' ]) {
        fail("\"${webserver}\" is not supported")
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

