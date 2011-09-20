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
        employer_user = Factory(:user, :email => Factory.next(:email))
        @user.employ!(employer_user)
      end

      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
        response.should have_selector("a", :href => crew_user_path(@user),
                                           :content => "1 employer")
      end
    end
  end

  describe "GET 'menu'" do

    describe "when not signed in" do
      it "should redirect to sign in page" do
        get :menu
        response.should redirect_to(signin_path)
      end
    end
    
    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      it "should have the right title" do
        get :menu
        response.should have_selector("title",:content=> @base_title + " | Set menu")
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

  describe "GET 'working'" do

    describe "when not signed in" do
      it "should redirect to sign in page" do
        get :working
        response.should redirect_to(signin_path)
      end
    end
    
    describe "when signed in" do
      before(:each) do
        @user  = Factory(:user)
        @owner = Factory(:user, :email => Factory.next(:email))
        @owner.employ!(@user)
        @ac1   = Factory(:account, :employer => @user, :owner => @owner, :created_at => 5.hour.ago)
        @ac2   = Factory(:account, :employer => @user, :owner => @owner, :table => "AltroMare", :guests => 3, :created_at => 4.hour.ago)
        test_sign_in(@user)
      end

      it "should have the right title" do
        get :working
        response.should have_selector("title", :content=> @base_title + " | Working")
      end

      it "should show the user working accounts" do
        get :working
        response.should have_selector("span.content", :content => @ac1.table)
        response.should have_selector("span.content", :content => @ac2.table)
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
