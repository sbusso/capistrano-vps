# encoding: utf-8
require 'rails/generators'

module Vps
  module Generators
    class DeployGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc 'Generates deployment files and stages'
      def create_deploy_file
        template 'deploy.rb', File.join('config', 'deploy.rb')
      end

      def create_staging_file
        template 'staging.rb', File.join('config', 'deploy', 'staging.rb')
      end

      def create_production_file
        template 'production.rb', File.join('config', 'deploy', 'production.rb')
      end

    end
  end
end
