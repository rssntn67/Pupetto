require 'spec_helper'


describe AccountsController do

  render_views

  describe "GET 'show'" do

    before(:each) do
      @owner = Factory(:user)
      @employer = Factory(:user, :email => Factory.next(:email))
      @owner.employ!(@employer)
      @account = Factory(:account, :employer => @employer, :owner => @owner)
    end

    describe "when not signed" do
      it "should redirect to sign in page" do
        get :show, :id => @account
        response.should redirect_to(signin_path)    
      end
    end

    describe "when signed in" do
      describe "page layout" do
        before(:each) do
          test_sign_in(@employer)
        end

        it "should be successful" do
          get :show, :id => @account
          response.should be_success
        end

        it "should have the right title" do
          get :show, :id => @account
          response.should have_selector("title", :content => @account.table)
        end

        it "should include the table name" do
          get :show, :id => @account
          response.should have_selector("h1", :content => @account.table)
        end

        it "should have the right account" do
          get :show, :id => @account
          assigns(:account).should == @account
        end

        it "should show the orders list" do
          menu = Factory(:menu, :user => @employer)
          del1 = Factory(:delivery, :menu => menu)
          del2 = Factory(:delivery, :menu => menu, :name => "Spaghetti al Sugo")
          order1 = Factory(:order, :user => @employer, :account => @account, :delivery => del1)
          order2 = Factory(:order, :user => @owner, :account => @account, :delivery => del2)
          get :show, :id => @account
          response.should have_selector("span.content", :content => order1.delivery.name)
          response.should have_selector("span.content", :content => order2.delivery.name)
        end

        it "should show the orders count single price and total price" do
          menu = Factory(:menu, :user => @employer)
          del1 = Factory(:delivery, :menu => menu, :price => 11 )
          order1 = Factory(:order, :user => @employer, :account => @account, :delivery => del1, :count => 4 )
          get :show, :id => @account
          response.should have_selector("span.content", :content => order1.delivery.name)
          response.should have_selector("span.content", :content => "4")
          response.should have_selector("span.content", :content => "11")
          response.should have_selector("span.content", :content => "44")
        end
      end
    
      describe "access permissions" do
        it "should allow access to owner" do
          test_sign_in(@owner)
          get :show, :id => @account
          response.should be_success
        end

        it "should allow access to another common employer" do
           @employer_other = Factory(:user, :email => Factory.next(:email))
           @owner.employ!(@employer_other)
           test_sign_in(@employer_other)
           get :show, :id => @account
           response.should be_success
        end

        it "should deny access to another user" do
           @user_other = Factory(:user, :email => Factory.next(:email))
           test_sign_in(@user_other)
           get :show, :id => @account
           response.should redirect_to(root_path)
        end
      end
    end

  end
end
