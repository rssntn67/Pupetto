class AddOrdersUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :orders, [:account_id, :delivery_id], :unique => true
  end

  def self.down
    remove_index :orders, [:account_id, :delivery_id], :unique => true
  end
end
