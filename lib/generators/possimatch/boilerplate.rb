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
        "Possi#{@resource_class}"
      end
    end
  end
end