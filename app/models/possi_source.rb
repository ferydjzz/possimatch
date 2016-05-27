class PossiSource < ActiveRecord::Base
  validates_presence_of :source_id
  validates_presence_of :from_source
  validates_presence_of :to_source
  validates_presence_of :group_key
end