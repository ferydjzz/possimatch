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

  class << self
    def self.create_default_resource
      PossiResource.descendants.each do |resource|
        resource.create_default_resource
      end
    end

    def self.start_matching
      PossiResource.descendants.each do |resources|
        resources.each do |resource|
          result = resource.get_all_matches_data
          result.group_by{ |a| a["from_source_id"] }
        end 
      end
    end
  end

end