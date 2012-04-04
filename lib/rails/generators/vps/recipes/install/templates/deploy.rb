# =============================================================================
# GENERAL SETTINGS
# =============================================================================
set :application, "blog"
set :user, "deployer"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:sbusso/#{application}.git"
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
require "capistrano_vps/recipes/base"
require "capistrano_vps/recipes/nginx"
require "capistrano_vps/recipes/unicorn"
require "capistrano_vps/recipes/postgresql"
require "capistrano_vps/recipes/nodejs"
require "capistrano_vps/recipes/redis"
require "capistrano_vps/recipes/rbenv"
require "capistrano_vps/recipes/libxml"
# require "capistrano_vps/recipes/check"