class AddCountToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :count, :integer
  end

  def self.down
    remove_column :orders, :count
  end
end
