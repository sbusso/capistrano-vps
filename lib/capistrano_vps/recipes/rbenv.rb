Capistrano::Configuration.instance(true).load do
  set_default :ruby_version, "1.9.3-p194"
  # set_default :rbenv_bootstrap, "bootstrap-ubuntu-11-10"

  namespace :rbenv do
    desc "Install rbenv, Ruby, and the Bundler gem"
    task :install, roles: :app do
      run "#{sudo} apt-get -y install curl git-core"
      run "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
      bashrc = <<-BASHRC
  if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
  fi
  BASHRC
      put bashrc, "/tmp/rbenvrc"
      run "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
      run "mv ~/.bashrc.tmp ~/.bashrc"
      run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
      run %q{eval "$(rbenv init -)"}
      run "#{sudo} apt-get -y install build-essential"
      run "#{sudo} apt-get -y install zlib1g-dev libssl-dev"
      run "#{sudo} apt-get -y install libreadline-gplv2-dev"
      run "rbenv install #{ruby_version}"
      run "rbenv global #{ruby_version}"
      run "gem install bundler --no-ri --no-rdoc"
      run "rbenv rehash"
    end

    desc "Upgrade rbenv"
    task :upgrade, roles: :app do
      run "cd ~/.rbenv; git pull"
      run "cd ~/.rbenv/plugins/ruby-build; git pull"
    end

    desc "Install ruby"
    task :install_ruby, roles: :app do
      run "rbenv install #{ruby_version}"
      run "rbenv global #{ruby_version}"
      run "gem install bundler --no-ri --no-rdoc"
      run "rbenv rehash"
    end

    after "deploy:install", "rbenv:install"
    before "rbenv:install_ruby", "rbenv:upgrade"
  end
end