# =============================================================================
# GENERAL SETTINGS
# =============================================================================
set :application, "blog"
set :user, "deployer"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@gitlab.com:sbusso/#{application}.git"
set :git_enable_submodules, 1
set :keep_releases, 3
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
# ssh_options[:paranoid] = false

after "deploy", "deploy:cleanup" # keep only the last 3 releases

# =============================================================================
# STAGE SETTINGS
# =============================================================================

# set :default_stage, "experimental"
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# =============================================================================
# RECIPE INCLUDES
# =============================================================================

require "bundler/capistrano"
require "capistrano-vps/recipes/base"
require "capistrano-vps/recipes/nginx"
require "capistrano-vps/recipes/unicorn"
require "capistrano-vps/recipes/postgresql"
require "capistrano-vps/recipes/nodejs"
require "capistrano-vps/recipes/redis"
require "capistrano-vps/recipes/rbenv"
require "capistrano-vps/recipes/libxml"
# require "capistrano-vps/recipes/python"
require "capistrano-vps/recipes/elasticsearch"
# require "capistrano-vps/recipes/check"
