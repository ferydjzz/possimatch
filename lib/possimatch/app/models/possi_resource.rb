module Possimatch
  class PossiResource < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source
    validates_presence_of :to_source
    validates_presence_of :group_key

    has_many :possi_rules

    def self.create_default_resource
      check_data_validation

      # check_field(from_field, self.from_class)
      # check_field(to_field, self.to_class)

      data = self.source_class.pluck(:id).map{|a|[a, self.from_class.to_s, self.to_class.to_s, self.group_key.to_s]}
      query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key) VALUES "
      values = ""
      data.each do |d|
        if values.blank?
          values += "('#{d.join("', '")}') "
        else
          values += ",('#{d.join("', '")}') "
        end
      end
      query = "#{query} #{values}"
      ActiveRecord::Base.connection.execute(query)
    end

    def register(source_id)
      check_data_validation
      query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key) VALUES (#{source_id}, '#{self.from_class.to_s}', '#{self.to_class.to_s}', '#{self.group_key.to_s}')"
      ActiveRecord::Base.connection.execute(query)
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

    def self.check_field(field_name, class_name=nil)
      error_data = []
      if class_name.nil?
        if self.from_class.column_names.exclude? "#{field_name}" 
          error_data << self.from_class
        end

        if self.to_class.column_names.exclude? "#{field_name}"
          error_data << self.from_class
        end
      elsif class_name.column_names.exclude? "#{field_name}"
        error_data << class_name
      end

      if error_data.present?
        raise NameError.new("field #{field_name} doesn't exists in #{error_data.join(' and ')}.")
      end
      true
    end
  end
end