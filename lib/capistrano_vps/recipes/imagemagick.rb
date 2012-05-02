Capistrano::Configuration.instance(true).load do
  namespace :imagemagick do

    desc "Install the latest release of Imagemagick"
    task :install, roles: :app do
      run "#{sudo} apt-get install imagemagick -y"
    end
    after "deploy:install", "imagemagick:install"
  end
end