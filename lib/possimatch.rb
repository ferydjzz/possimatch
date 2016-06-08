require "active_record"
require "possimatch/version"
require "possimatch/helpers/configuration"
require "possimatch/app/models/possi_resource.rb"
require "possimatch/app/models/possi_rule.rb"
require "possimatch/app/models/possi_match.rb"

module Possimatch
  
  # == default value for confirguration
  extend Configuration
  define_setting :possible_matches, 3
  define_setting :stop_after_match, false

  class << self
    def show_resources
    end
  end

end