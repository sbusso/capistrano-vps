Capistrano::Configuration.instance(true).load do
  namespace :mongodb do

    desc "Install the latest release of MongoDB"
    task :install, roles: :app do
      run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
      run "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen"
      run "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install mongodb-10gen"
    end
    after "deploy:install", "mongodb:install"

    %w[start stop restart].each do |command|
      desc "#{command} mongodb"
      task command, roles: :web do
        run "#{sudo} service mongodb #{command}"
      end
    end

  end
end