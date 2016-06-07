class <%= @boilerplate.get_class_name %> < PossiResource
  belongs_to <%= @class_name.tableize.singularize %>
end