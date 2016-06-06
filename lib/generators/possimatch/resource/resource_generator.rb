require 'active_admin/generators/boilerplate'

module Possimatch
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Possimatch"

      class_option :include_boilerplate, type: :boolean, default: true,
        desc: "Generate boilerplate code for your resource."

      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, :type => :array, :default => []

      puts attributes
      Rails.logger.info "attributes.each{ |a| a }"

      def generate_config_file
        @boilerplate = Possimatch::Generators::Boilerplate.new(source_class, from_class, to_class, group_key)
        template "possi_resource.rb", "app/models/possimatches/#{file_path.tr('/', '_')}.rb"
      end
    end
  end
end