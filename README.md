# Capistrano VPS

Based on Capistrano recipes railscast: http://railscasts.com/episodes/337-capistrano-recipes?view=asciicast

## Installation

Add this line to your application's Gemfile:
    gem 'capistrano'
    gem 'capistrano-ext'
    gem 'capistrano-vps', :git => "git://github.com/sbusso/capistrano-vps.git", :group => :development

    $ capify .

And then execute:

    $ bundle

Generate the config files:

rails g vps:recipes:install

## Setup

Connect to the server:
```
ssh root@72.14.183.209
bash < <(curl -s https://raw.github.com/sbusso/capistrano-vps/master/boostrap.sh)
```

On your local project:
```
ssh-add # -K on Mac OS X
cap vps:install

# OR

cap vps:prepare
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
  require "capistrano-vps/recipes/postgresql"
  require "capistrano-vps/recipes/postgresql_client"
  require "capistrano-vps/recipes/nodejs"
  require "capistrano-vps/recipes/redis"
  require "capistrano-vps/recipes/rbenv"
  require "capistrano-vps/recipes/libxml"
  require "capistrano-vps/recipes/imagemagick"
```

## TODO

* fix install bundle for new rails (patch perf)
* only install new packages
* extend capify
* uncomment assets in capify
* load as independant gem / gemfile (last have error with rake)
* check unicorn in gemfile
* unicorn unix socket
* thin recipes
* use capistrano stage to configure environment (unicorn, db, etc..)
* add maintenance tasks + page

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
