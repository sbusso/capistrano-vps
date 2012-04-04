Capistrano::Configuration.instance(true).load do
  namespace :python do

    desc "Install the latest release of Python"
    task :install, roles: :app do
      run "#{sudo} add-apt-repository -y ppa:chris-lea/redis-server"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install redis-server"
    end
    after "deploy:install", "python:install"
  end
end