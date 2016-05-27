module Possimatch
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)

      desc "create Possimatch migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def create_migrations
        migration_template 'migrations/create_possi_sources.rb', 'db/migrate/create_possi_sources.rb'
        migration_template 'migrations/create_possi_rules.rb', 'db/migrate/create_possi_rules.rb'
        migration_template 'migrations/create_possi_matches.rb', 'db/migrate/create_possi_matches.rb'
      end
    end
  end
end