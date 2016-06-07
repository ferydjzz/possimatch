module Possimatch
  class PossiResource < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source
    validates_presence_of :to_source
    validates_presence_of :group_key

    has_many :possi_rules

    def self.register_existing_data
      puts "#{self.source_class}"
      # query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key) VALUES (),()"
      # ActiveRecord::Base.connection.execute(query)
    end

    def register
      # query = "INSERT INTO possi_resources (source_id, from_source, to_source, group_key) 
      #           VALUES (#{self.source_id}, self.#{from_source})"
      # ActiveRecord::Base.connection.execute(query)
    end

    def self.source_class
      raise NotImplementedError
    end

    def self.from_class
      raise NotImplementedError
    end

    def self.to_class
      raise NotImplementedError
    end  

    def self.group_key
      raise NotImplementedError
    end
  end
end