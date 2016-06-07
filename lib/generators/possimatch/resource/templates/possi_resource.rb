class <%= @boilerplate.get_class_name %> < Possimatch::PossiResource
  belongs_to <%= class_name.to_s.tableize.singularize.to_sym %>
end