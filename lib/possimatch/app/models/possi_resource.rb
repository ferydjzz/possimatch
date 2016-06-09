module Possimatch
  class PossiResource < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source
    validates_presence_of :to_source
    validates_presence_of :group_key

    has_many :possi_rules

    before_validation :sanitize_parameters

    def self.create_default_resource
      check_data_validation

      data = self.source_class.pluck(:id).map{|a|[a, self.from_class.to_s, self.to_class.to_s, self.group_key.to_s, Time.now.strftime("%F %T"), Time.now.strftime("%F %T")]}
      query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key, created_at, updated_at) VALUES "
      values = ""

      data.each do |d|
        if values.blank?
          values += " ('#{d.join("', '")}')"
        else
          values += ", ('#{d.join("', '")}')"
        end
      end

      query = "#{query} #{values}"
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_default_rule(from_source_field, to_source_field, data_type, margin)
      check_field(from_source_field, self.from_class)
      check_field(to_source_field, self.to_class)

      data = self.pluck(:id).map{|a|[a, from_source_field, to_source_field, data_type, margin, Time.now.strftime("%F %T"), Time.now.strftime("%F %T")]}
      query = "INSERT INTO possi_rules (possi_resource_id, from_source_field, to_source_field, data_type, margin, created_at, updated_at) VALUES "
      values = ""

      data.each do |d|
        if values.blank?
          values += " ('#{d.join("', '")}')"
        else
          values += ", ('#{d.join("', '")}')"
        end
      end

      query = "#{query} #{values}"
      ActiveRecord::Base.connection.execute(query)
    end

    def create_rule(from_source_field, to_source_field, data_type, margin)
      self.class.check_field(from_source_field, self.class.from_class)
      self.class.check_field(to_source_field, self.class.to_class)

      pr = PossiRule.new(possi_resource_id: self.id, from_source_field: from_source_field, to_source_field: to_source_field, data_type: data_type, margin: margin)
      if pr.valid?
        pr.save!
      else
        pr.errors.full_messages
      end
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

    def sanitize_parameters
      self.from_source ||= self.class.from_class.to_s
      self.to_source ||= self.class.to_class.to_s
      self.group_key ||= self.class.group_key.to_s
    end

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