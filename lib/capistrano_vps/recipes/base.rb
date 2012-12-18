Capistrano::Configuration.instance(true).load do
  def template(from, to)
    erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
    put ERB.new(erb).result(binding), to
  end

  def set_default(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end


  namespace :cap_vps do
    desc "Prepare server for installation"
    task :prepare do
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install python-software-properties"
    end

    desc "Install everything onto the server"
    task :install do
      cap_vps.prepare
      deploy.setup
      deploy.cold
      deploy.migrations
    end
  end



end

#dpkg-reconfigure locales
