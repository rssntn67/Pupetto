class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :account_id
      t.integer :delivery_id
      t.integer :user_id

      t.timestamps
    end
    add_index :orders, :account_id
    add_index :orders, :delivery_id
    add_index :orders, :user_id
  end

  def self.down
    drop_table :orders
  end
end
