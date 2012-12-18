Capistrano::Configuration.instance(true).load do
  namespace :imagemagick do

    desc "Install the latest release of Imagemagick"
    task :install, roles: :app do
      run "#{sudo} apt-get install imagemagick libmagickwand-dev -y"
    end
    after "cap_vps:prepare", "imagemagick:install"
  end
end
