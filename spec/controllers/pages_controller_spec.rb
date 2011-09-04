require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
     @base_title = "Pupetto App"
  end

  describe "GET 'home'" do

    describe "when not signed in" do
      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end
    
      it "should have the right title" do
        response.should have_selector("title",:content=> @base_title + " | Home")
      end
    end
    
    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end
  end

  describe "GET 'menu'" do

    describe "when not signed in" do
      it "should redirect to home page" do
        get :menu
        response.should redirect_to(root_path)
      end
    end
    
    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      it "should have the right title" do
        get :menu
        response.should have_selector("title",:content=> @base_title + " | Menu")
      end

      it "should show the user menus" do
        menu1 = Factory(:menu, :user => @user, :content => "Foo bar")
        menu2 = Factory(:menu, :user => @user, :content => "Baz quux")
        get :menu
        response.should have_selector("span.content", :content => menu1.content)
        response.should have_selector("span.content", :content => menu2.content)
      end
      
    end
  end
  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",:content=> @base_title + " | Contact")
    end
  end
 
 describe "GET 'about'" do
      it "should be successful" do
      get "about"
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",:content=> @base_title + " | About")
    end
  end

 describe "GET 'help'" do
      it "should be successful" do
      get "help"
      response.should be_success
    end
    
    it "should have the right title" do
      get 'help'
      response.should have_selector("title",:content=> @base_title + " | Help")
    end
  end

end
