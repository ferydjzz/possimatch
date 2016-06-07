module Possimatch
  module Generators
    class Boilerplate

      def initialize(resource_class, from_class, to_class, group_key)
        @resource_class = resource_class
        @from_class     = from_class
        @to_class       = to_class
        @group_key      = group_key
        @class_name     = get_class_name
      end

      def get_class_name
        "possi_#{@resource_class}".classify
      end

      def get_file_name
        @class_name.tableize.singularize
      end
    end
  end
end