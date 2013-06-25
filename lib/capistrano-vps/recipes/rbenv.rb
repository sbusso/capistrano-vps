Capistrano::Configuration.instance(true).load do
  set_default :ruby_version, "2.0.0p195"
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
      rbenv.install_ruby
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
      run "export RUBY_GC_MALLOC_LIMIT=60000000; export RUBY_FREE_MIN=200000; curl https://raw.github.com/gist/4637375/rbenv.sh | sh "
      # run "curl https://raw.github.com/gist/1688857/2-#{ruby_version}-patched.sh > /tmp/#{ruby_version}-perf"
      # run "rbenv install /tmp/#{ruby_version}-perf"
      run "rbenv global 1.9.3-p392-railsexpress"
      run "gem install bundler --no-ri --no-rdoc"
      run "rbenv rehash"
    end

    after "cap_vps:prepare", "rbenv:install"
    before "rbenv:install_ruby", "rbenv:upgrade"
  end
end
