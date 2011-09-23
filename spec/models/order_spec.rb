require 'spec_helper'

describe Order do
  before(:each) do
    @employer = Factory(:user)
    @owner    = Factory(:user, :email => Factory.next(:email))
    @user     = Factory(:user, :email => Factory.next(:email))
    @menu     = Factory(:menu, :user => @owner, :content => "primi piatti")
    @delivery = Factory(:delivery, :menu => @menu, :name => "soute di vongole", :descr => "vongole cotte in olio di oliva", :price => 15 )
    @account  = Factory(:account, :employer => @employer, :owner => @owner) 

    @order    = @user.orders.build(:delivery_id => @delivery.id, :account_id => @account.id, :count => 3)
  end
  
  it "should create a new instance given valid attribute" do
     @order.save!
  end
   
  describe "attributes" do
    before(:each) do
      @order.save
    end

    it "should have a user attribute" do
      @order.should respond_to(:user) 
    end

    it "should have a account attribute" do
      @order.should respond_to(:account) 
    end

    it "should have a delivery attribute" do
      @order.should respond_to(:delivery) 
    end
 
    it "should have a count attribute" do
      @order.should respond_to(:count) 
    end
 
    it "should have the right user" do
      @order.user.should == @user
    end
 
    it "should have the right account" do
      @order.account.should == @account
    end
 
    it "should have the right delivery" do
      @order.delivery.should == @delivery
    end

  end

  describe "validations" do

    it "should require a user_id" do
      @order.user_id=nil
      @order.should_not be_valid
    end

    it "should require an account_id" do
      @order.account_id=nil
      @order.should_not be_valid
    end

    it "should require a count" do
      @order.count=nil
      @order.should_not be_valid
    end

    it "should require an delivery_id" do
      @order.delivery_id=nil
      @order.should_not be_valid
    end

  end
end
