class PossiMatch < ActiveRecord::Base
  validates_presence_of :from_source_id
  validates_presence_of :from_source
end