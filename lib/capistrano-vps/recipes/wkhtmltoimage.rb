Capistrano::Configuration.instance(true).load do
  namespace :html2image do

    desc "Install the latest release of Imagemagick"
    task :install, roles: :app do

      # sudo aptitude install openssl build-essential xorg libssl-dev
      # sudo aptitude install ia32-libs
      run "wget http://download.gna.org/wkhtmltopdf/obsolete/linux/wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2 -O wkhtmltoimage.tar.bz2"
      run "tar xvjf wkhtmltoimage.tar.bz2"
      run "rm wkhtmltoimage.tar.bz2"
      run "#{sudo} mv wkhtmltoimage-amd64 /usr/local/bin/wkhtmltoimage"


    end
    after "cap_vps:prepare", "html2image:install"
  end
end
