class <%= @boilerplate.get_class_name %> < Possimatch::PossiResource
  belongs_to <%= class_name.tableize.singularize.to_sym %>
end