class CreatePossiRules < ActiveRecord::Migration
  def self.up
    create_table :possi_rules do |t|
      t.integer  :possi_resource_id
      t.string   :from_source_field
      t.string   :to_source_field
      t.string   :data_type
      t.decimal  :margin
      t.timestamps
    end
  end

  def self.down
    drop_table :possi_rules
  end
end
