require 'spec_helper'


describe AccountsController do

  render_views
  
  describe "PUT 'update'" do
    before(:each) do
      @owner = Factory(:user)
      @employer = Factory(:user, :email => Factory.next(:email))
      @owner.employ!(@employer)
      @account = Factory(:account, :employer => @employer, :owner => @owner)
      @attrib = { :guests => 15, :table => "12345" }
    end
    
    describe "failure" do
      it "should render the edit page" do
         test_sign_in(@owner)
         @attrib[:table]=nil
         put :update, :id => @account, :account => @attrib
         response.should render_template('edit')
      end
    end

    describe "success" do

      it "should be successfull for owners" do
         test_sign_in(@owner)
         put :update, :id => @account, :account => @attrib
         @account.reload
         @account.table.should == @attrib[:table]
         @account.guests.should == @attrib[:guests]
      end 

      it "should be successfull for employers" do
         test_sign_in(@employer)
         put :update, :id => @account, :account => @attrib
         @account.reload
         @account.table.should == @attrib[:table]
         @account.guests.should == @attrib[:guests]
      end
  
      it "should redirect to 'show' page"  do
         test_sign_in(@employer)
         put :update, :id => @account, :account => @attrib
         response.should render_template('show')
      end
  
      it "should have a flash message" do
         test_sign_in(@employer)
         put :update, :id => @account, :account => @attrib
         flash[:success].should =~ /updated/
      end
    end

    describe "access permissions" do
      before(:each) do
        @other_user=test_sign_in(Factory(:user, :email => Factory.next(:email)))
      end

      it "should fail for other user" do
        put :update, :id => @account, :account => @attrib
        @account.reload
        @account.table.should_not == @attrib[:table]
        @account.guests.should_not == @attrib[:guests]
      end
  
      it "should redirect to 'home' for other user" do
        put :update, :id => @account, :account => @attrib
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @owner = Factory(:user)
      @employer = Factory(:user, :email => Factory.next(:email))
      @owner.employ!(@employer)
      @account = Factory(:account, :employer => @employer, :owner => @owner)
    end
    
    describe "when not signed" do
      it "should redirect to sign in page" do
        get :edit, :id => @account
        response.should redirect_to(signin_path)    
      end
    end
  
    describe "when signed in" do
      before(:each) do
        test_sign_in(Factory(:user, :email => Factory.next(:email)))
      end

      it "should be successfull" do
        get :edit, :id => @account
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @account
        response.should have_selector("title", :content => "Edit account")
      end
    end
    
  end

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
      describe "employer page layout" do
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

        it "should show the orders count" do
          menu = Factory(:menu, :user => @employer)
          del1 = Factory(:delivery, :menu => menu, :price => 11 )
          order1 = Factory(:order, :user => @employer, :account => @account, :delivery => del1, :count => 4 )
          get :show, :id => @account
          response.should have_selector("span.content", :content => order1.delivery.name)
          response.should have_selector("span.content", :content => "4")
        end
  
        it "should have a link to edit page" do
          get :show, :id => @account
          response.should have_selector("a", :href => edit_account_path(@account),
                                         :content => "edit")
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

      describe "owner page layout" do
        before(:each) do
          test_sign_in(@owner)
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

        it "should show the orders count" do
          menu = Factory(:menu, :user => @employer)
          del1 = Factory(:delivery, :menu => menu, :price => 11 )
          order1 = Factory(:order, :user => @employer, :account => @account, :delivery => del1, :count => 4 )
          get :show, :id => @account
          response.should have_selector("span.content", :content => order1.delivery.name)
          response.should have_selector("span.content", :content => "4")
          response.should have_selector("span.content", :content => "11")
          response.should have_selector("span.content", :content => "44")
        end
  
        it "should show the discount, total and service cost" do
          menu = Factory(:menu, :user => @owner)
          del1 = Factory(:delivery, :menu => menu, :price => 11 )
          del2 = Factory(:delivery, :menu => menu, :price => 15 )
          order1 = Factory(:order, :user => @employer, :account => @account, :delivery => del1, :count => 4 )
          order2 = Factory(:order, :user => @employer, :account => @account, :delivery => del2, :count => 2 )
          get :show, :id => @account
          response.should have_selector("span.content", :content => "74")
        end

        it "should have the bill/destroy button" do 
        end
      end

    end
  end
 
  describe "Access Control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end 

    it "should deny access to 'destroy'" do
      post :destroy, :id => 1
      response.should redirect_to(signin_path)
    end 

    it "should deny access to 'update'" do
      put :update, :id => 1
      response.should redirect_to(signin_path)
    end 

    it "should deny access to 'edit'" do
      get :edit, :id => 1
      response.should redirect_to(signin_path)
    end 

    it "should deny access to 'show'" do
      get :show, :id => 1
      response.should redirect_to(signin_path)
    end 
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @owner = Factory(:user, :email => Factory.next(:email))
      end


      it "should not create an account if user is not an employer of owner" do
        attr = { :table => "Rosa", :guests => 10, :owner_id => @owner.id }
        lambda do
          post :create, :account => attr
        end.should_not change(Account, :count)
      end

      it "should render the working page  if user is not an employer of owner" do
        attr = { :table => "Rosa", :guests => 10, :owner_id => @owner.id }
        post :create, :account => attr
        response.should redirect_to root_path
      end

      it "should not create an account if the table is blank" do
        attr = { :table => "", :guests => 10, :owner_id => @owner.id }
        @owner.employ!(@user)
        lambda do
          post :create, :account => attr
        end.should_not change(Account, :count)
      end

      it "should render the working page if the table is blank" do
        attr = { :table => "", :guests => 10, :owner_id => @owner.id }
        @owner.employ!(@user)
        post :create, :account => attr
        response.should redirect_to("/working")
      end

      it "should have a flash error if table is blank" do
         attr = { :table => "", :guests => 10, :owner_id => @owner.id }
         @owner.employ!(@user)
         post :create, :account => attr
         flash[:error].should =~ /account not created/i
      end

      it "should not create an account if the guests is blank" do
        attr = { :table => "Rosa", :guests => "", :owner_id => @owner.id }
        @owner.employ!(@user)
        lambda do
          post :create, :account => attr
        end.should_not change(Account, :count)
      end

      it "should render the working page if the guests is blank" do
        attr = { :table => "Rosa", :guests => "", :owner_id => @owner.id }
        @owner.employ!(@user)
        post :create, :account => attr
        response.should redirect_to("/working")
      end

      it "should have a flash error if guests is blank" do
         attr = { :table => "Rosa", :guests => "", :owner_id => @owner.id  }
         @owner.employ!(@user)
         post :create, :account => attr
         flash[:error].should =~ /account not created/i
      end
    end

    describe "success" do 

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @owner = Factory(:user, :email => Factory.next(:email))
        @owner.employ!(@user)
        @attr = { :table => "Rosa", :guests => 10, :owner_id => @owner.id }
      end

      it "should create an account if user is an employer of owner" do
        lambda do
          post :create, :account => @attr
        end.should change(Account, :count).by(1)
      end

      it "should render the working page" do
          post :create, :account => @attr
          response.should redirect_to("/working")
      end

      it "should have a flash message" do
         post :create, :account => @attr
         flash[:success].should =~ /account created/i
      end
      
    end
  end
end
