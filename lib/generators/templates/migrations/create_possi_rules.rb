class CreatePossiRules < ActiveRecord::Migration
  def self.up
    create_table :possi_rules do |t|
      t.integer  :possi_source_id
      t.string   :from_source_field
      t.string   :to_source_field
      t.string   :data_type
      t.decimal  :margin
      t.timestamps
    end

    add_index :possi_rules, [:company_id, :possi_source_id]
  end

  def self.down
    drop_table :possi_rules
  end
end
