class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.string :name
      t.string :descr
      t.integer :menu_id
      t.integer :price

      t.timestamps
    end
    add_index :deliveries, :menu_id
    add_index :deliveries, :name
  end

  def self.down
    drop_table :deliveries
  end
end
