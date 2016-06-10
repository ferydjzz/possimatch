require 'generators/possimatch/boilerplate'

module Possimatch
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Possimatch"

      source_root File.expand_path("../templates", __FILE__)

      argument :from_class, :type => :string
      argument :to_class, :type => :string
      argument :group_key, :type => :string

      def generate_possi_model
        @boilerplate = Possimatch::Generators::Boilerplate.new(class_name, from_class, to_class, group_key)
        template "models/possi_resource.rb", "app/models/#{@boilerplate.get_file_name}"
      end
    end
  end
end