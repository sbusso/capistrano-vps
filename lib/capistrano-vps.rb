Dir[File.join(File.dirname(__FILE__), 'capistrano-vps/recipes/*.rb')].sort.each { |lib| load lib }
