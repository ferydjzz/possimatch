class <%= @boilerplate.get_class_name %> < Possimatch::PossiResource
  belongs_to :<%= "#{class_name.tableize.singularize}" %>

# == automatic create resource when new <%= "#{class_name.tableize.singularize}" %> created
# add this callback and function to class <%= "#{class_name.classify}" %>
# and don't forget to add relationship.
#
# after_create :create_possisource
#
# def create_possisource
#   <%= @boilerplate.get_class_name %>.create(source_id: self.id)
# end
#
# has_one :<%= "#{class_name.tableize.singularize}" %>, foreign_key: 'source_id'
#
# == automatic create default rules when resource created
# callback to create default rules, You can create multiple rules by
# multiplying create_rule function
#
# after_create :create_possi_rules
# 
# def create_possi_rules
#   create_rule('<field in <%= @from_class.tableize %>>', '<field in <%= @to_class.tableize %>>', '<data type for checking field (date/decimal/percent)>', <error margin (number)>)
# end
#

  def self.source_class
    <%= class_name.classify %>
  end

  def self.from_class
    <%= @from_class.classify %>
  end

  def self.to_class
    <%= @to_class.classify %>
  end  

  def self.group_class
    <%= @group_key.split('_id').first.classify %>
  end
  
  def self.group_key
    "<%= @group_key.to_s %>"
  end

  private

  def exclude_ids_from_source
    []
  end

  def exclude_ids_to_source
    []
  end
end