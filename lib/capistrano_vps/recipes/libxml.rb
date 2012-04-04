namespace :libxml do

  desc "Install the latest release of Redis"
  task :install, roles: :app do
    run "#{sudo} apt-get install libxml2 libxml2-dev libxslt1-dev"
  end
  after "deploy:install", "libxml:install"
end

