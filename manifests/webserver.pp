# proxy definition
class kibana3::proxy {

    include $kibana3::proxyserv
    Class['$kibana3::proxyserv'] -> Class['kibana3::proxy']

    if ($kibana3::vhost_path == undef) {
        case $kibana3::proxyserv {
            nginx   => { $kibana3::vhost_path = '/etc/nginx/conf.d' }
            apache  => { $kibana3::vhost_path = "/etc/${apache::package::httpd::name}/conf.d"


       }
   }

