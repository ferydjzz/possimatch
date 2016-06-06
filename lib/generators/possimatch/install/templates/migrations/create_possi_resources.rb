class CreatePossiResources < ActiveRecord::Migration
  def self.up
    create_table :possi_resources do |t|
      t.integer  :resource_id
      t.string   :from_source
      t.string   :to_source
      t.string   :group_key
      t.timestamps null: false
    end

    add_index :possi_resources, [:resource_id, :group_key] 
  end

  def self.down
    drop_table :possi_resources
  end
end
