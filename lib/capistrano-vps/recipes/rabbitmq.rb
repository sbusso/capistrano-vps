Capistrano::Configuration.instance(true).load do
  namespace :rabbitmq do
    desc "Install the latest relase of Node.js"
    task :install, roles: :app do
      run "#{sudo} wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
      run "#{sudo} apt-key add rabbitmq-signing-key-public.asc"
      run %q{#{sudo} echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list}
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install rabbitmq"
    end
    after "cap_vps:prepare", "rabbitmq:install"

    desc "Start RabbitMQ"
    task :start do
      run "#{sudo} invoke-rc.d rabbitmq-server stop/start"
    end

    desc "Stop RabbitMQ"
    task :stop do
      run "#{sudo} rabbitmqctl stop"
    end
  end
end
