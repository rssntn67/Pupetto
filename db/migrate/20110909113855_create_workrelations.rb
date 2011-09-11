class CreateWorkrelations < ActiveRecord::Migration
  def self.up
    create_table :workrelations do |t|
      t.integer :owner_id
      t.integer :employer_id

      t.timestamps
    end
    add_index :workrelations, :owner_id
    add_index :workrelations, :employer_id
    add_index :workrelations, [:owner_id, :employer_id], :unique => true
  end

  def self.down
    drop_table :workrelations
  end
end
