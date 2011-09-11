require 'spec_helper'

describe WorkrelationsController do

  describe "access control" do

    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @employer = Factory(:user, :email => Factory.next(:email))
    end

    it "should create a workrelation" do
      lambda do
        post :create, :workrelation => { :employer_id => @employer }
        response.should be_redirect
      end.should change(Workrelation, :count).by(1)
    end

    it "should create a workrelation using ajax" do
      lambda do
        xhr :post, :create, :workrelation => { :employer_id => @employer }
        response.should be_success
      end.should change(Workrelation, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @employer = Factory(:user, :email => Factory.next(:email))
      @user.employ!(@employer)
      @workrelation = @user.workrelations.find_by_employer_id(@employer)
    end

    it "should destroy a workrelation" do
      lambda do
        delete :destroy, :id => @workrelation
        response.should be_redirect
      end.should change(Workrelation, :count).by(-1)
    end

    it "should destroy a workrelation using Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @workrelation
        response.should be_success
      end.should change(Workrelation, :count).by(-1)
    end
  end
end
