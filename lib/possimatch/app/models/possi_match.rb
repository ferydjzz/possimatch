module Possimatch
  class PossiMatch < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source_id
    validates_presence_of :to_source_id
  
    def self.get_possible_matches_data(source_id)
      self.all.where("source_id = ?", source_id)
    end
  end
end