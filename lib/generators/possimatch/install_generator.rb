require 'rails/generators/active_record'

module Possimatch
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc 'Create possimatch initializer'
      
      source_root File.expand_path("../../templates", __FILE__)

      def create_migrations
      	migration_template '../templates/migrations/create_possible_sources.rb', 'db/migrate/create_possible_sources.rb'
      	migration_template '../templates/migrations/create_possible_rules.rb', 'db/migrate/create_possible_rules.rb'
        migration_template '../templates/migrations/create_possible_matches.rb', 'db/migrate/create_possible_matches.rb'
      end
    end
  end
end