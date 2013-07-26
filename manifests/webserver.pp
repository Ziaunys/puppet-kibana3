# proxy definition
class kibana3::webserver ($vhost_path) {

    include $kibana3::webserver
    if ($vhost_path == undef) {
         $vhost_path = $kibana3::webserver ? {
            'nginx' => '/etc/nginx/conf.d',
            'apache' => '/etc/httpd/conf.d',
       }
    }
   if ($kibana3::webserver == 'apache') {
        file { "${vhost_path}/bunker.kibana.mozilla.com.conf":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template("kibana3/apache_ldap.conf.erb"),
        notify  => Service['httpd'],
        }
    } else {
         fail("Not yet implemented.")
      }
   file { $kibana3::config:
        ensure  => file,
        owner   => root,
        group   => apache,
        mode    => '0640',
        content => template("kibana3/config.js.erb"),
    }
}


