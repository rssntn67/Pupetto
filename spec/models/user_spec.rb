# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "kloss1",
              :password_confirmation => "kloss1" 
            }
  end
    
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end


  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
       User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
     
    it "should require a matching pass confirm" do 
      User.new(@attr.merge(:password_confirmation => "pippo")).should_not be_valid
    end

    it "should reject short password" do
      short = "a" * 5 
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
  
  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "menu associations" do

    before(:each) do
      @user = User.create(@attr)
      @menu1 = Factory(:menu, :user => @user, :content => "primi piatti")
      @menu2 = Factory(:menu, :user => @user, :content => "secondi piatti")
    end

    it "should have a menus attribute" do
      @user.should respond_to(:menus)
    end

    it "should have the right menus in the right order" do
      @user.menus.should == [@menu1, @menu2]
    end

    it "should destroy associated menus" do
      @user.destroy
      [@menu1, @menu2].each do |menu|
        Menu.find_by_id(menu.id).should be_nil
      end
    end
  end
  
  describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end
  
      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost,
                    :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
      
      it "should include the microposts of followed users" do
        followed = Factory(:user, :email => Factory.next(:email))
        mp3 = Factory(:micropost, :user => followed)
        @user.follow!(followed)
        @user.feed.should include(mp3)
      end
    end
  end 

  describe "orders" do

     before(:each) do
       @user = User.create!(@attr)
       @owner = Factory(:user)
     end
      
     it "should have and orders method" do
       @user.should respond_to(:orders)
     end
  end

  describe "accounts" do
     before(:each) do
       @user = User.create!(@attr)
       @owner = Factory(:user)
       @ac1  = Factory(:account, :employer => @user, :owner => @owner, :created_at => 5.hour.ago)
       @ac2  = Factory(:account, :employer => @user, :owner => @owner, :table => "AltroMare", :guests => 3, :created_at => 4.hour.ago)
     end

     it "should have an accounts method" do
       @user.should respond_to(:accounts)
     end

     it "should have an owneraccounts method" do
       @user.should respond_to(:owneraccounts)
     end

     it "should have the right account in the right order" do
       @user.accounts.should == [@ac1, @ac2]
     end

     it "owner should have the right account in the right order" do
       @owner.owneraccounts.should == [@ac1, @ac2]
     end

     it "should destroy associated accounts" do
       @user.destroy
       [@ac1, @ac2].each do |account|
         Account.find_by_id(account.id).should be_nil
       end
     end

     it "owner should destroy associated accounts" do
       @owner.destroy
       [@ac1, @ac2].each do |account|
         Account.find_by_id(account.id).should be_nil
       end
     end


     describe "status working" do
       before(:each) do
         @owner.employ!(@user) 
         @third_user = Factory(:user, :email => Factory.next(:email))
         @owner.employ!(@third_user)
         @ac3  = Factory(:account, :employer => @third_user, 
                         :owner => @owner, :table => "AltaMarea", 
                         :guests => 5, :created_at => 2.hour.ago)
         @ac4  = Factory(:account, :employer => @third_user, 
                         :owner => @owner, :table => "AltroMare", 
                         :guests => 3, :created_at => 1.hour.ago)
       end

       it "should have a working method" do
         @user.should respond_to(:working)
       end
       
       it "should include the account created by all employers" do
         @user.working.include?(@ac1).should be_true
         @user.working.include?(@ac2).should be_true
         @user.working.include?(@ac3).should be_true
         @user.working.include?(@ac4).should be_true
       end 

       it "should not include an account of another owner" do
         @another_owner = Factory(:user, :email => Factory.next(:email))
         @ac5  = Factory(:account, :employer => @third_user, 
                         :owner => @another_owner, :table => "AltroMare", 
                         :guests => 3, :created_at => 1.hour.ago)
         @user.working.include?(@ac5).should be_false 
       end
     end
  end

  describe "workrelations" do

    before(:each) do
      @user = User.create!(@attr)
      @employer = Factory(:user)
    end

    it "should have a workrelations method" do
      @user.should respond_to(:workrelations)
    end

    it "should have a employers method" do
      @user.should respond_to(:employers)
    end

    it "should employ another user" do
      @user.employ!(@employer)
      @user.should be_employ(@employer)
    end

    it "should include the employer user in the employers array" do
      @user.employ!(@employer)
      @user.employers.should include(@employer)
    end

    it "should have an unemploy! method" do
      @user.should respond_to(:unemploy!)
    end

    it "should unemploy a user" do
      @user.employ!(@employer)
      @user.unemploy!(@employer)
      @user.should_not be_employ(@employer)
    end

    it "should have a reverse_workrelations method" do
      @user.should respond_to(:reverse_workrelations)
    end

    it "should have an owners method" do
      @user.should respond_to(:owners)
    end

    it "should include the owner in the owners array" do
      @user.employ!(@employer)
      @employer.owners.should include(@user)
    end
  end

  describe "relationships" do

    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end

    it "should have a following method" do
      @user.should respond_to(:following)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it "should have an unfollow! method" do
      @followed.should respond_to(:unfollow!)
    end

    it "should unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
  end
end
