require 'generators/possimatch/boilerplate'

module Possimatch
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Possimatch"

      class_option :include_boilerplate, type: :boolean, default: true,
        desc: "Generate boilerplate code for your resource."

      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "<class_name>[:from_class] <class_name>[:to_class] <group_id>[:group_key]"

      def generate_config_file
        from_class = attributes.select{ |a| a.type == "from_class"}
        to_class = attributes.select{ |a| a.type == :to_class}
        group_key = attributes.select{ |a| a.type == :"group_key"}

        puts "#{attributes.each{ |a| [a.name] }}"
        puts "from_class: #{from_class}, to_class: #{to_class}, group_key: #{group_key}"
        @boilerplate = Possimatch::Generators::Boilerplate.new(class_name, from_class, to_class, group_key)
        template "possi_resource.rb", "app/models/possimatches/#{file_path.tr('/', '_')}.rb"
      end
    end
  end
end