class Order < ActiveRecord::Base
  attr_accessible :account_id, :delivery_id

  belongs_to :user
  belongs_to :account
  belongs_to :delivery

  validates :user_id, :presence => true
  validates :account_id, :presence => true
  validates :delivery_id, :presence => true
end
