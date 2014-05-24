Capistrano::Configuration.instance(true).load do
  set :normal_symlinks, %w(
    config/solr.yml
    config/memcached.yml
    config/database.yml
    config/mongrel_cluster.yml
  )

  set :weird_symlinks, {
    'network_data_cache' => 'tmp/network_data_cache',
    'impact_data_cache'  => 'tmp/impact_data_cache',
    'podcast'            => 'public/gitsplosion',
    'tarballs'           => 'public/tarballs',
    'system'             => 'public/system'
  }

  namespace :symlinks do
    desc "Make all the damn symlinks"
    task :make, :roles => :app, :except => { :no_release => true } do
      commands = normal_symlinks.map do |path|
        "rm -rf #{release_path}/#{path} && \
         ln -s #{shared_path}/#{path} #{release_path}/#{path}"
      end

      commands += weird_symlinks.map do |from, to|
        "rm -rf #{release_path}/#{to} && \
         ln -s #{shared_path}/#{from} #{release_path}/#{to}"
      end

      # needed for some of the symlinks
      run "mkdir -p #{current_path}/tmp"

      run <<-CMD
        cd #{release_path} &&
        #{commands.join(" && ")}
      CMD
    end
  end

  after "deploy:update_code", "symlinks:make"
end
