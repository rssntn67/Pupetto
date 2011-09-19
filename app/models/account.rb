class Account < ActiveRecord::Base
  attr_accessible :owner_id, :table, :guests

  belongs_to :employer, :class_name => "User"
  belongs_to :owner,    :class_name => "User"

  default_scope :order => 'accounts.created_at'

  validates :employer_id, :presence => true
  validates :owner_id, :presence => true
  validates :table, :presence => true
  validates :guests, :presence => true
end
