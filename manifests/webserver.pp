# proxy definition
class kibana3::webserver {

    include $kibana3::webserver
    Class["${kibana3::webserver}"] -> Class['kibana3::webserver']

    if ($kibana3::vhost_path == undef) {
         case $kibana3::webserver {
            'nginx'   => { $kibana3::vhost_path = '/etc/nginx/conf.d' }
            'apache'  => { $kibana3::vhost_path = "/etc/${apache::package::httpd::name}/conf.d" }
            default => { $kibana3::vhost_path = undef }
       }

    if ($kibana3::webserver == 'apache') {
        file { "${kibana3::vhost_path}/kibana3.conf":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template("kibana3/apache_ldap.conf.erb")
        notify  => Service['kibana3']
        }
    } else {
         fail("Not yet implemented.")
      }

    if ($kibana3::es_vip == undef) {
        $kibana3::es_vip = $fqdn
    }
    file { $kibana3::config:
        ensure  => file,
        owner   => root,
        group   => apache,
        mode    => '0640'
        content => template("kibana3/config.js.erb")
    }
  }
}
}
