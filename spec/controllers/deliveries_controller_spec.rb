require 'spec_helper'

describe DeliveriesController do
  render_views

  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => 1
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

 describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @menu = Factory(:menu, :user => @user, :content => "Foo bar")
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :menu_id => @menu.id }
      end

      it "should not create a delivery" do
        lambda do
          post :create, :delivery => @attr
        end.should_not change(Delivery, :count)
      end

      it "should render the menu page" do
        post :create, :delivery => @attr
        response.should redirect_to('/menu')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Lorem ipsum", :menu_id => @menu.id }
      end

      it "should create a delivery" do
        lambda do
          post :create, :delivery => @attr
        end.should change(Delivery, :count).by(1)
      end

      it "should redirect to the menu page" do
        post :create, :delivery => @attr
        response.should redirect_to("/menu")
      end

      it "should have a flash message" do
        post :create, :delivery => @attr
        flash[:success].should =~ /delivery created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @menu = Factory(:menu, :user => @user)
        @delivery = Factory(:delivery, :menu => @menu, :name => "Foo bar")
      end

      it "should deny access" do
        delete :destroy, :id => @delivery
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @menu = Factory(:menu, :user => @user)
        @delivery = Factory(:delivery, :menu => @menu, :name => "Foo bar")
      end

      it "should destroy the menu" do
        lambda do
          delete :destroy, :id => @delivery
        end.should change(Delivery, :count).by(-1)
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @menu = Factory(:menu, :user => @user, :content => "Foo bar")
      @delivery = Factory(:delivery, :menu => @menu, :name => "Foo bar")
    end

    it "should be successful" do
      get 'edit',  :id => @delivery 
      response.should be_success
    end
   
    it "should have the right tithe" do
      get :edit, :id => @delivery
      response.should have_selector("title", :content => "Edit menu voice")
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @menu = Factory(:menu, :user => @user, :content => "Foo bar")
      @delivery = Factory(:delivery, :menu => @menu, :name => "Foo bar")
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :menu_id => @menu.id }
      end

      it "should render the 'edit' page" do
        put :update, :id => @delivery, :delivery => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @delivery, :delivery => @attr
        response.should have_selector("title", :content => "Edit menu voice")
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:name => "barbaz", :descr => " descriptio", :price => 100 }
      end

      it "should change the menu's attributes" do
        put :update, :id => @delivery, :delivery => @attr
        @delivery.reload
        @delivery.name.should == @attr[:name]
        @delivery.descr.should == @attr[:descr]
        @delivery.price.should == @attr[:price]
      end

      it "should redirect to the menu page" do
        put :update, :id => @delivery, :delivery => @attr
        response.should redirect_to('/menu')
      end

      it "should have a flash message" do
        put :update, :id => @delivery, :delivery => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

end
