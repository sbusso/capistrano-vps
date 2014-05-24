Capistrano::Configuration.instance(true).load do
  namespace :deploy do
    desc "Deploy Fast"
    task :default do
      update
      restart
      cleanup
    end

    desc "Setup a GitHub-style deployment."
    task :setup, :except => { :no_release => true } do
      run "git clone #{repository} #{current_path}"
    end

    desc "Update the deployed code."
    task :update_code, :except => { :no_release => true } do
      run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    end

    desc "Rollback a single commit."
    task :rollback, :except => { :no_release => true } do
      set :branch, "HEAD^"
      default
    end
  end
end
