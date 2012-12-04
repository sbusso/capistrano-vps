Capistrano::Configuration.instance(true).load do
  namespace :nginx do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      run "#{sudo} add-apt-repository -y ppa:nginx/stable"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx"
    end
    after "vps:prepare", "nginx:install"

    desc "Setup nginx configuration for this application"
    task :setup, roles: :web do
      template "nginx_unicorn.erb", "/tmp/nginx_conf"
      # update nginx.conf with uncomment server_names_hash_bucket_size 64;
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
      run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
      restart
    end
    after "deploy:setup", "nginx:setup"

    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
end
