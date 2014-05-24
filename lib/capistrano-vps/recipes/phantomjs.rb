Capistrano::Configuration.instance(true).load do
  namespace :phantomjs do

    desc "Install the latest release of PhantomJs"
    task :install, roles: :app do
      run "wget https://phantomjs.googlecode.com/files/phantomjs-1.9.0-linux-x86_64.tar.bz2"
      run "tar xvjf phantomjs-1.9.0-linux-x86_64.tar.bz2"
      run "rm phantomjs-1.9.0-linux-x86_64.tar.bz2"
      run "#{sudo} mv phantomjs-1.9.0-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs"

    end
    after "cap_vps:prepare", "phantomjs:install"
  end
end
