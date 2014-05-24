Capistrano::Configuration.instance(true).load do
  namespace :phantomjs do

    desc "Install the latest release of Imagemagick"
    task :install, roles: :app do
      run "wget https://phantomjs.googlecode.com/files/phantomjs-1.9.0-linux-x86_64.tar.bz2"
      run "tar xvjf phantomjs-1.9.0-linux-x86_64.tar.bz2"
      run "rm phantomjs-1.9.0-linux-x86_64.tar.bz2"
      run "#{sudo} mv wkhtmltoimage-amd64 /usr/local/bin/wkhtmltoimage"

      run "#{sudo} ln -s /usr/local/share/phantomjs-1.9.0-linux-x8664/bin/phantomjs /usr/local/share/phantomjs; #{sudo} ln -s /usr/local/share/phantomjs-1.9.0-linux-x8664/bin/phantomjs /usr/local/bin/phantomjs; #{sudo} ln -s /usr/local/share/phantomjs-1.9.0-linux-x86_64/bin/phantomjs /usr/bin/phantomjs"

    end
    after "cap_vps:prepare", "phantomjs:install"
  end
end
