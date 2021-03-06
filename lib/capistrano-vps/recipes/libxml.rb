Capistrano::Configuration.instance(true).load do
  namespace :libxml do

    desc "Install the latest release of libxml"
    task :install, roles: :app do
      run "#{sudo} apt-get -y install libxml2 libxml2-dev libxslt1-dev"
    end
    after "cap_vps:prepare", "libxml:install"

  end
end
