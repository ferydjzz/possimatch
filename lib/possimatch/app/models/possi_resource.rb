module Possimatch
  class PossiResource < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source
    validates_presence_of :to_source
    validates_presence_of :group_key

    has_many :possi_rules

    before_validation :sanitize_parameters

    def self.start_matching(specific_key=nil, insert_into_db=false)
      result = []
      self.all.each do |resource|
        result << resource.start_matching(specific_key, insert_into_db)
      end
      result
    end

    def start_matching(specific_key=nil, insert_into_db=false)
      result = self.get_all_matches_data(specific_key)
      if result.class == Mysql2::Result
        result = result.reject{|a|a.last < (self.minimal_score || Possimatch.minimal_score)}.group_by{|a|a[1]}.flat_map{|b|b.last.max_by(Possimatch.possible_matches, &:first)}
        if insert_into_db == true && result.length > 0
          query = "INSERT INTO possi_matches (source_id, from_source_id, to_source_id, score, created_at, updated_at) VALUES "
          result.each_with_index do |data, idx|
            if idx == 0
              query += " ('#{data.join("', '")}', '#{Time.now.strftime("%F %T")}', '#{Time.now.strftime("%F %T")}')"
            else
              query += ", ('#{data.join("', '")}', '#{Time.now.strftime("%F %T")}', '#{Time.now.strftime("%F %T")}')"
            end
          end
          query += "ON DUPLICATE KEY UPDATE 
                          score = VALUES(score), 
                          created_at = VALUES(created_at),
                          updated_at = VALUES(updated_at)"
          ActiveRecord::Base.connection.execute(query)
        end
      end
      result
    end

    def get_all_matches_data(specific_key=nil)
      all_rules = get_all_rules

      if all_rules.present?
        query = "SELECT from_source.#{self.class.group_key},
                        from_source.id AS from_source_id, 
                        to_source.id   AS to_source_id, "
        rule_cond = ""
        rule_fields = "" 
        rule_fields_cond = ""

        all_rules.each_with_index do |rule, idx|
          if rule.data_type == "decimal"
            rule_cond += " IF(IFNULL(from_source.#{rule.from_source_field},0) = IFNULL(to_source.#{rule.to_source_field},0)
                          , 100/#{all_rules.length}"
          else
            rule_cond += " IF(from_source.#{rule.from_source_field} = to_source.#{rule.to_source_field}
                          , 100/#{all_rules.length}"
          end

          if rule.margin == 0
            rule_cond += ", 0) "
          elsif rule.data_type == "date"
            rule_cond += ", 100/#{all_rules.length} * (IF(DATEDIFF(to_source.#{rule.to_source_field}, from_source.#{rule.from_source_field} < 0
                                                        , DATEDIFF(to_source.#{rule.to_source_field}, from_source.#{rule.from_source_field} * -1
                                                        , DATEDIFF(to_source.#{rule.to_source_field}, from_source.#{rule.from_source_field})) / #{rule.margin}) ) "
          else
            rule_cond += ", 100/#{all_rules.length} * (IF(IFNULL(to_source.#{rule.to_source_field},0) - IFNULL(from_source.#{rule.from_source_field},0) < 0 
                                                        , IFNULL(to_source.#{rule.to_source_field},0) - IFNULL(from_source.#{rule.from_source_field},0) * -1
                                                        , IFNULL(to_source.#{rule.to_source_field},0) - IFNULL(from_source.#{rule.from_source_field},0) / IFNULL(from_source.#{rule.from_source_field},0) * (#{rule.margin} / 100))) ) "
          end

          if all_rules.length > 1 && idx != all_rules.length-1
            rule_cond += " + "
          else
            rule_cond += " AS score "
          end

          rule_fields_cond += " OR " if idx != 0

          rule_fields += ", from_in.#{rule.from_source_field} "
          
          if rule.data_type == "date"
            rule_fields_cond += " (to_source.#{rule.to_source_field} >= DATE_ADD(from_source.#{rule.from_source_field},interval (-1 * #{rule.margin}) day) 
                                      AND to_source.#{rule.to_source_field} <= DATE_ADD(from_source.#{rule.from_source_field},interval #{rule.margin} day)) "
            
          else
            rule_fields_cond += " (IFNULL(to_source.#{rule.to_source_field},0) >= (IFNULL(from_source.#{rule.from_source_field},0) - (IFNULL(from_source.#{rule.from_source_field},0) * (#{rule.margin} / 100))) 
                                      AND IFNULL(to_source.#{rule.to_source_field},0) >= (IFNULL(from_source.#{rule.from_source_field},0) + (IFNULL(from_source.#{rule.from_source_field},0) * (#{rule.margin} / 100)))) "
          end    
        end
        query += rule_cond

        from_cond = "FROM #{self.class.group_class.to_s.tableize} gkey
                LEFT JOIN #{self.class.to_class.to_s.tableize} to_source ON to_source.#{self.class.group_key} = gkey.id
                LEFT JOIN (select from_in.id, from_in.#{self.class.group_key} "
        
        from_cond += rule_fields

        from_cond += "FROM #{self.class.from_class.to_s.tableize} from_in
                            WHERE from_in.#{self.class.source_class.to_s.tableize.singularize}_id = #{self.source_id}) from_source ON from_source.#{self.class.group_key} = to_source.#{self.class.group_key}
                WHERE gkey.#{self.class.source_class.to_s.tableize.singularize}_id = #{self.source_id} AND "
        from_cond += " ( #{rule_fields_cond} ) "
        if specific_key.present?
          from_cond += " AND from_source.#{self.class.group_key} = #{specific_key} "
        end

        from_cond += " AND from_source.id NOT IN (#{exclude_ids_from_source.join(',')}) " if exclude_ids_from_source.present?
        from_cond += " AND to_source.id NOT IN (#{exclude_ids_to_source.join(',')}) " if exclude_ids_to_source.present?
        
        order_cond = " ORDER BY from_source_id, to_source_id, score DESC"
        query = "#{query} #{from_cond} #{order_cond}"
        ActiveRecord::Base.connection.execute(query)
      else
        return "Rules have not been registered, please register at least 1 rule."
      end
    end

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

      # data = self.pluck(:id).map{|a|[a, from_source_field, to_source_field, data_type, margin, Time.now.strftime("%F %T"), Time.now.strftime("%F %T")]}
      query = "INSERT INTO possi_rules (possi_resource_id, from_source_field, to_source_field, data_type, margin, is_system, created_at, updated_at) VALUES "
      values = "(0, '#{from_source_field}', '#{to_source_field}', '#{data_type}', #{margin}, #{true}, '#{Time.now.strftime("%F %T")}', '#{Time.now.strftime("%F %T")}')"

      # data.each do |d|
      #   if values.blank?
      #     values += " ('#{d.join("', '")}')"
      #   else
      #     values += ", ('#{d.join("', '")}')"
      #   end
      # end

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
    
    def get_all_rules
      all_rules = nil
      if self.possi_rules.present?
        all_rules = self.possi_rules
      elsif PossiRule.system_rules.present?
        all_rules = PossiRule.system_rules
      end
      all_rules
    end 

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

    def exclude_ids_from_source
      []
    end

    def exclude_ids_to_source
      []
    end
  end
end