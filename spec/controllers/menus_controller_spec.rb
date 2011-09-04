require 'spec_helper'

describe MenusController do
    
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
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
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a menu" do
        lambda do
          post :create, :menu => @attr
        end.should_not change(Menu, :count)
      end

      it "should render the menu page" do
        post :create, :menu => @attr
        response.should redirect_to('/menu')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create a menu" do
        lambda do
          post :create, :menu => @attr
        end.should change(Menu, :count).by(1)
      end

      it "should redirect to the menu page" do
        post :create, :menu => @attr
        response.should redirect_to("/menu")
      end

      it "should have a flash message" do
        post :create, :menu => @attr
        flash[:success].should =~ /menu created/i
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
      end

      it "should deny access" do
        delete :destroy, :id => @menu
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @menu = Factory(:menu, :user => @user)
      end

      it "should destroy the menu" do
        lambda do 
          delete :destroy, :id => @menu
        end.should change(Menu, :count).by(-1)
      end
    end
  end
end
