require 'spec_helper'

describe Menu do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.menus.create!(@attr)
  end

  describe "delivery associations" do
    before(:each) do
      @menu = @user.menus.create(@attr)
      @delivery1 = Factory(:delivery, :menu => @menu)
      @delivery2 = Factory(:delivery, :menu => @menu, :name => "ahahah")
    end

    it "should have a deliveries attribute" do
      @menu.should respond_to(:deliveries)
    end

    it "should have the right deliveries" do
      @menu.deliveries.should == [@delivery1,@delivery2]
    end
    
    it "should destroy associated deliveries" do
      @menu.destroy
      [@delivery1,@delivery2].each do |delivery|
        Delivery.find_by_id(delivery.id).should be_nil
      end
    end

  end

  describe "user associations" do

    before(:each) do
      @menu = @user.menus.create(@attr)
    end

    it "should have a user attribute" do
      @menu.should respond_to(:user)
    end

    it "should have the right associated user" do
      @menu.user_id.should == @user.id
      @menu.user.should == @user
    end
  end

  describe "validations" do

    it "should require a user id" do
      Menu.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.menus.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.menus.build(:content => "a" * 41).should_not be_valid
    end
  end

end
