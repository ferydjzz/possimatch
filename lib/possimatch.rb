require "possimatch/version"
require "possimatch/helpers/configuration"
require "app/models/possi_resource"
require "app/models/possi_rule"
require "app/models/possi_match"

module Possimatch
  
  # == default value for confirguration
  extend Configuration
  define_setting :possible_matches, 3
  define_setting :stop_after_match, false

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