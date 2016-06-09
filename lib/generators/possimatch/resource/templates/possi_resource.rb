class <%= @boilerplate.get_class_name %> < Possimatch::PossiResource
  belongs_to :<%= "#{class_name.tableize.singularize}" %>

# == automatic create resource when new <%= "#{class_name.tableize.singularize}" %> created
# add this callback and function to class <%= "#{class_name.classify}" %>
# 
# after_create :create_possisource
#
# def create_possisource
#   <%= @boilerplate.get_class_name %>.create(source_id: self.id)
# end
#
# == automatic create default rules when resource created
# callback to create default rules
#
# after_create :create_default_rules
# 
# def create_default_rules
#   self.possi_rules.create(from_source_field: '<field in <%= @from_class.tableize %>>', 
#                         to_source_field: '<field in <%= @to_class.tableize %>>',
#                         group_key: '<field in both class to be identifier>')
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

  def self.group_key
    "<%= @group_key.to_s %>"
  end
end