require 'active_record'

module Possimatch
  class PossiMatch < ::ActiveRecord::Base
    validates_presence_of :from_source_id
    validates_presence_of :to_source_id
  end
end