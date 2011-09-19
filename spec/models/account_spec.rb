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
  
end
