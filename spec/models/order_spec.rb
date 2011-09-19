require 'spec_helper'

describe Order do
  before(:each) do
    @employer = Factory(:user)
    @owner    = Factory(:user, :email => Factory.next(:email))
    @user     = Factory(:user, :email => Factory.next(:email))
    @menu     = Factory(:menu, :user => @owner, :content => "primi piatti")
    @delivery = Factory(:delivery, :menu => @menu, :name => "soute di vongole", :descr => "vongole cotte in olio di oliva", :price => 15 )
    @account  = Factory(:account, :employer => @employer, :owner => @owner) 

    @order    = @user.orders.build(:delivery_id => @delivery.id, :account_id => @account.id)
  end
  
  it "should create a new instance given valid attribute" do
     @order.save!
  end
   
end
