require "possimatch/version"
require "possimatch/helpers/configuration"

module Possimatch
  class << self
    def register_resource(resource_id, from_source, to_source, group_key)
      params = {resource_id: resource_id, from_source: from_source, to_source: to_source, group_key: group_key}
      pr = PossiResource.register(params)
      pr
    end

    def show_resources
    end
  end

end