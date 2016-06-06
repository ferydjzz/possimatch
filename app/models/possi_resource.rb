class PossiResource < ActiveRecord::Base
  validates_presence_of :resource_id
  validates_presence_of :from_source
  validates_presence_of :to_source
  validates_presence_of :group_key

  def self.register(params)
    ps = PossiResource.new(params)
    if ps.valid?
      ps.save
    else
      ps.errors.full_messages
    end
  end
end