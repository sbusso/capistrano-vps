Capistrano::Configuration.instance(true).load do
  namespace :haproxy do
    desc "Install latest stable release of haproxy"
    task :install, roles: :front do
      run "DEBIAN_FRONTEND=noninteractive #{sudo} apt-get -y install haproxy"
    end
    after "cap_vps:prepare", "haproxy:install"

    desc "Setup haproxy default configuration"
    task :setup, roles: :front do
      template "haproxy.erb", "/tmp/haproxy_default_conf"
      run "#{sudo} mv /tmp/haproxy_default_conf /etc/default/haproxy"
      template "haproxy_conf.erb", "/tmp/haproxy_conf"
      run "#{sudo} mv /tmp/haproxy_conf /etc/haproxy/haproxy.cfg"
      # !!! /etc/init.d/haproxy > ENABLED=1
      restart
      template "nginx_haproxy.erb", "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
      nginx.restart
    end
    after "deploy:setup", "haproxy:setup"

    %w[start stop restart].each do |command|
      desc "#{command} haproxy"
      task command, roles: :front do
        run "#{sudo} service haproxy #{command}"
      end
    end
  end
end
