class CreatePossiResources < ActiveRecord::Migration
  def self.up
    create_table :possi_resources do |t|
      t.integer  :source_id
      t.string   :from_source
      t.string   :to_source
      t.string   :group_key
      t.integer  :minimal_percentage, default: nil
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :possi_resources
  end
end
