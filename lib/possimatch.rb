require "possimatch/version"
require "possimatch/helpers/configuration"

module Possimatch
  class << self
    # == default value for confirguration
    define_setting :possible_matches, 3
    define_setting :stop_after_match, false
    
    def register_resource(resource_id, from_source, to_source, group_key)
      params = {resource_id: resource_id, from_source: from_source, to_source: to_source, group_key: group_key}
      pr = PossiResource.register(params)
      pr
    end

    def show_resources
    end
  end

end