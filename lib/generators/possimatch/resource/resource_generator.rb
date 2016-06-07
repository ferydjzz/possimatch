require 'generators/possimatch/boilerplate'

module Possimatch
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Possimatch"

      source_root File.expand_path("../templates", __FILE__)

      argument :from_class, :type => :string
      argument :to_class, :type => :string
      argument :group_key, :type => :string

      def generate_config_file
        @boilerplate = Possimatch::Generators::Boilerplate.new(resource_class, from_class, to_class, group_key)
        template "possi_resource.rb", "app/models/possimatches/#{@boilerplate.get_file_name}.rb"
      end
    end
  end
end