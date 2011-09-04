class Menu < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 40 }
  validates :user_id, :presence => true
  
  default_scope :order => 'menus.id'
end
