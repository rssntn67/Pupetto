class Delivery < ActiveRecord::Base
  attr_accessible :name, :descr, :price

  belongs_to :menu
 
  has_many :orders, :dependent => :destroy
  
  validates :name, :presence => true, :length => {:maximum => 60}
  validates :menu_id, :presence => true 
end
