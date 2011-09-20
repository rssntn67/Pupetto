class Account < ActiveRecord::Base
  attr_accessible :owner_id, :table, :guests

  belongs_to :employer, :class_name => "User"
  belongs_to :owner,    :class_name => "User"

  has_many   :orders, :dependent => :destroy

  validates :employer_id, :presence => true
  validates :owner_id, :presence => true
  validates :table, :presence => true
  validates :guests, :presence => true


  default_scope :order => 'accounts.created_at'

  scope :from_users_employed_with, lambda { |user| working_with(user) }

  private 

  def self.working_with(user)
     owner_ids = %(SELECT owner_id FROM workrelations
                   WHERE employer_id = :user_id)  
     where("owner_id IN (#{owner_ids}) OR owner_id = :user_id",
          { :user_id => user })
  end

end
