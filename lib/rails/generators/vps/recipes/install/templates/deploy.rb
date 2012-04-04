# =============================================================================
# GENERAL SETTINGS
# =============================================================================
set :application, "blog"
set :user, "deployer"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:activelabs/#{application}.git"
set :git_enable_submodules, 1
set :keep_releases, 3
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false

after "deploy", "deploy:cleanup" # keep only the last 5 releases

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
load "capistrano_vps/recipes/base"
load "capistrano_vps/recipes/nginx"
# load "capistrano_vps/recipes/unicorn"
load "capistrano_vps/recipes/postgresql"
load "capistrano_vps/recipes/nodejs"
# load "capistrano_vps/recipes/redis"
load "capistrano_vps/recipes/rbenv"
load "capistrano_vps/recipes/check"