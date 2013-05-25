Capistrano::Configuration.instance(true).load do

  def run_remote_rake(rake_cmd)
    rake_args = ENV['RAKE_ARGS'].to_s.split(',')
    cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
    cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
    run cmd
    set :rakefile, nil if exists?(:rakefile)
  end

  namespace :resque do
    namespace :worker do
      after "deploy:symlink", "deploy:restart_workers"
      after "deploy:restart_workers", "deploy:restart_scheduler"

      desc "Restart Resque Workers"
      task :restart, :roles => :db do
        run_remote_rake "resque:restart_workers"
      end

      desc "Restart Resque scheduler"
      task :scheduler, :roles => :db do
        run_remote_rake "resque:restart_scheduler"
      end
    end
  end
end