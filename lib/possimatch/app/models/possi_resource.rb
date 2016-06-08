module Possimatch
  class PossiResource < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source
    validates_presence_of :to_source
    validates_presence_of :group_key

    has_many :possi_rules

    def self.register_existing_data
      check_data_validation

      # query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key) VALUES (),()"
      # ActiveRecord::Base.connection.execute(query)
    end

    def register
      check_data_validation
      # query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key) 
      #           VALUES (#{self.source_id}, self.#{from_source})"
      # ActiveRecord::Base.connection.execute(query)
    end

    def self.source_class
      raise NotImplementedError.new("You need to implement this method in child class.")
    end

    def self.from_class
      raise NotImplementedError.new("You need to implement this method in child class.")
    end

    def self.to_class
      raise NotImplementedError.new("You need to implement this method in child class.")
    end  

    def self.group_key
      raise NotImplementedError.new("You need to implement this method in child class.")
    end

    # ============= Private ============= #
    private 

    def self.check_data_validation
      check_class_exist(self.source_class)
      check_class_exist(self.from_class)
      check_class_exist(self.to_class)

      check_field(self.group_key)
    end

    def self.check_class_exist(class_name)
      if defined?(Company).nil?
        raise NameError.new("Class #{class_name} doesn't exists.")
      end
      true
    end

    def self.check_field(field_name)
      error_data = []
      if self.from_class.column_names.exclude? "#{field_name}" 
        error_data << self.from_class
      end

      if self.to_class.column_names.exclude? "#{field_name}"
        error_data << self.from_class
      end

      if error_data.present?
        raise NameError.new("field #{field_name} doesn't exists in #{error_data.join(' and ')}.")
      end
      true
    end
  end
end