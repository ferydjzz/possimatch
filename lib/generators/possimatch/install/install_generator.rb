require 'rails/generators/migration'

module Possimatch
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../templates", __FILE__)

      desc 'Add possimatch migrations'

      def copy_migrations
        migration_template '../templates/migrations/create_possible_sources.rb', 'db/migrate/create_possible_sources.rb'
        migration_template '../templates/migrations/create_possible_rules.rb', 'db/migrate/create_possible_rules.rb'
        migration_template '../templates/migrations/create_possible_matches.rb', 'db/migrate/create_possible_matches.rb'
      end
    end
  end
end