require 'generators/possimatch/boilerplate'

module Possimatch
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Possimatch"

      class_option :include_boilerplate, type: :boolean, default: true,
        desc: "Generate boilerplate code for your resource."

      source_root File.expand_path("../templates", __FILE__)

      argument :from_class, :type => :string
      argument :to_class, :type => :string
      argument :group_key, :type => :string

      def generate_config_file
        puts "from_class #{from_class}"
        puts "to_class #{to_class}"
        puts "group_key #{group_key}"
        # puts "#{attributes.each{ |a| [a.name] }}"
        # puts "from_class: #{from_class}, to_class: #{to_class}, group_key: #{group_key}"
        # @boilerplate = Possimatch::Generators::Boilerplate.new(class_name, from_class, to_class, group_key)
        # template "possi_resource.rb", "app/models/possimatches/#{file_path.tr('/', '_')}.rb"
      end
    end
  end
end