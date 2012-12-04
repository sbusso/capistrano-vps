Capistrano::Configuration.instance(true).load do
  namespace :html2image do

    desc "Install the latest release of Imagemagick"
    task :install, roles: :app do

      run "wget http://wkhtmltopdf.googlecode.com/files/wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2 -O wkhtmltoimage.tar.bz2"
      run "tar xvjf wkhtmltoimage.tar.bz2"
      run "rm wkhtmltoimage.tar.bz2"
      run "#{sudo} mv wkhtmltoimage-amd64 /usr/local/bin/"


    end
    after "vps:prepare", "html2image:install"
  end
end
