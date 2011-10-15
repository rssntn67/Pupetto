require 'spec_helper'

describe OrdersController do

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get 'destroy'
      response.should be_success
    end
  end

  describe "GET 'increase'" do
    it "should be successful" do
      get 'increase'
      response.should be_success
    end
  end

  describe "GET 'decrease'" do
    it "should be successful" do
      get 'decrease'
      response.should be_success
    end
  end

end
