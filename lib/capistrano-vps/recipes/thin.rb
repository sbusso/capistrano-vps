Capistrano::Configuration.instance(true).load do
  set_default(:thin_user) { user }
  set_default(:thin_pid) { "#{current_path}/tmp/pids/thin.pid" }
  set_default(:thin_log) { "#{shared_path}/log/thin.log" }
  set_default(:thin_servers, 2)
  set_default(:thin_port, 9001)
  namespace :thin do
    desc "Start thin"
    task :start, :roles => :app do
      set :start_command, "thin start -e #{rails_env} --port #{thin_port} -a 127.0.0.1 -P #{thin_pid} --server #{thin_servers} -d"
      run "cd #{deploy_to}/current; #{start_command}", :roles => :app
    end

    desc "Stop thin"
    task :stop, :roles => :app do
      run "cd #{deploy_to}/current; thin stop -P #{thin_pid} -s #{thin_servers} --port 9001"
    end

    desc "Restart thin"
    task :restart, :roles => :app do
      set :restart_command, "thin restart -e #{rails_env} --port #{thin_port} --onebyone -a 127.0.0.1 -P #{thin_pid}  --server #{thin_servers}"
      run "cd #{deploy_to}/current; #{restart_command}", :roles => :app
      puts "WEBSITE HAS BEEN DEPLOYED"
    end
    after "deploy:start", "thin:restart"

  end



end


