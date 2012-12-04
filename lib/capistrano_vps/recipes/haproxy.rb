Capistrano::Configuration.instance(true).load do
  namespace :haproxy do
    desc "Install latest stable release of haproxy"
    task :install, roles: :front do
      run "#{sudo} apt-get -y install haproxy"
    end
    after "vps:prepare", "haproxy:install"

    desc "Setup haproxy default configuration"
    task :setup, roles: :front do
      template "haproxy.erb", "/tmp/haproxy_conf"
      run "#{sudo} mv /tmp/haproxy_conf /etc/default/haproxy"
      restart
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
