class <%= @boilerplate.get_class_name %> < ActiveRecord::Base
  belongs_to <%= @class_name.tableize.singularize %>
end