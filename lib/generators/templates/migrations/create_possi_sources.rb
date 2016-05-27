class CreatePossiSources < ActiveRecord::Migration
  def self.up
    create_table :possi_sources do |t|
      t.integer  :source_id
      t.string   :from_source
      t.string   :to_source
      t.string   :group_key
      t.timestamps null: false
    end

    add_index :possi_sources, [:source_id, :group_key] 
  end

  def self.down
    drop_table :possi_sources
  end
end
