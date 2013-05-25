Capistrano::Configuration.instance(true).load do
  db_server = find_servers(:roles => :db).first
  db_ip = (db_server ? db_server.options[:internal] || 'localhost' : 'localhost')
  set_default(:postgresql_host, db_ip)
  set_default(:postgresql_user) { application }
  set_default(:postgresql_password) { (0...10).map{(65+rand(60)).chr}.join.gsub('`', ':') } #random password instead, Capistrano::CLI.password_prompt "Choose PostgreSQL Password: " }
  set_default(:postgresql_database) { "#{application}_production" }
  set_default(:postgresql_host) { db_ip }

  namespace :postgresql_client do
    desc "Install dev libraries PostgreSQL."
    task :install, roles: :db, only: {primary: true} do
      run "#{sudo} add-apt-repository -y ppa:pitti/postgresql"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install libpq-dev"
    end
    after "cap_vps:prepare", "postgresql_client:install"

    desc "Create a database for this application."
    task :create_database, roles: :db_server do
      run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
      run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
    end
    after "deploy:setup", "postgresql_client:create_database"

    desc "Generate the database.yml configuration file."
    task :setup, roles: :app do
      run "mkdir -p #{shared_path}/config"
      template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
    end
    after "deploy:setup", "postgresql_client:setup"

    desc "Symlink the database.yml file into latest release"
    task :symlink, roles: :app do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
    after "deploy:finalize_update", "postgresql_client:symlink"
  end
  namespace :db do
    require 'yaml'

    def sql_filename
      @sql_filename  ||= "#{application}_#{env}_#{Time.now.strftime '%Y-%m-%d'}.sql"
    end

    def filename
      @filename ||= "#{sql_filename}.bz2"
    end

    def env
      @env  ||= ENV['RAILS_ENV'] || ENV['DB'] || 'production'
    end



    desc "Dump database"
    task :dump, :role => :db_server do
      download("#{shared_path}/config/database.yml", "tmp/database.yml", roles: :app)
      remote_database = YAML::load_file('tmp/database.yml')
      on_rollback { delete "/tmp/#{@filename}" }
      run %Q{#{sudo} -u postgres pg_dump --clean --no-owner --no-privileges #{remote_database['production']['database']} | bzip2 > /tmp/#{filename}}, roles: :db_server
    end

    desc "Get database"
    task :get, :role => :db_server do
      download("/tmp/#{filename}", "tmp/#{filename}", roles: :db_server)
      #run_locally("bzip2 -df tmp/#{@filename}")
    end

    desc "Import database"
    task :import, :role => :db_server do
      download("#{shared_path}/config/database.yml", "tmp/database.yml", roles: :app)
      database = YAML::load_file('tmp/database.yml')
      upload( "tmp/#{filename}", "/tmp/#{filename}", roles: :db_server)
      run "bzip2 -df /tmp/#{filename}", roles: :db_server
      run "PGPASSWORD=#{database['production']['password']} psql -U #{database['production']['username']} -h #{database['production']['host']} #{database['production']['database']} < /tmp/#{sql_filename}", roles: :db_server
    end

    desc "Get database file"
    task :pull do
      dump
      get
    end

    desc "Push database file and import"
    task :push, :role => :db_server do
      import
    end


    desc "Duplicate database"
    task :duplicate, :role =>  :db_server do
      dump
      get
      # import
    end

    desc "Restore from ftp"
    task :restore, :role =>  :db_server do

    end



  end




end
