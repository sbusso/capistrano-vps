Capistrano::Configuration.instance(true).load do
  set_default(:postgresql_host, "localhost")
  set_default(:postgresql_user) { application }
  set_default(:postgresql_password) { Capistrano::CLI.password_prompt "Choose PostgreSQL Password: " }
  set_default(:postgresql_database) { "#{application}_production" }
  namespace :postgresql_server do
    desc "Install the latest stable release of PostgreSQL."
    task :install, roles: :db_server do
      run "#{sudo} add-apt-repository -y ppa:pitti/postgresql"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install postgresql"
    end
    after "vps:prepare", "postgresql:install"

    # task :install_dev, roles: :db, only: {primary: true} do
    #   run "#{sudo} apt-get -y install libpq-dev"
    # end
    # after "server:prepare", "postgresql:install_dev"


    # desc "Create a database for this application."
    # task :create_database, roles: :db_server do
    #   run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    #   run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
    # end
    # after "deploy:setup", "postgresql:create_database"

    # desc "Generate the database.yml configuration file."
    # task :setup, roles: :app do
    #   run "mkdir -p #{shared_path}/config"
    #   template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
    # end
    # after "deploy:setup", "postgresql:setup"

    # desc "Symlink the database.yml file into latest release"
    # task :symlink, roles: :app do
    #   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # end
    # after "deploy:finalize_update", "postgresql:symlink"
  end
end
