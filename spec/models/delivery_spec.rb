require 'spec_helper'

describe Delivery do
  before(:each) do
    @user = Factory(:user)
    @menu = Factory(:menu, :user => @user, :content => "primi piatti")
    @attr = {:name => "soute di vongole", :descr => "vongole cotte in olio di oliva", :price => 15 }
  end

  it "should create a new instance given valid attributes" do 
    @menu.deliveries.create!(@attr)
  end

  describe "menu associations" do

    before(:each) do
      @delivery = @menu.deliveries.create(@attr)
    end

    it "should have a menu attribute" do
      @delivery.should respond_to(:menu)
    end

    it "should have a name attribute" do
      @delivery.should respond_to(:name)
    end

    it "should have a descr attribute" do
      @delivery.should respond_to(:descr)
    end

    it "should have a price attribute" do
      @delivery.should respond_to(:price)
    end

    it "should have the right associated menu" do
      @delivery.menu_id.should == @menu.id
      @delivery.menu.should == @menu
    end
  end

  describe "validations" do

    it "should require a menu id" do
      Delivery.new(@attr).should_not be_valid
    end

    it "should require nonblank name" do
      @menu.deliveries.build(:name => "  ").should_not be_valid
    end

    it "should reject long name" do
      @menu.deliveries.build(:name => "a" * 61 ).should_not be_valid
    end
  end
end
