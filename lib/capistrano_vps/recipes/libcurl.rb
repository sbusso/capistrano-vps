Capistrano::Configuration.instance(true).load do
  namespace :libcurl do

    desc "Install the latest release of libcurl"
    task :install, roles: :app do
      run "#{sudo} apt-get install curl libcurl3 libcurl3-dev"
    end
    after "deploy:install", "libcurl:install"

  end
end
