# proxy definition
class kibana3::webserver {

    include $kibana3::webserver
    Class["${kibana3::webserver}"] -> Class['kibana3::webserver']

    if ($kibana3::vhost_path == undef) {
        case $kibana3::webserver {
            nginx   => { $kibana3::vhost_path = '/etc/nginx/conf.d' }
            apache  => { $kibana3::vhost_path = "/etc/${apache::package::httpd::name}/conf.d" }
            default => { $kibana3::vhost_path = undef }
       }
   }

