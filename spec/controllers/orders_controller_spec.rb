require 'spec_helper'

describe OrdersController do
  render_views
  
  describe "access control when not signed in" do

    it "should deny access to 'increase'" do
      post :increase,:id=> "1"
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'decrease'" do
      post :decrease,:id=> "1"
      response.should redirect_to(signin_path)
    end

  end

  describe "'increase'" do
    before(:each) do
      @owner = Factory(:user)
      @menu = Factory(:menu, :user => @owner, :content => "Foo bar")
      @del1 = Factory(:delivery, :menu => @menu, :name => "Spaghetti")
      @del2 = Factory(:delivery, :menu => @menu, :name => "Rigatoni")
      @employer = Factory(:user, :email => Factory.next(:email))
      @owner.employ!(@employer)
      @account = Factory(:account, :employer => @employer, :owner => @owner)
      @attr = { :account_id => @account.id, :delivery_id => @del1.id, :count => 0}
    end

    it "should be successful" do
      test_sign_in(@employer)
      post 'increase', :id=> @account.id, :order => @attr 
      response.should redirect_to(order_account_path(@account))
    end

    it "should grant access to owner" do
      test_sign_in(@owner)
      post 'increase', :id=> @account.id, :order => @attr 
      response.should redirect_to(order_account_path(@account))
    end

    it "should deny access to others" do
      test_sign_in(Factory(:user, :email => Factory.next(:email)))
      post 'increase', :id=> @account.id, :order => @attr 
      response.should redirect_to(root_path)
    end

    it "should create the order with count 1 if it is 0" do
      test_sign_in(@employer)
      lambda do
        post 'increase', :id=> @account.id, :order => @attr 
      end.should change(Order, :count).by(1)
    end

    it "should increase order count by 1 if it exists" do
      test_sign_in(@employer)
      order1 = Factory(:order,:user => @employer,:account => @account,:delivery => @del1, :count => 5)
      post 'increase', :id=> @account.id, :order => order1 
      Order.find_by_account_id_and_delivery_id(@account.id, @del1.id ).count.should == 6
    end
  end

  describe "'decrease'" do
    before(:each) do
      @owner = Factory(:user)
      @menu = Factory(:menu, :user => @owner, :content => "Foo bar")
      @del1 = Factory(:delivery, :menu => @menu, :name => "Spaghetti")
      @del2 = Factory(:delivery, :menu => @menu, :name => "Rigatoni")
      @employer = Factory(:user, :email => Factory.next(:email))
      @owner.employ!(@employer)
      @account = Factory(:account, :employer => @employer, :owner => @owner)
      @attr = { :account_id => @account.id, :delivery_id => @del1.id, :count => 0}
    end

    it "should be successful" do
      test_sign_in(@employer)
      post 'decrease', :id => @account.id, :order => @attr 
      response.should redirect_to(order_account_path(@account))
    end

    it "should grant access to owner" do
      test_sign_in(@owner)
      post 'decrease', :id=> @account.id, :order => @attr 
      response.should redirect_to(order_account_path(@account))
    end

    it "should deny access to others" do
      test_sign_in(Factory(:user, :email => Factory.next(:email)))
      post 'decrease', :id=> @account.id, :order => @attr 
      response.should redirect_to(root_path)
    end

    it "should do nothing if order has count 0" do
      test_sign_in(@employer)
      lambda do
        post 'decrease', :id=> @account.id, :order => @attr 
      end.should change(Order, :count).by(0)
    end

    it "should destroy order if has count 1" do
      test_sign_in(@employer)
      order1 = Factory(:order,:user => @employer,:account => @account,:delivery => @del1, :count => 1)
      lambda do
        post 'decrease', :id=> @account.id, :order => @attr 
      end.should change(Order, :count).by(-1)
    end

    it "should decrease order count by 1 if count > 1" do
      test_sign_in(@employer)
      order1 = Factory(:order,:user => @employer,:account => @account,:delivery => @del1, :count => 5)
      post 'decrease', :id=> @account.id, :order => order1 
      Order.find_by_account_id_and_delivery_id(@account.id, @del1.id ).count.should == 4
    end
  end

end
