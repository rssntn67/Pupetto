class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :menus, :user_id
  end

  def self.down
    drop_table :menus
  end
end
