class <%= @class_name %> < ActiveRecord::Base
  belongs_to <%= @resource_class.tableize.singularize %>
  belongs_to <%= @from_source.tableize.singularize %>
  belongs_to <%= @to_source.tableize.singularize %>
end