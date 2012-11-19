Capistrano::Configuration.instance(true).load do
  namespace :libcurl do

    desc "Install the latest release of libcurl"
    task :install, roles: :app do
      run "#{sudo} apt-get -y install curl libcurl3 libcurl3-dev"
    end
    after "server:prepare", "libcurl:install"

  end
end
