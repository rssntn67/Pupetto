class Workrelation < ActiveRecord::Base
  attr_accessible :employer_id
  
  belongs_to :owner, :class_name => "User"
  belongs_to :employer, :class_name => "User"

  validates  :owner_id, :presence => true
  validates  :employer_id, :presence => true
end
