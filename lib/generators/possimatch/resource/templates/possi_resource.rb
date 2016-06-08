class <%= @boilerplate.get_class_name %> < Possimatch::PossiResource
  belongs_to :<%= "#{class_name.tableize.singularize}" %>

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
    <%= @group_key.to_s %>
  end
end