class Delivery < ActiveRecord::Base
  attr_accessible :name, :descr, :price

  belongs_to :menu
  
  validates :name, :presence => true, :length => {:maximum => 60}
  validates :menu_id, :presence => true 
end
