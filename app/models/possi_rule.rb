module Possimatch
  class PossiRule < ActiveRecord::Base
    validates_presence_of :from_source_field
    validates_presence_of :to_source_field
    validates_presence_of :data_type
    validates_presence_of :margin
  end
end