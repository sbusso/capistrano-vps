# Capistrano VPS

Based on Capistrano recipes railscast: http://railscasts.com/episodes/337-capistrano-recipes?view=asciicast

## Installation

Add this line to your application's Gemfile:
    gem 'capistrano'
    gem 'capistrano-vps', :git => "git://github.com/sbusso/capistrano-vps.git", :group => :development
    # gem "capistrano-vps", require: false

    $ capify .

And then execute:

    $ bundle

Generate the config files:

rails g vps:recipes:install

## Setup

Connect to the server:
```
ssh root@72.14.183.209
bash < <(curl -s https://raw.github.com/sbusso/capistrano-vps/master/bootstrap.sh)
```

On your local project:
```
ssh-add # -K on Mac OS X
cap cap_vps:install

# OR

cap cap_vps:prepare
cap deploy:setup
cap deploy:cold
cap deploy:migrations
```

## Usage

Deploy file example:
```ruby
  # =============================================================================
  # GENERAL SETTINGS
  # =============================================================================
  set :application, "myproject"
  set :user, "deployer"

  set :deploy_to, "/home/#{user}/apps/#{application}"
  set :use_sudo, false
  set :deploy_via, :remote_cache
  set :scm, :git
  set :repository, "git@github.com:myuser/#{application}.git"
  set :git_enable_submodules, 1
  set :keep_releases, 3
  set :branch, "master"

  default_run_options[:pty] = true
  ssh_options[:forward_agent] = true
  # ssh_options[:paranoid] = false

  after "deploy", "deploy:cleanup" # keep only the last 3 releases

  server "#production_address", :web, :app, :db, primary: true

  # =============================================================================
  # RECIPE INCLUDES
  # =============================================================================

  require "bundler/capistrano"
  require "capistrano-vps/recipes/base"
  require "capistrano-vps/recipes/nginx"
  require "capistrano-vps/recipes/unicorn"
  require "capistrano-vps/recipes/postgresql_server"
  require "capistrano-vps/recipes/postgresql_client"
  require "capistrano-vps/recipes/nodejs"
  require "capistrano-vps/recipes/redis"
  require "capistrano-vps/recipes/rbenv"
  require "capistrano-vps/recipes/libxml"
  require "capistrano-vps/recipes/imagemagick"
```

## TODO

* add config.yml, configure everything from this file
* add sudo apt-get install openjdk-7-jre
* only install new packages
* extend capify
* uncomment assets in capify
* load as independant gem / gemfile (last have error with rake)
* check unicorn in gemfile
* use capistrano stage to configure environment (unicorn, db, etc..)
* add maintenance tasks + page
* add test for version 1.0 - look at carpet (https://github.com/sbusso/carpet/blob/master/spec/capistrano/deploy/remote_dependency_spec.rb, https://github.com/technicalpickles/capistrano-spec)
* rename to 'capistrano-provisonner'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
