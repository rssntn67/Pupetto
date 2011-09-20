require 'spec_helper'

describe Account do
  before(:each) do
    @owner = Factory(:user)
    @employer = Factory(:user, :email => Factory.next(:email))
    @attrib = {:owner_id => @owner.id, :table => "Roma", :guests => 6 } 
    @account = @employer.accounts.build(@attrib)
  end

  it "should create a new instance given valid attributes" do
    @account.save!
  end

  describe "employer and owner method" do
    before(:each) do
      @account.save
    end
    
    it "should have an employer attribute" do
      @account.should respond_to(:employer)
    end

    it "should have the right employer" do
      @account.employer.should == @employer
    end 

    it "should have an owner attribute" do
      @account.should respond_to(:owner)
    end

    it "should have the right owner" do
      @account.owner.should == @owner
    end

    it "should have a table attribute" do
      @account.should respond_to(:table)
    end

    it "should have a guests attribute" do
      @account.should respond_to(:guests)
    end
  end

  describe "validations" do
    it "should require an employer_id" do
      @account.employer_id = nil
      @account.should_not be_valid
    end

    it "should require an owner_id" do
      @account.owner_id = nil
      @account.should_not be_valid
    end

    it "should require a table attribute" do
      @account.table = nil
      @account.should_not be_valid
    end

    it "should require a guests" do
      @account.guests = nil
      @account.should_not be_valid
    end
  end

  describe "order relation" do
    before(:each) do
      @menu=Factory(:menu, :user => @owner)

      @delivery = Factory(:delivery, :menu => @menu)

      @account.save      

      @user=Factory(:user, :email => Factory.next(:email))
      
      @order1=Factory(:order, :user => @user, :account => @account, :delivery => @delivery, :created_at => 20.minute.ago)
      @order2=Factory(:order, :user => @user, :account => @account, :delivery => @delivery, :created_at => 10.minute.ago)
    end    
  
    it "should have an orders attribute" do
      @account.should respond_to(:orders)
    end
 
    it "should have the right orders" do
      @account.orders.should == [@order1, @order2]
    end
  
    it "should destroy associated orders" do
      @account.destroy
      [@order1, @order2].each do |order|
          Order.find_by_id(order.id).should be_nil
      end
    end
  end
  
end
