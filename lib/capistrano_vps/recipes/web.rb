Capistrano::Configuration.instance(true).load do
  namespace :deploy do
    namespace :web do
      desc "This will disable the application and show a warning screen"
      task :disable do
        run "cp #{current_path}/config/maintenance.html #{current_path}/public/maintenance.html", :roles => :app
      end

      desc "This will disable the application and show a warning screen"
      task :enable do
        run "rm #{current_path}/public/maintenance.html", :roles => :app
      end
    end
  end
end
