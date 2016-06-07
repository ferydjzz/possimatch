module Possimatch
  class PossiResource < ::ActiveRecord::Base
    validates_presence_of :source_id
    validates_presence_of :from_source
    validates_presence_of :to_source
    validates_presence_of :group_key

    has_many :possi_rules

    def build_matcher
      query = "SELECT * FROM transactions 
                  LIMIT 1"
    end
  end
end