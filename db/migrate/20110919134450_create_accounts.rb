class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :employer_id
      t.integer :owner_id
      t.string :table
      t.integer :guests

      t.timestamps
    end
    add_index :accounts, :employer_id
    add_index :accounts, :owner_id
  end

  def self.down
    drop_table :accounts
  end
end
