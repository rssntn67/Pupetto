require 'spec_helper'

describe Workrelation do
  require 'spec_helper'

  before(:each) do
    @owner = Factory(:user)
    @employer = Factory(:user, :email => Factory.next(:email))

    @workrelation = @owner.workrelations.build(:employer_id => @employer.id)
  end

  it "should create a new instance given valid attributes" do
    @workrelation.save!
  end
  
  describe "user methods" do

    before(:each) do
      @workrelation.save
    end

    it "should have a owner attribute" do
      @workrelation.should respond_to(:owner)
    end

    it "should have the right owner" do
      @workrelation.owner.should == @owner
    end

    it "should have a employer attribute" do
      @workrelation.should respond_to(:employer)
    end

    it "should have the right employer user" do
      @workrelation.employer.should == @employer
    end
  end

  describe "validations" do

    it "should require a owner" do
      @workrelation.owner_id = nil
      @workrelation.should_not be_valid
    end

    it "should require an employer_id" do
      @workrelation.employer_id = nil
      @workrelation.should_not be_valid
    end
  end
end
