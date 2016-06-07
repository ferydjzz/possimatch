module Possimatch
  module Generators
    class Boilerplate

      def initialize(resource_class, from_class, to_class, group_key)
        @resource_class = resource_class
        @from_class     = from_class
        @to_class       = to_class
        @group_key      = group_key
      end

      def get_class_name
        "possi_#{@resource_class}".classify
      end

      def get_file_name
        "#{get_class_name.tableize.singularize}.rb"
      end
    end
  end
end