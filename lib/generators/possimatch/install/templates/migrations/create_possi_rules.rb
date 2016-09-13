class CreatePossiRules < ActiveRecord::Migration
  def self.up
    create_table :possi_rules do |t|
      t.integer  :possi_resource_id
      t.string   :from_source_field
      t.string   :to_source_field
      t.string   :data_type
      t.decimal  :margin, :precision => 50, :scale => 6
      t.boolean  :is_system, default: false
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :possi_rules
  end
end
