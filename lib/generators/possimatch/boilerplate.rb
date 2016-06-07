module Possimatch
  module Generators
    class Boilerplate

      def initialize(class_name, from_class, to_class, group_key)
        @class_name = class_name
        @from_class = from_class
        @to_class   = to_class
        @group_key  = group_key
      end

      def get_class_name
        "possi_#{@class_name}".classify
      end

      def get_file_name
        "#{get_class_name.tableize.singularize}.rb"
      end
    end
  end
end